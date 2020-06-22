Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.define "kerberos" do |kerberos|
    kerberos.vm.hostname = 'kerberos'
    kerberos.vm.provision "shell", path: "kerberos.sh"
  end

  config.vm.define "frontend" do |frontend|
    frontend.vm.hostname = 'frontend'
    frontend.vm.provision "shell", path: "frontend.sh"
  end

  config.vm.define "backend" do |backend|
    backend.vm.hostname = 'backend'
    backend.vm.provision "shell", path: "backend.sh"
  end

end
