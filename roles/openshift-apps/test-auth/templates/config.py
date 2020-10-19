#
# This is the config file for Test Auth as intended to be used in OpenShift
#


# Deployed to a subpath
# APPLICATION_ROOT = '/test-auth/'

# Cookies
SECRET_KEY = "{{ test_auth_session_secret }}"
SESSION_COOKIE_NAME = 'test-auth'
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SECURE = True

# Auth
OIDC_CLIENT_SECRETS = "/etc/test-auth/oidc.json"
OIDC_SCOPES = ['openid', 'email', 'profile', 'https://id.fedoraproject.org/scope/groups', 'https://id.fedoraproject.org/scope/agreements']
OPENID_ENDPOINT = "https://id{{ env_suffix }}.fedoraproject.org/openid/"
