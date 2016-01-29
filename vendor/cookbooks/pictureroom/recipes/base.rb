# logging & logrotate
to_log = ["gunicorn", "django", "celery"]
to_log.each do |log|
  directory "/var/log/#{log}" do
    owner node['pictureroom']['user']
    group "root"
  end

  template "/etc/logrotate.d/#{log}" do
    source "logrotate.erb"
    variables({user: node['pictureroom']['user'], directory: log})
  end
end

include_recipe "locale"
include_recipe "python"
include_recipe "supervisor"
include_recipe "nodejs"

node.default['nginx']['init_style'] = 'upstart'
node.default['nginx']['user'] = node['pictureroom']['user']
node.default['nginx']['default_site_enabled'] = false
include_recipe "nginx"

# virtualenv
python_virtualenv "#{node['pictureroom']['app_root']}/env" do
  action :create
  owner node['pictureroom']['user']
end

# rabbitmq for celery
apt_package "rabbitmq-server"

execute "rabbitmqctl add_user #{node['pictureroom']['rabbitmq']['user']} #{node['pictureroom']['rabbitmq']['password']}" do
  not_if "rabbitmqctl list_users | grep #{node['pictureroom']['rabbitmq']['user']}"
end

execute "rabbitmqctl add_vhost #{node['pictureroom']['hostname']}" do
  not_if "rabbitmqctl list_vhosts | grep #{node['pictureroom']['hostname']}"
end

execute "rabbitmqctl set_permissions -p #{node['pictureroom']['hostname']} #{node['pictureroom']['rabbitmq']['user']} \".*\" \".*\" \".*\""

# varnish
apt_package "varnish"

template "/etc/default/varnish" do
  source "varnish"
end

template "/etc/varnish/default.vcl" do
  source "varnish-default.erb"
  variables({ip_address: node['ip_address']})
end

# required packages
packages = [
  'libjpeg-dev', 'libfreetype6', 'libfreetype6-dev', 'zlib1g-dev', 'libxml2-dev',
  'libxslt-dev', 'apache2-utils', 'libffi-dev', 'lzop', 'pv', 'daemontools',
  'libmemcached-dev', 'libssl-dev', 'build-essential']

packages.each do |pkg|
  package pkg do
    action :install
  end
end

# python requirements
execute "python_requirements" do
  command "env/bin/pip install -r requirements.txt"
  cwd node['pictureroom']['app_root']
end

apt_package "memcached"

# create db role and db if they don't exist
db_user = node['pictureroom']['db']['user']
db_name = node['pictureroom']['db']['name']

execute "create_db_role" do
  command "psql -tAc \"SELECT 1 FROM pg_roles WHERE rolname='#{db_user}'\" | grep -q 1 || createuser -SDR #{db_user}"
  user "postgres"
end

execute "create_db" do
  command "psql -lqt | cut -d \\| -f 1 | grep -wq #{db_name} || createdb -O #{db_user} #{db_name}"
  user "postgres"
end

# nginx conf
template "/etc/nginx/sites-available/#{node['pictureroom']['hostname']}" do
  source "nginx.erb"
  owner node['nginx']['user']
  group node['nginx']['user']
  variables({app_root: node['pictureroom']['app_root'],
    hostname: node['pictureroom']['hostname'],
    journal_hostname: node['pictureroom']['journal_hostname'],
    name: "pictureroom",
    user: node['pictureroom']['user'],
    protect: node['pictureroom']['password_protect'],
    wordpress_root: node['pictureroom']['wordpress_root'],
    ssl_enabled: node['pictureroom']['ssl_enabled']})
end

unless File.exists?("/etc/nginx/sites-enabled/#{node['pictureroom']['hostname']}")
  execute "ln -s /etc/nginx/sites-available/#{node['pictureroom']['hostname']} /etc/nginx/sites-enabled/#{node['pictureroom']['hostname']}"
end

if File.exists?("rm /etc/nginx/sites-enabled/000-default")
  execute "rm /etc/nginx/sites-enabled/000-default"
end

service "nginx" do
  action :restart
end

# supervisor
template "/etc/supervisor.d/pictureroom.conf" do
  source "supervisor.erb"
  variables({
      app_root: node['pictureroom']['app_root'],
      gunicorn_path: node['pictureroom']['gunicorn_settings_path'],
      wsgi_path: node['pictureroom']['wsgi_path'],
      user: node['pictureroom']['user']
    })
end
