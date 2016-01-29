"""pictureroom URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.9/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from django.contrib.auth.decorators import login_required

from events import views as events_views

urlpatterns = [
    url(r'^get-fb-token/$', login_required(
        events_views.FacebookTokenView.as_view()), {},
        name='events_get_fb_token'),
    url(r'^api/v1/events/$', events_views.facebook_events, {}, 'events_facebook'),
    url(r'^admin/', admin.site.urls),
]