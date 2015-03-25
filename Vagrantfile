Vagrant.configure("2") do |config|
  vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  #config.vm.box     = "centos65"
  #config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  config.vm.box     = "centos65-wuk"
  config.vm.box_url = "~/workspace/centos65-wuk-base.box"

  config.vm.network "private_network", ip: "192.168.16.150"

  config.vm.hostname = "wuk-dev.local"

  config.vm.provider "virtualbox" do |vb|
    # allow symlinks - you are using this in a *nix host system right?
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # Use a shell provisioner to Vagrant here which will use
  # rake inside the VM to run vagrant:provision
  # Put a custom vagrant.pp in this directory if you want to run your own manifest.
  config.vm.provision :shell, :path => "bin/vagrant-provision.sh"

end
