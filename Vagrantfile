# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.3"

VAGRANTFILE_API_VERSION = "2"
CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), "cloud-config.yml")

# Defaults for config options defined in CONFIG
$num_instances = 1
$update_channel = "beta"
$enable_serial_logging = false
$vb_gui = false
$vb_memory = 2048
$vb_cpus = 2
# $expose_docker_tcp = 2375

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  root = File.expand_path(__FILE__ + "/../")
  config.vm.box = "coreos-%s" % $update_channel
  config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % $update_channel

  config.vm.provider :virtualbox do |v|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.functional_vboxsf     = false
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  (1..$num_instances).each do |i|
    config.vm.define vm_name = "core-%02d" % i do |config|
      config.vm.hostname = vm_name

      if $enable_serial_logging
        logdir = File.join(File.dirname(__FILE__), "log")
        FileUtils.mkdir_p(logdir)

        serialFile = File.join(logdir, "%s-serial.txt" % vm_name)
        FileUtils.touch(serialFile)

        config.vm.provider :virtualbox do |vb, override|
          vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
          vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
        end
      end

      if $expose_docker_tcp
        config.vm.network "forwarded_port", guest: 2375, host: ($expose_docker_tcp + i - 1), auto_correct: true
      end

      config.vm.provider :virtualbox do |vb|
        vb.gui = $vb_gui
        vb.memory = $vb_memory
        vb.cpus = $vb_cpus
        vb.customize ["modifyvm", :id, "--groups", "/coreos-cluster"]
      end

      ip = "172.17.8.#{i+100}"
      config.vm.network :private_network, ip: ip
      config.vm.network "forwarded_port", guest: 8080, host_ip: "127.0.0.1", host: 8080, auto_correct: true

      # Uncomment below to enable NFS for sharing the host machine into the coreos-vagrant VM.
      config.vm.synced_folder root, root, :nfs => true, :mount_options => ['nolock,vers=3,udp']

      if File.exist?(CLOUD_CONFIG_PATH)
        config.vm.provision :file, :source => "#{CLOUD_CONFIG_PATH}", :destination => "/tmp/vagrantfile-user-data"
        config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
      end

    end
  end
end
