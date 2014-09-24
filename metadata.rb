name             'rsc_passenger'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures passenger app server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'marker', '~> 1.0.0'
depends 'application' ,'~> 4.1.4'
depends 'application_ruby', '~> 3.0.2'
depends 'mysql', '~> 4.0.12'
depends 'database', '~> 1.5.2'
depends 'git', '~> 2.7.0'
depends 'collectd', '~> 1.1.0'
depends 'rightscale_tag', '~> 1.0.2'

recipe 'rsc_passenger::default', 'Installs/configures Passenger/Rails application server'
recipe 'rsc_passenger::tags', 'Sets up application server tags used in a 3-tier deployment setup'
recipe 'rsc_passenger::collectd', 'Sets up collectd monitoring for the application server'
recipe 'rsc_passenger::application_backend', 'Attaches the application server to a load balancer'
recipe 'rsc_passenger::application_backend_detached', 'Detaches the application server' +
  ' from a load balancer'


attribute 'rsc_passenger/gems',
  :display_name => 'Additional Gems to Install',
  :description => 'List of additional GEMS to be installed before starting the deployment.' +
  ' Package versions can be specified. Example: bundler, rake',
  :type => 'array',
  :required => 'optional',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/listen_port',
  :display_name => 'Application Listen Port',
  :description => 'The port to use for the application to bind. Example: 8080',
  :default => '8080',
  :required => 'optional',
  :recipes => [
  'rsc_passenger::default',
  'rsc_passenger::tags',
  'rsc_passenger::application_backend',
]

attribute 'rsc_passenger/scm/repository',
  :display_name => 'Application Repository URL',
  :description => 'The repository location to download application code. Example: git://github.com/rightscale/examples.git',
  :required => 'required',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/scm/revision',
  :display_name => 'Application Repository Revision',
  :description => 'The revision of application code to download from the repository. Example: 37741af646ca4181972902432859c1c3857de742',
  :required => 'required',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/scm/deploy_key',
  :display_name => 'Application Deploy Key',
  :description => 'The private key to access the repository via SSH. Example: Cred:APP_DEPLOY_KEY',
  :required => 'optional',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/application_name',
  :display_name => 'Application Name',
  :description => 'The name of the application. This name is used to generate the path of the' +
  ' application code and to determine the backend pool in a load balancer server that the' +
  ' application server will be attached to. Application names can have only alphanumeric' +
  ' characters and underscores. Example: hello_world',
  :required => 'required',
  :recipes => [
  'rsc_passenger::default',
  'rsc_passenger::tags',
  'rsc_passenger::application_backend',
  'rsc_passenger::application_backend_detached',
]
  

attribute 'rsc_passenger/environment',
  :display_name => 'Rails Env',
  :description => 'The RailsEnv your app will run as.  ',
  :default => 'production',
  :choice => ['development', 'test','staging','production'],
  :recipes => [
  'rsc_passenger::default'
]
attribute 'rsc_passenger/passenger/version',
  :display_name => 'Passenger Version',
  :description => 'The version of Passenger to install.  Empty means install the latest version',
  :required => "optional",
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/ruby_path',
  :display_name => 'Ruby Path',
  :description => 'The path to the ruby executable',
  :default =>'/usr/local',

  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/precompile_assets',
  :display_name => 'Precompile Assets',
  :description => 'Precompile assets during code deploy',
  :default => 'false',
  :choice => ['true','false'],
  :recipes => [  'rsc_passenger::default']
  
attribute 'rsc_passenger/app_root',
  :display_name => 'Application Root',
  :description => 'The path of application root relative to /home/webapps/<application name> directory. Example: my_app',
  :default => '/',
  :required => 'optional',
  :recipes => [
  'rsc_passenger::default',
  'rsc_passenger::tags',]
  
  attribute 'rsc_passenger/vhost_path',
  :display_name => 'Virtual Host Name/Path',
  :description => 'The virtual host served by the application server. The virtual host name can be' +
    ' a valid domain/path name supported by the access control lists (ACLs) in a load balancer.' +
    ' Ensure that no two application servers in the same deployment having the same' +
    ' application name have different vhost paths. Example: http:://www.example.com, /index',
  :required => 'required',
  :recipes => [
    'rsc_passenger::tags',
    'rsc_passenger::application_backend',
  ]

attribute 'rsc_passenger/bind_network_interface',
  :display_name => 'Application Bind Network Interface',
  :description => "The network interface to use for the bind address of the application server." +
  " It can be either 'private' or 'public' interface.",
  :default => 'private',
  :choice => ['public', 'private'],
  :required => 'optional',
  :recipes => [
  'rsc_passenger::default',
  'rsc_passenger::tags',
]

attribute 'rsc_passenger/migration_command',
  :display_name => 'Application Migration Command',
  :description => 'The command used to perform application migration. Example:rake db:migrate',
  :requried => 'optional',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/database/host',
  :display_name => 'Database Host',
  :description => 'The FQDN of the database server. Example: db.example.com',
  :default => 'localhost',
  :required => 'recommended',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/database/user',
  :display_name => 'MySQL Application Username',
  :description => 'The username used to connect to the database. Example: cred:MYSQL_APPLICATION_USERNAME',
  :required => 'recommended',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/database/password',
  :display_name => 'MySQL Application Password',
  :description => 'The password used to connect to the database. Example: cred:MYSQL_APPLICATION_PASSWORD',
  :required => 'recommended',
  :recipes => ['rsc_passenger::default']

attribute 'rsc_passenger/database/schema',
  :display_name => 'MySQL Database Name',
  :description => 'The schema name used to connect to the database. Example: mydb',
  :required => 'recommended',
  :recipes => ['rsc_passenger::default']