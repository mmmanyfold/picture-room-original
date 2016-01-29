default['pictureroom']['user'] = 'pictureroom'
default['pictureroom']['app_root'] = "/home/#{node['pictureroom']['user']}/app"
default['pictureroom']['gunicorn_settings_path'] = 'pictureroom/gunicorn_settings.py'
default['pictureroom']['wsgi_path'] = 'pictureroom.wsgi:application'
default['pictureroom']['hostname'] = 'pictureroom.udbhavgupta.com'
default['pictureroom']['git_repo'] = "git@github.com:udbhav/pictureroom.git"
default['pictureroom']['git_branch'] = "master"
default['pictureroom']['db']['name'] = "pictureroom"
default['pictureroom']['db']['user'] = "pictureroom"
default['pictureroom']['']['user'] = "pictureroom"

default['pictureroom']['rabbitmq'] = {
  'user' => 'pictureroom',
  'password' => 'prrmq',
}

default['pictureroom']['local_settings'] = {
  'debug' => "False",
  'logging' => {
    'level' => 'INFO'
  }
}
