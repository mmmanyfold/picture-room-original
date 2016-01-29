from urlparse import parse_qs

from django.shortcuts import render
from django import forms
from django.views.generic.edit import FormView
from django.conf import settings
from django.http import HttpResponse, JsonResponse
import requests
import facebook

from settings.models import Setting

class FacebookTokenForm(forms.Form):
    user_access_token = forms.CharField()

class FacebookTokenView(FormView):
    form_class = FacebookTokenForm
    template_name = "events/facebook_token_form.html"
    success_url = "/"

    def form_valid(self, form):
        url = "https://graph.facebook.com/oauth/access_token"

        response = requests.get(url, params={
            "grant_type": "fb_exchange_token",
            "client_id": settings.FB_CLIENT_ID,
            "client_secret": settings.FB_CLIENT_SECRET,
            "fb_exchange_token": form.cleaned_data["user_access_token"],
            "redirect_uri": settings.FB_REDIRECT_URI
        })
        access_token = parse_qs(response.text)["access_token"][0]
        graph = facebook.GraphAPI(access_token=access_token)
        accounts = graph.get_object("me/accounts")['data']
        pr_account = [x for x in accounts if x['id'] == settings.FB_PAGE_ID][0]

        Setting.objects.create(
            key="fb_page_access_token", value=pr_account['access_token'])
        return HttpResponse(pr_account)

def facebook_events(request):
    graph = facebook.GraphAPI(
        access_token=Setting.objects.get(key="fb_page_access_token").value)
    events = graph.get_object("%s/events" % settings.FB_PAGE_ID)
    return JsonResponse(events)
