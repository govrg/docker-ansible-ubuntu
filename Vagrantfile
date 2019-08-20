$set_environment_variables = <<SCRIPT
tee "/etc/profile.d/myvars.sh" > "/dev/null" <<EOF
# Ansible environment variables.
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export ANSIBLE_USR=#{ENV['ANSIBLE_USR']}
export ANSIBLE_HOST_KEY_CHECKING=False
export ANDROID_HOME=/home/vagrant/android-sdk-linux
export ANDROID_SDK_ROOT=/home/vagrant/android-sdk-linux
export ANDROID_TOOLS=/home/vagrant/android-sdk-linux/tools/
export ANDROID_PLATFORM_TOOLS=/home/vagrant/android-sdk-linux/platform-tools/
export PATH=$PATH:/home/vagrant/android-sdk-linux/tools/:/home/vagrant/android-sdk-linux/platform-tools
export PATH=PATH:/home/vagrant/packer:/home/vagrant/appium/node-v12.4.0-linux-x64/bin:/home/vagrant/android-sdk-linux/tools:/home/vagrant/android-sdk-linux/tools/bin:/home/vagrant/android-sdk-linux/platform-tools:/opt/gradle/gradle-5.0/bin:$PATH
export PATH="$HOME/.rbenv/bin:$PATH

EOF
SCRIPT

Vagrant.configure("2") do |config|

  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |v|
    #v.gui = true
    v.customize ["modifyvm", :id, "--usb", "on"]
    v.customize ["modifyvm", :id, "--vram", "15"]
    v.memory = 4096
    v.cpus = 3
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  
  config.vm.define "master" do |machine|  
    machine.vm.box = "pristine/ubuntu-budgie-18-x64"
    machine.vm.hostname = 'masterE2e'
    machine.vm.network 'forwarded_port', host:2220, guest: 22, id: "ssh", auto_correct: true
    machine.vm.network 'private_network', ip: '192.168.33.205'
    machine.vm.synced_folder ".", "/vagrant"
    machine.vm.synced_folder "C:\\Users\\gordo\\.ssh", "/home/vagrant/ssh-host" 
    machine.vm.provision "shell", inline: <<-SHELL
      chsh -s /bin/bash vagrant
      sudo apt-get update -y
      #sudo apt-get upgrade -y
      cp /home/vagrant/ssh-host/* /home/vagrant/.ssh/.
      mkdir /home/vagrant/vagrant-ansible-ubuntu/
      cp /vagrant/* /home/vagrant/vagrant-ansible-ubuntu/ -r
      sudo chown vagrant:vagrant -R /home/vagrant/vagrant-ansible-ubuntu/
    SHELL
  
    machine.vm.provision "shell", inline: $set_environment_variables , run: "always"
    
    machine.vm.provision "shell", inline: <<-SHELL
      source /etc/profile.d/myvars.sh
      cp /etc/profile.d/myvars.sh /home/vagrant/.
      sudo apt-get update
      L='se' && sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard
      sudo groupadd docker
      sudo gpasswd -a vagrant docker
      sudo apt-get install software-properties-common
      sudo apt-add-repository --yes --update ppa:ansible/ansible
      sudo apt-get install -y ansible
      cd /home/vagrant/vagrant-ansible-ubuntu/
      sudo mkdir /opt/ansible/
      sudo cp vault_password /opt/ansible/
      sudo chmod a-x /opt/ansible/vault_password
      #vagrant is using /etc/ansible/
      #sudo cp ansible.cfg /etc/ansible/
      sudo apt update
      sudo apt-get install libssl-dev
      sudo apt install zlib1g-dev
      sudo apt-get install libcurl4 libcurl4-openssl-dev -y
      sudo apt  install rsync -y
      chsh -s /bin/bash vagrant
      ansible-playbook -i ./inventory/hosts --vault-password-file /opt/ansible/vault_password prelocalE2e.yml
      source /etc/profile.d/myvars.sh
    SHELL
  end
end
