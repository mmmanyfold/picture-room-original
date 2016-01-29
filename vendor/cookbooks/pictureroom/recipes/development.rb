ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

# trust anything
node.default['postgresql']['pg_hba'] = [{
  :type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'}]

include_recipe "postgresql::server"

service "postgresql" do
  action :restart
end

# normal provisioning
include_recipe "pictureroom::base"

# add ability to create dbs to db_user
execute "alter_db_user" do
  command "psql -c 'ALTER USER #{node['pictureroom']['db']['user']} CREATEDB'"
  user "postgres"
end

# syncdb and migrations
execute "syncdb" do
  command "env/bin/python src/manage.py syncdb --noinput"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end

execute "migrate" do
  command "env/bin/python src/manage.py migrate"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end
