# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.synced_folder ".", "/pictureroom", type: "nfs"
  config.bindfs.bind_folder "/pictureroom", "/home/vagrant/pictureroom"

  config.omnibus.chef_version = :latest

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "pictureroom::development"

    chef.json = {
      "pictureroom" => {
        "user" => "vagrant",
        "app_root" => "/home/vagrant/pictureroom",
        "mysql_root_pw" => "changeme",
        "db" => {
          "user" => "vagrant"
        },
        "settings" => {
          "debug" => "True",
        },
        "hostname" => "ghalib.dev",
      },
      "postgresql" => {
        "password" => { "postgres" => "postgres" }
      }
    }
  end
end
