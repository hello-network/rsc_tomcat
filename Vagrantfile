Vagrant.configure('2') do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'rsc-tomcat-berkshelf'

  # Every Vagrant virtual environment requires a box to build off of.
  # config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box = 'opscode-ubuntu-14.04'
  # config.vm.box = "opscode-ubuntu-14.10"
  # config.vm.box ="opscode-centos-6.6"
  # config.vm.box ="opscode-centos-7.0"
  # config.vm.box  ="opscode-debian-7.7"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.boxx"
  config.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'
  # config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.10_chef-provisionerless.box"

  # config.vm.box_url ="http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.6_chef-provisionerless.box"
  # config.vm.box_url="http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
  # config.vm.box_url="http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_debian-7.7_chef-provisionerless.box"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, ip: '33.33.33.10', auto_config: false

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.

  # config.vm.network :public_network

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder '~/vagrant', '/vagrant', disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  config.omnibus.chef_version = '11.6.0'

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|
    chef.log_level = 'info'
    chef.json = {
      :mysql => {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      },
      :vagrant => {
        box_name: 'appserver'
      },
      'rs-base' => {
        'collectd_server' => 'sketchy1-66.rightscale.com'
      },
      cloud: {
        provider: 'vagrant',
        public_ips: ['33.33.33.10'],
        private_ips: ['10.0.0.1']
      },
      rightscale: {
        instance_uuid: 'abcdef1234',
        servers: { sketchy: { hostname: 'fpp' } }
      },
      tomcat: { base_version: '7', # 6 or 7
                install_method: 'package', # or "tar"
        # tar_version: "8.0.18"
      },
      :rsc_tomcat => {
        application_name: 'example',
        listen_port: '8080',
        bind_network_interface: 'private',
        vhost_path: 'www.example.com',
        war: { path: 'https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war' },
        java: { version: '8', flavor: 'oracle' },
        database: {
          provider: 'mysql',
          host: 'db1.example.com',
          user: 'app_user',
          password: 'apppass',
          schema: 'app_test'
        }
      }
    }

    chef.run_list = [
      'recipe[apt::default]',
      # "recipe[yum-epel]",
      # "recipe[rs-base::default]",
      'recipe[rsc_tomcat::default]',
      # "recipe[rsc_tomcat::tags]",
      # "recipe[rsc_tomcat::collectd]"
    ]
  end
end
