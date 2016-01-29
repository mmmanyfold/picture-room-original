include_recipe "apt"

# install git
apt_package "git"

# disable strict host key checking for github
template "/home/#{node['pictureroom']['user']}/.ssh/config" do
  source "ssh-config.erb"
  owner node['pictureroom']['user']
end

# configure git globals
execute "git config" do
  command "git config user.name #{node['pictureroom']['git_user']}"
  user node['pictureroom']['user']
  cwd node['pictureroom']['app_root']
end

execute "git config" do
  command "git config user.email #{node['pictureroom']['git_email']}"
  user node['pictureroom']['user']
  cwd node['pictureroom']['app_root']
end

# create directory and clone repo if it doesn't exist
unless File.directory?(node['pictureroom']['app_root'])
  execute "git clone" do
    command "git clone -b #{node['pictureroom']['git_branch']} #{node['pictureroom']['git_repo']} #{node['pictureroom']['app_root']}"
    user node['pictureroom']['user']
  end
end

# database
ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"

# create wal-e env
unless File.directory?("/etc/wal-e.d/env")
  execute "create wal-e env" do
    command "umask u=rwx,g=rx,o= && mkdir -p /etc/wal-e.d/env -p && chown -Rf postgres:postgres /etc/wal-e.d"
  end
end

# backups
node.default['postgresql']['config']['wal_level'] = 'archive'
node.default['postgresql']['config']['archive_mode'] = 1
node.default['postgresql']['config']['archive_timeout'] = 60
node.default['postgresql']['config']['archive_command'] = "envdir /etc/wal-e.d/env #{node['pictureroom']['app_root']}/env/bin/wal-e wal-push %p"

include_recipe "postgresql::server"

wal_e_command = "/usr/bin/envdir /etc/wal-e.d/env #{node['pictureroom']['app_root']}/env/bin/wal-e"

cron "database_backups" do
  minute '0'
  hour '1'
  weekday '*'
  user 'postgres'
  command "#{wal_e_command} backup-push #{node['postgresql']['config']['data_directory']} && #{wal_e_command} delete --confirm retain 14"
end

# normal provisioning
include_recipe "pictureroom::base"

# linux dash
apt_package "golang"

unless File.directory?("/home/#{node['pictureroom']['user']}/linux-dash")
  execute "git clone" do
    command "git clone https://github.com/afaqurk/linux-dash.git"
    user node['pictureroom']['user']
    cwd "/home/#{node['pictureroom']['user']}"
  end
end

unless File.exists?("/home/#{node['pictureroom']['user']}/linux-dash/server/server")
  execute "compile linux dash server" do
    command "go build"
    user node['pictureroom']['user']
    cwd "/home/#{node['pictureroom']['user']}/linux-dash/server"
  end
end

# disable password ssh
node.default['openssh']['server']['password_authentication'] = 'no'
include_recipe "openssh"

# copy root key to user if no ssh directory
unless File.directory?("/home/#{node['pictureroom']['user']}/.ssh")
    execute "mkdir /home/#{node['pictureroom']['user']}/.ssh"
    execute "cp /root/.ssh/authorized_keys /home/#{node['pictureroom']['user']}/.ssh/"
    execute "chown #{node['pictureroom']['user']} /home/#{node['pictureroom']['user']}/.ssh/authorized_keys"
end

# firewall
include_recipe "firewall"
rules = [['ssh',22],['http',80],['ssl',443]]
rules.each do |r|
  firewall_rule r[0] do
    port r[1]
    action :allow
  end
end
firewall 'ufw'

include_recipe "pictureroom::deploy"

execute "create_webhooks" do
  command "env/bin/python src/manage.py create_webhooks"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end

execute "create_carrier_service" do
  command "env/bin/python src/manage.py create_carrier_service"
  cwd node['pictureroom']['app_root']
  user node['pictureroom']['user']
end
