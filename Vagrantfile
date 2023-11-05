# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "debian/buster64"

  config.vm.synced_folder "packer/scripts/", "/vagrant", type: "rsync", automount: true

  config.vm.provision "shell", path: "packer/scripts/bootstrap.sh"
end
