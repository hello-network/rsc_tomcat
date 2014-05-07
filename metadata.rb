name             'rs-services_rails'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures rs-services_rails'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'marker', '~> 1.0.0'
depends 'application' ,'~> 4.1.4'
depends 'application_ruby', '~> 3.0.2'
depends 'mysql', '~> 4.0.12'
depends 'database', '~> 1.5.2'
depends 'git', '~> 2.7.0'
depends 'collectd', '~> 1.1.0'
depends 'rightscale_tag', '~> 1.0.1'

recipe 'rs-service_rails::default', 'Installs/configures Passenger/Rails application server'
recipe 'rs-service_rails::tags', 'Sets up application server tags used in a 3-tier deployment setup'
recipe 'rs-service_rails::collectd', 'Sets up collectd monitoring for the application server'
recipe 'rs-service_rails::application_backend', 'Attaches the application server to a load balancer'
recipe 'rs-service_rails::application_backend_detached', 'Detaches the application server' +
  ' from a load balancer'


attribute 'rs-services_rails/gems',
  :display_name => 'Additional Gems to Install',
  :description => 'List of additional GEMS to be installed before starting the deployment.' +
  ' Package versions can be specified. Example: bundler, rake',
  :type => 'array',
  :required => 'optional',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/listen_port',
  :display_name => 'Application Listen Port',
  :description => 'The port to use for the application to bind. Example: 8080',
  :default => '8080',
  :required => 'optional',
  :recipes => [
  'rs-services_rails::default',
  'rs-services_rails::tags',
  'rs-services_rails::application_backend',
]

attribute 'rs-services_rails/scm/repository',
  :display_name => 'Application Repository URL',
  :description => 'The repository location to download application code. Example: git://github.com/rightscale/examples.git',
  :required => 'required',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/scm/revision',
  :display_name => 'Application Repository Revision',
  :description => 'The revision of application code to download from the repository. Example: 37741af646ca4181972902432859c1c3857de742',
  :required => 'required',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/scm/deploy_key',
  :display_name => 'Application Deploy Key',
  :description => 'The private key to access the repository via SSH. Example: Cred:APP_DEPLOY_KEY',
  :required => 'optional',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/application_name',
  :display_name => 'Application Name',
  :description => 'The name of the application. This name is used to generate the path of the' +
  ' application code and to determine the backend pool in a load balancer server that the' +
  ' application server will be attached to. Application names can have only alphanumeric' +
  ' characters and underscores. Example: hello_world',
  :required => 'required',
  :recipes => [
  'rs-services_rails::default',
  'rs-services_rails::tags',
  'rs-services_rails::application_backend',
  'rs-services_rails::application_backend_detached',
]
  

attribute 'rs-services_rails/environment',
  :display_name => 'Rails Env',
  :description => 'The RailsEnv your app will run as.  ',
  :default => 'production',
  :choice => ['development', 'test','staging','production'],
  :recipes => [
  'rs-services_rails::default'
]

attribute 'rs-services_rails/precompile_assets',
  :display_name => 'Precompile Assets',
  :description => 'Precompile assets during code deploy',
  :default => 'false',
  :choice => ['true','false'],
  :recipes => [
  'rs-services_rails::default'
]
  
attribute 'rs-services_rails/app_root',
  :display_name => 'Application Root',
  :description => 'The path of application root relative to /home/webapps/<application name> directory. Example: my_app',
  :default => '/',
  :required => 'optional',
  :recipes => [
  'rs-services_rails::default',
  'rs-services_rails::tags',
]

attribute 'rs-services_rails/bind_network_interface',
  :display_name => 'Application Bind Network Interface',
  :description => "The network interface to use for the bind address of the application server." +
  " It can be either 'private' or 'public' interface.",
  :default => 'private',
  :choice => ['public', 'private'],
  :required => 'optional',
  :recipes => [
  'rs-services_rails::default',
  'rs-services_rails::tags',
]

attribute 'rs-services_rails/migration_command',
  :display_name => 'Application Migration Command',
  :description => 'The command used to perform application migration. Example:rake db:migrate',
  :requried => 'optional',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/database/host',
  :display_name => 'Database Host',
  :description => 'The FQDN of the database server. Example: db.example.com',
  :default => 'localhost',
  :required => 'recommended',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/database/user',
  :display_name => 'MySQL Application Username',
  :description => 'The username used to connect to the database. Example: cred:MYSQL_APPLICATION_USERNAME',
  :required => 'recommended',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/database/password',
  :display_name => 'MySQL Application Password',
  :description => 'The password used to connect to the database. Example: cred:MYSQL_APPLICATION_PASSWORD',
  :required => 'recommended',
  :recipes => ['rs-services_rails::default']

attribute 'rs-services_rails/database/schema',
  :display_name => 'MySQL Database Name',
  :description => 'The schema name used to connect to the database. Example: mydb',
  :required => 'recommended',
  :recipes => ['rs-services_rails::default']