# -*- coding: utf-8 -*-

import hyperkitty
import postorius

from django.conf.urls import patterns, include, url
from django.conf import settings

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

from django.core.urlresolvers import reverse_lazy
from django.views.generic import RedirectView

urlpatterns = patterns('',
    url(r'^$', RedirectView.as_view(
        url=reverse_lazy('hyperkitty.views.index.index'),
        permanent=True)),
    #url(r'^$', 'postorius.views.list_index'),
    url(r'^admin/', include('postorius.urls')),
    url(r'^archives/', include('hyperkitty.urls')),
    # Social Auth
    url(r'', include('social.apps.django_app.urls', namespace='social')),
    # BrowserID
    url(r'', include('django_browserid.urls')),
)
