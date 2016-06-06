#!/usr/bin/env python
from __future__ import print_function

"""
This is a python interface for using Openshift-2.0 REST
version = 2.0  changed the basic support to use the new requests module
 (http://docs.python-requests.org/en/latest/index.html)

Source: https://github.com/openshift/python-interface/raw/master/oshift/__init__.py

"""

import os
import sys
import logging
from optparse import OptionParser
import time
import traceback
import json

import base64
import requests


class OpenShiftException(BaseException):
    pass


class OpenShiftLoginException(OpenShiftException):
    """Authorization failed."""
    pass

class OpenShiftAppException(OpenShiftException):
    """App not found."""
    pass

class OpenShiftNullDomainException(OpenShiftException):
    """User's domain hasn't been initialized."""
    pass


class OpenShift500Exception(OpenShiftException):
    """Internal Server Error"""
    pass

#### set this to True if we want to enable performance analysis
DOING_PERFORMANCE_ANALYSIS = False

global log


def config_logger():
    # create formatter
    formatter = logging.Formatter("%(levelname)s [%(asctime)s] %(message)s",
                                  "%H:%M:%S")
    logger = logging.getLogger("dump_logs")
    log_formatter = logging.Formatter(
        "%(name)s: %(asctime)s - %(levelname)s: %(message)s")

    stream_handler = logging.StreamHandler(sys.stdout)
    stream_handler.setFormatter(formatter)
    stream_handler.setLevel(logging.DEBUG)
    logger.setLevel(logging.DEBUG)
    logger.addHandler(stream_handler)
    return logger


def config_parser():
    # these are required options.
    parser.set_defaults(VERBOSE=False)
    parser.set_defaults(DEBUG=False)
    parser.add_option("-d", action="store_true", dest="DEBUG", help="enable DEBUG (default true)")
    parser.add_option("-i", "--ip", default="openshift.redhat.com", help="ip addaress of your devenv")
    parser.add_option("-v", action="store_true", dest="VERBOSE", help="enable VERBOSE printing")
    parser.add_option("-u", "--user", default=None, help="User name")
    parser.add_option("-p", "--password", default=None, help="RHT password")
    (options, args) = parser.parse_args()

    if options.user is None:
        options.user = os.getenv('OPENSHIFT_user_email')

    if options.password is None:
        options.password = os.getenv('OPENSHIFT_user_passwd')

    return options, args
log = config_logger()
parser = OptionParser()


# helper function for to measure timedelta.
def timeit(method):

    def timed(*args, **kw):
        ts = time.time()
        result = method(*args, **kw)
        te = time.time()

        log.info("%r (%r, %r) %2.2f sec" % (method.__name__, args, kw, te-ts))
        return result, te-ts

    return timed


class conditional_decorator(object):
    def __init__(self, dec, condition):
        self.decorator = dec
        self.condition = condition

    def __call__(self, func):
        if not self.condition:
            return func
        else:
            return self.decorator(func)


class RestApi(object):
    """
    A base connection class to derive from.
    """

    proto = 'https'
    host = '127.0.0.1'
    port = 443
    username = None
    password = None
    headers = None
    response = None
    base_uri = None
    verbose = False
    debug = False

    def __init__(self, host=None, port=443, username=username, password=password,
                 debug=False, verbose=False, proto=None, headers=None):
        if proto is not None:
            self.proto = proto

        if host is not None:
            self.host = host

        if username:
            self.username = username

        if password:
            self.password = password

        if headers:
            self.headers = headers

        if verbose:
            self.verbose = verbose

        self.debug = debug
        self.base_uri = self.proto + "://" + host + "/broker/rest"


    def _get_auth_headers(self, username=None, password=None):
        if username:
            self.username = username

        if password:
            self.password = password

        return (self.username, self.password)

    def request(self, url, method, headers=None, params=None):
        """
        wrapper method for Requests' methods
        """
        if url.startswith("https://") or url.startswith("http://"):
            self.url = url  # self.base_uri + url
        else:
            self.url = self.base_uri + url
        log.debug("URL: %s" % self.url)
        auth = (self.username, self.password)  # self._get_auth_headers()
        #auth = self._get_auth_headers()
        _headers = self.headers or {}
        if headers:
            _headers.update(headers)
        if 'OPENSHIFT_REST_API' in os.environ:
            user_specified_api_version = os.environ['OPENSHIFT_REST_API']
            api_version = "application/json;version=%s" % user_specified_api_version

            _headers['Accept'] = api_version

        self.response = requests.request(
            auth=None if None in auth else auth,
            method=method, url=self.url, params=params,
            headers=_headers, timeout=130, verify=False
        )

        try:
            raw_response = self.response.raw
        except Exception as e:
            print("-"*80, file=sys.stderr)
            traceback.print_exc(file=sys.stderr)
            print("-"*80, file=sys.stderr)
            raise e

        self.data = self.response.json()
        # see https://github.com/kennethreitz/requests/blob/master/requests/status_codes.py
        if self.response.status_code == requests.codes.internal_server_error:
            raise OpenShift500Exception('Internal Server Error: %s' % self.data)

        if self.response.status_code == (200 or 201):
            print("-"*80, file=sys.stderr)
            log.debug("status:  %s" % self.response.status_code)
            #log.debug("msg: %s" % self.data()['messages'][0]['text'])
            # the raw_response is not available
            #log.debug("raw:  %s"%raw_response)
            print("-"*80, file=sys.stderr)
        return (self.response.status_code, self.data)


class Openshift(object):
    """
    wrappers class around REST API so use can use it with python
    """
    rest = None
    user = None
    passwd = None

    def __init__(self, host, user=None, passwd=None, debug=False, verbose=False, logger=None, proto=None, headers=None):
        if user:
            self.user = user
        if passwd:
            self.passwd = passwd
        if logger:
            global log
            log = logger
        self.rest = RestApi(host=host, username=self.user, password=self.passwd, debug=debug, verbose=verbose, proto=proto, headers=headers)
        if 'OPENSHIFT_REST_API' in os.environ:
            self.REST_API_VERSION = float(os.environ['OPENSHIFT_REST_API'])
        else:
            # just get the latest version returned from the Server
            api_version, api_version_list = self.api_version()
            self.REST_API_VERSION = api_version

    def get_href(self, top_level_url, target_link, domain_name=None):
        status, res = self.rest.request(method='GET', url=top_level_url)
        index = target_link.upper()
        if status == 'Authorization Required':
            #log.error("Authorization failed. (Check your credentials)")
            raise OpenShiftLoginException('Authorization Required')

        if domain_name is None:
            if self.rest.response.json()['data']:
                res = self.rest.response.json()['data'][0]['links'][index]

                return (res['href'], res['method'])
            else:
                raise OpenShiftNullDomainException("No domain has been initialized.")
                #return ('Not Found', self.rest.response.json)

        else:  # domain name is specified, now find a match
            json_data = self.rest.response.json()['data']
            if json_data:
                for jd in json_data:
                    if jd['name'] == domain_name:
                        res = jd['links'][index]
                        return (res['href'], res['method'])
                ### if here, then user has given a domain name that does not match what's registered with the system
                return("Not Found", None)
            else:
                return(None, None)

    ##### /user  (sshkey)
    #@conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def get_user(self):
        log.debug("Getting user information...")
        (status, raw_response) = self.rest.request(method='GET', url='/user')

        if status == 'OK':
            return (status, self.rest.response.json()['data']['login'])
        else:
            return (status, raw_response)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def keys_list(self):
        log.debug("Getting ssh key information...")
        (status, raw_response) = self.rest.request(method='GET', url='/user/keys')
        return (status, raw_response)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def key_add(self, **kwargs):
        """
        params: {name, type, key_path}
        """
        ssh_key_str = None
        if 'key_str' in kwargs:
            ssh_key_str = kwargs['key_str']
        else:
            if 'key' not in kwargs:
                # use a default path
                sshkey = '~/.ssh/id_rsa.pub'
            else:
                sshkey = kwargs['key']
            ssh_path = os.path.expanduser(sshkey)
            ssh_key_str = open(ssh_path, 'r').read().split(' ')[1]

        if 'name' not in kwargs:

            kwargs['name'] = 'default'

        if 'type' not in kwargs:
            kwargs['type'] = 'ssh-rsa'

        data_dict = {
            'name': kwargs['name'],
            'type': kwargs['type'],
            'content': ssh_key_str
        }

        params = data_dict
        status, raw_response = self.rest.request(method='POST', url='/user/keys', params=params)
        return (status, raw_response)

    ##### /domains
    #@conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    # TODO: should the rhlogin really be hardcoded in this function?
    def domain_create(self, name, rhlogin='nate@appsembler.com'):
        log.debug("Creating domain '%s'" % name)
        params = {
            'id': name,
            'rhlogin': rhlogin
        }

        status, res = self.rest.request(method='POST', url='/domains', params=params)
        return (status, res)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def domain_delete(self, domain_name=None, force=True):
        """ destroy a user's domain, if no name is given, figure it out"""
        if domain_name is None:
            status, domain_name = self.domain_get()

        url, method = self.get_href('/domains', 'delete', domain_name)
        log.info("URL: %s" % url)
        #res = self.rest.response.data[0]['links']['DELETE']
        if force:
            params = {'force': 'true'}
        if url:
            return self.rest.request(method=method, url=url, params=params)
        else:  # problem
            return (url, self.rest.response.raw)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def domain_get(self, name=None):
        log.info("Getting domain information...")
        url, method = self.get_href('/domains', 'get', name)
        if url == 'Not Found':
            return ('Not Found', None)
        else:
            (status, raw_response) = self.rest.request(method=method, url=url)
            if status == 200:
                if self.REST_API_VERSION < 1.6:
                    domain_index_name = 'id'
                else:
                    domain_index_name = 'name'
                return (status, self.rest.response.json()['data'][domain_index_name])

    def domain_update(self, new_name):
        params = {'id': new_name}
        url, method = self.get_href("/domains", 'update')
        (status, res) = self.rest.request(method=method, url=url, params=params)
        return (status, res)

    def app_list(self):
        url, method = self.get_href('/domains', 'list_applications')
        (status, res) = self.rest.request(method=method, url=url)
        return (status, self.rest.response.json()['data'])

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_create(self, app_name, app_type, scale='false', init_git_url=None):
        url, method = self.get_href('/domains', 'add_application')
        valid_options = self.rest.response.json()['data'][0]['links']['ADD_APPLICATION']['optional_params'][0]['valid_options']
        #if app_type not in valid_options:
        #    log.error("The app type you specified '%s' is not supported!" % app_type)
        #    log.debug("supported apps types are: %s" % valid_options)

        try:
            json_data = json.loads(json.dumps(app_type))
        except:
            json_data = None

        if json_data:
            # translate json data into list
            is_dict = all(isinstance(i, dict) for i in json_data)
            cart_info = []

            if is_dict:
                # need to construct a cart as a list from dictionary
                for data in json_data:
                    cart_info.append(data['name'])
            else:
                cart_info = json_data

        else:
            cart_info.append(app_type)

        data_dict = {
            'name': app_name,
            'cartridges[]': cart_info,
            'scale': scale,
        }

        if init_git_url:
            data_dict['initial_git_url'] = init_git_url

        params = data_dict
        #log.debug("URL: %s, METHOD: %s" % (url, method))
        (status, res) = self.rest.request(method=method, url=url, params=params)
        return (status, res)

    ##### /cartridges
    def cartridges(self):
        (status, raw_response) = self.rest.request(method='GET', url='/cartridges')
        if status == 'OK':
            # return a list of cartridges that are supported
            return (status, self.rest.response.json()['data'])
        else:
            return (status, raw_response)

    ##### /api  get a list of support operations
    def api(self):
        #log.debug("Getting supported APIs...")
        (status, raw_response) = self.rest.request(method='GET', url='/api')
        return (status, raw_response)

    def api_version(self):
        # return the current version being used and the list of supported versions
        status, res = self.api()
        return (float(res['version']), res['supported_api_versions'])

    ##### helper functions
    def do_action(self, kwargs):
        op = kwargs['op_type']
        if op == 'cartridge':
            status, res = self.cartridge_list(kwargs['app_name'])
        elif op == 'keys':
            status, res = self.keys_list()

        json_data = self.rest.response.json()
        action = kwargs['action']
        name = kwargs['name']
        raw_response = None
        for data in json_data['data']:
            if data['name'] == name:
                params = data['links'][action]
                log.debug("Action: %s" % action)
                if len(params['required_params']) > 0:
                    # construct require parameter dictionary
                    data = {}
                    for rp in params['required_params']:
                        param_name = rp['name']
                        if kwargs['op_type'] == 'cartridge':
                            data[param_name] = action.lower()
                        else:
                            data[param_name] = kwargs[param_name]
                    data = data
                else:
                    data = None
                (status, raw_response) = self.rest.request(method=params['method'],
                                                           url=params['href'],
                                                           params=data)
                return (status, self.rest.response.json())

        return (status, raw_response)

    #### application tempalte
    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_templates(self):
        (status, raw_response) = self.rest.request(method='GET', url='/application_template')
        if status == 'OK':
            return (status, self.rest.response.json())
        else:
            return (status, raw_response)

    ##### keys
    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def key_delete(self, key_name):
        """
        li.key_delete('ssh_key_name')

        """
        params = {"action": 'DELETE', 'name': key_name, "op_type": 'keys'}
        return self.do_action(params)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def key_update(self, kwargs):  # key_name, key_path, key_type='ssh-rsa'):
        """
        li.key_update({'name': 'new_key_name', 'key': new_key_path})

        """
        key_path = kwargs['key']
        key_name = kwargs['name']
        if 'key_type' in kwargs:
            key_type = kwargs['key_type']
        else:
            key_type = 'ssh-rsa'
        ssh_path = os.path.expanduser(key_path)
        ssh_key_str = open(ssh_path, 'r').read().split(' ')[1]

        params = {'op_type': 'keys', 'action': 'UPDATE', 'name': key_name, 'content': ssh_key_str, 'type': key_type}
        return self.do_action(params)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def key_get(self, name):
        """
        li.key_get('target_key_name')
        returns the actual key content :$
        """
        params = {'action': 'GET', 'name': name, 'op_type': 'keys'}
        url = "/user/keys/" + name
        (status, raw_response) = self.rest.request(method='GET', url=url)
        if status == 'OK':
            return status, self.rest.response.json()['data']
        else:
            return (status, raw_response)

    def key_action(self, kwargs):
        status, res = self.keys_list()
        json_data = self.rest.response.json()
        action = kwargs['action']
        name = kwargs['name']
        for data in json_data['data']:
            if data['name'] == name:
                params = data['links'][action]
                log.debug("Action: %s" % action)
                if len(params['required_params']) > 0:
                    # construct require parameter dictionary
                    data = {}
                    for rp in params['required_params']:
                        param_name = rp['name']
                        data[param_name] = kwargs[param_name]
                    data = data
                else:
                    data = None
                break
        (status, raw_response) = self.rest.request(method=params['method'],
                                                   url=params['href'],
                                                   params=data)
        return (status, raw_response)

    ##### apps
    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_create_scale(self, app_name, app_type, scale, init_git_url=None):
        self.app_create(app_name=app_name, app_type=app_type, scale=scale, init_git_url=init_git_url)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_delete(self, app_name):
        params = {'action': 'DELETE', 'app_name': app_name}
        return self.app_action(params)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_start(self, app_name):
        params = {"action": 'START', 'app_name': app_name}
        return self.app_action(params)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_stop(self, app_name):
        params = {"action": 'STOP', 'app_name': app_name}
        return self.app_action(params)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_restart(self, app_name):
        params = {"action": 'RESTART', 'app_name': app_name}
        return self.app_action(params)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_force_stop(self, app_name):
        params = {"action": 'FORCE_STOP', 'app_name': app_name}
        return self.app_action(params)

    @conditional_decorator(timeit, DOING_PERFORMANCE_ANALYSIS)
    def app_get_descriptor(self, app_name):
        params = {'action': 'GET', 'app_name': app_name}
        return self.app_action(params)

    #############################################################
    # event related functions
    #############################################################
    def app_scale_up(self, app_name):
        params = {'action': 'SCALE_UP', 'app_name': app_name}
        return self.app_action(params)

    def app_scale_down(self, app_name):
        params = {'action': 'SCALE_DOWN', 'app_name': app_name}
        return self.app_action(params)

    def app_add_alias(self, app_name, alias):
        params = {'action': 'ADD_ALIAS', 'app_name': app_name, 'alias': alias}
        return self.app_action(params)

    def app_remove_alias(self, app_name, alias):
        params = {'action': 'REMOVE_ALIAS', 'app_name': app_name, 'alias': alias}
        return self.app_action(params)

    def app_get_estimates(self):
        url, method = self.get_href('/estimates', 'get_estimate')
        (status, res) = self.rest.request(method=method, url=url)
        return (status, self.rest.response.json()['data'])

        #params = {'action': 'GET_ESTIMATE'}
        #return self.app_action(params)

    def app_action(self, params):
        """ generic helper function that is capable of doing all the operations
        for application
        """
        # step1. find th url and method
        status, res = self.app_list()

        app_found = False
        action = params['action']
        if 'app_name' in params:
            app_name = params['app_name']
        if 'cartridge' in params:
            cart_name = params['cartridge']

        for app in res:
        #for app in res['data']:

            if app['name'] == app_name:
                # found match, now do your stuff
                params_dict = app['links'][action]
                method = params_dict['method']
                log.info("Action: %s" % action)
                data = {}
                if len(params_dict['required_params']) > 0:
                    param_name = params_dict['required_params'][0]['name']
                    rp = params_dict['required_params'][0]
                    #data[param_name] = cart_name #'name'] = rp['name']
                    for rp in params_dict['required_params']:
                        # construct the data
                        param_name = rp['name']
                        if param_name == 'event':
                            if isinstance(rp['valid_options'], list):
                                data[param_name] = rp['valid_options'][0]
                            else:
                                data[param_name] = rp['valid_options']
                        else:
                            data[param_name] = params[param_name]  # cart_name #params['op_type']
                            #data[param_name] = params[param_name]
                    data = data
                else:
                    data = None
                req_url = params_dict['href']
                (status, raw_response) = self.rest.request(method=method, url=req_url, params=data)
                app_found = True
                return (status, raw_response)
        if not app_found:
            raise OpenShiftAppException("Can not find the app matching your request")
            #log.error("Can not find app matching your request '%s'" % app_name)
            #return ("Error", None)

    def get_gears(self, app_name, domain_name=None):
        """ return gears information """
        params = {"action": 'GET_GEAR_GROUPS', 'app_name': app_name}
        return self.app_action(params)

    ################################
    # cartridges
    ################################
    def cartridge_list(self, app_name):
        params = {"action": 'LIST_CARTRIDGES', 'app_name': app_name}
        return self.app_action(params)

    def cartridge_add(self, app_name, cartridge):
        params = {"action": 'ADD_CARTRIDGE', 'app_name': app_name,
            'cartridge': cartridge}
        status, res = self.app_action(params)
        return (status, self.rest.response.json()['messages'])

    def cartridge_delete(self, app_name, name):
        params = {"action": 'DELETE', 'name': name, "op_type": 'cartridge', 'app_name': app_name}
        return self.do_action(params)

    def cartridge_start(self, app_name, name):
        params = {"action": 'START', 'name': name, "op_type": 'cartridge', 'app_name': app_name}
        return self.do_action(params)

    def cartridge_stop(self, app_name, name):
        params = {"action": 'STOP', 'name': name, "op_type": 'cartridge', 'app_name': app_name}
        return self.do_action(params)

    def cartridge_restart(self, app_name, name):
        params = {"action": 'RESTART', 'name': name, "op_type": 'cartridge', 'app_name': app_name}
        return self.do_action(params)

    def cartridge_reload(self, app_name, name):
        params = {"action": 'RELOAD', 'name': name, "op_type": 'cartridge', 'app_name': app_name}
        return self.do_action(params)

    def cartridge_get(self, app_name, name):
        params = {"action": 'GET', 'name': name, "op_type": 'cartridge', 'app_name': app_name}
        return self.do_action(params)

    def app_template_get(self):
        """ return a list of application template from an app """
        status, res = self.rest.request(method='GET', url='/application_template')
        if status == 'OK':
            return (status, self.rest.response.json()['data'])
        else:
            return (status, res)


def sortedDict(adict):
    keys = list(adict.keys())
    keys.sort()
    return map(adict.get, keys)


def perf_test(li):
    cart_types = ['php-5.3']
    od = {
        1: {'name': 'app_create', 'params': {'app_name': 'perftest'}},
        #2: {'name': 'app_delete', 'params': {'app_name': 'perftest'}},
    }
    sod = sortedDict(od)
    #li.domain_create('blahblah')
    cart_types = ['php-5.3']  # 'php-5.3', 'ruby-1.8', 'jbossas-7']
    for cart in cart_types:
        for action in sod:
            method_call = getattr(li, action['name'])
            k, v = list(action['params'].items()[0])
            if action['name'] == 'app_create':
                method_call(v, cart)
            else:
                method_call(v)


if __name__ == '__main__':
    (options, args) = config_parser()
    li = Openshift(host=options.ip, user=options.user, passwd=options.password,
        debug=options.DEBUG,verbose=options.VERBOSE)
    status, res = li.domain_get()
    self.info('xxx', 1)
    #status, res = li.app_create(app_name="app1", app_type=["ruby-1.8", "mysql-5.1"], init_git_url="https://github.com/openshift/wordpress-example")
    #status, res = li.app_create(app_name="app2", app_type="php-5.3", init_git_url="https://github.com/openshift/wordpress-example")
    #status, res = li.app_create(app_name="app3", app_type=[{"name": "ruby-1.8"}, {"name": "mysql-5.1"}], init_git_url="https://github.com/openshift/wordpress-example")

