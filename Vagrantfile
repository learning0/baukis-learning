Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider :virtualbox do |vb|
    vb.customize [ 'modifyvm', :id, '--memory', 800 ]
  end
  config.vm.network "forwarded_port", guest: 3000, host: 4000
  config.vm.network "forwarded_port", guest: 3306, host: 4306
  #config.vm.network :private_network, ip:'192.168.0.10'  

  config.vm.provision :shell, inline: "apt-get update"
  config.vm.provision :shell, inline: "apt-get -y upgrade"
  config.vm.provision :shell, inline: "apt-get -y install build-essential"

  config.vm.provision :shell, path: "provision/chruby.sh"
  config.vm.provision :shell, path: "provision/ruby-install.sh"
  config.vm.provision :shell, path: "provision/ruby.sh"
  config.vm.provision :shell, path: "provision/rails.sh", privileged: false
  config.vm.provision :shell, path: "provision/mysql-server.sh"
  config.vm.provision :shell, path: "provision/postgresql-server.sh"
end
