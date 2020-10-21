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
OPENID_ENDPOINT = "https://id{{ env_suffix }}.fedoraproject.org/openid/"
FAS_OPENID_ENDPOINT = "https://id{{ env_suffix }}.fedoraproject.org/openid/"
