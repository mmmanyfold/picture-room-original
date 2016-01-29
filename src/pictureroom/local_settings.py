DEBUG = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'pictureroom',
        'USER': 'vagrant',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}

FB_CLIENT_ID = "1107634402609958"
FB_CLIENT_SECRET = "b6d842a7025672b0a6b1c525881b4115"
