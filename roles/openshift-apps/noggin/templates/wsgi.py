from werkzeug.middleware.proxy_fix import ProxyFix
from noggin.app import app as application
# application.wsgi_app.add_files('/etc/noggin/well-known-files', prefix='.well-known/')
application.wsgi_app = ProxyFix(application.wsgi_app, x_proto=1, x_host=1)
