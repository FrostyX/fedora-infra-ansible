from werkzeug.middleware.proxy_fix import ProxyFix
from noggin.app import create_app
application = create_app()
# application.wsgi_app.add_files('/etc/noggin/well-known-files', prefix='.well-known/')
application.wsgi_app = ProxyFix(application.wsgi_app, x_proto=1, x_host=1)
