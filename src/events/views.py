from urlparse import parse_qs

from django.shortcuts import render
from django.conf import settings
from django.http import HttpResponse, JsonResponse
from django.shortcuts import redirect
from django.contrib.sites.models import Site
from django.core.urlresolvers import reverse
from django.contrib.auth.decorators import login_required
import requests
import facebook

from settings.models import Setting

def get_facebook_redirect_uri():
    return "http://%s%s" % (Site.objects.get_current().domain,
                            reverse('events_get_fb_page_token'))

@login_required
def get_user_access_token(request):
    url = "https://www.facebook.com/dialog/oauth?client_id=%s&redirect_uri=%s&granted_scopes=manage_pages" % (
        settings.FB_CLIENT_ID,
        get_facebook_redirect_uri())
    return redirect(url)

@login_required
def get_page_access_token(request):
    code = request.GET.get("code", None)
    if code:
        url = "https://graph.facebook.com/oauth/access_token"

        response = requests.get(url, params={
            # "grant_type": "fb_exchange_token",
            "client_id": settings.FB_CLIENT_ID,
            "client_secret": settings.FB_CLIENT_SECRET,
            "code": code,
            "redirect_uri": get_facebook_redirect_uri()
        })

        access_token = parse_qs(response.text)["access_token"][0]

        # get long lived access token
        response = requests.get(url, params={
            "grant_type": "fb_exchange_token",
            "client_id": settings.FB_CLIENT_ID,
            "client_secret": settings.FB_CLIENT_SECRET,
            "fb_exchange_token": access_token,
            "redirect_uri": get_facebook_redirect_uri(),
        })
        access_token = parse_qs(response.text)["access_token"][0]

        graph = facebook.GraphAPI(access_token=access_token)
        accounts = graph.get_object("me/accounts")['data']
        pr_account = [x for x in accounts if x['id'] == settings.FB_PAGE_ID][0]

        Setting.objects.create(
            key="fb_page_access_token", value=pr_account['access_token'])
        return redirect("/admin")

def facebook_events(request):
    graph = facebook.GraphAPI(
        access_token=Setting.objects.get(key="fb_page_access_token").value)
    events = graph.get_object("%s/events" % settings.FB_PAGE_ID)
    return JsonResponse(events)
