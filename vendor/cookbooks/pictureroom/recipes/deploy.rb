execute "git pull" do
  command "git pull origin #{node['pictureroom']['git_branch']}"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end

execute "git checkout" do
  command "git checkout #{node['pictureroom']['git_branch']}"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end

# python requirements
execute "python_requirements" do
  command "env/bin/pip install -r requirements.txt"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end

# local_settings.py
settings = {
  "Debug" => node['pictureroom']['local_settings']['debug'],
}

template "#{node['pictureroom']['app_root']}/src/pictureroom/local_settings.py" do
  source "local_settings.py.erb"
  owner node['pictureroom']['user']
  variables({
      settings: settings, db: node['pictureroom']['db'],
      rabbitmq: node['pictureroom']['rabbitmq'],
      hostname: node['pictureroom']['hostname'],
      log_level: node['pictureroom']['local_settings']['logging']['level'],
    })
end

# clean up .pyc
execute "find . -name \*.pyc -delete" do
  cwd node['pictureroom']['app_root']
end

# syncdb and migrations
execute "migrate" do
  command "env/bin/python src/manage.py migrate"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end

# collectstatic
execute "collectstatic" do
  command "env/bin/python src/manage.py collectstatic --noinput"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
  user node['pictureroom']['user']
end

# restart supervisor services
execute "supervisorctl restart celery"
execute "supervisorctl restart celery_quiet"
execute "supervisorctl restart celerybeat"
execute "supervisorctl restart flower"
execute "supervisorctl restart dash"
execute "supervisorctl restart gunicorn"

# flush memcached
execute "echo 'flush_all' | nc localhost 11211"
