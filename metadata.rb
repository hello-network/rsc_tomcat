name             'rsc_tomcat'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures tomcat app server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.2.0'

depends 'yum'
depends 'apt'
depends 'marker', '~> 1.0.1'
depends 'tomcat'
depends 'application_java', '~> 3.0.2'
depends 'collectd', '~> 1.1.0'
depends 'rightscale_tag', '~> 1.0.5'
depends "yum-epel"

recipe 'rsc_tomcat::default', 'Installs/configures a tomcat application server'
recipe 'rsc_tomcat::code_update', 'updates the application code'
recipe 'rsc_tomcat::tags', 'Sets up application server tags used in a 3-tier deployment setup'
recipe 'rsc_tomcat::collectd', 'Sets up collectd monitoring for the application server'
recipe 'rsc_tomcat::application_backend', 'Attaches the application server to a load balancer'
recipe 'rsc_tomcat::application_backend_detached', 'Detaches the application server' +
  ' from a load balancer'




attribute 'rsc_tomcat/listen_port',
  :display_name => 'Application Listen Port',
  :description => 'The port to use for the application to bind. Example: 8080',
  :default => '8080',
  :required => 'optional',
  :recipes => [
  'rsc_tomcat::default',
  'rsc_tomcat::tags',
  'rsc_tomcat::application_backend',
]

attribute 'rsc_tomcat/war/path',
  :display_name => 'URL of WAR file ',
  :description => 'URL path of WAR file to deploy',
  :required => 'required',
  :recipes => ['rsc_tomcat::default']


attribute 'rsc_tomcat/application_name',
  :display_name => 'Application Name',
  :description => 'The name of the application. This name is used to generate the path of the' +
  ' application code and to determine the backend pool in a load balancer server that the' +
  ' application server will be attached to. Application names can have only alphanumeric' +
  ' characters and underscores. Example: hello_world',
  :required => 'required',
  :recipes => [
  'rsc_tomcat::default',
  'rsc_tomcat::tags',
  'rsc_tomcat::application_backend',
  'rsc_tomcat::application_backend_detached',
]

attribute 'rsc_tomcat/app_root',
  :display_name => 'Application Root',
  :description => 'The path of application root relative to /home/webapps/<application name> directory. Example: my_app',
  :default => '/',
  :required => 'optional',
  :recipes => [
  'rsc_tomcat::default',
  'rsc_tomcat::tags',]
  
  attribute 'rsc_tomcat/vhost_path',
  :display_name => 'Virtual Host Name/Path',
  :description => 'The virtual host served by the application server. The virtual host name can be' +
    ' a valid domain/path name supported by the access control lists (ACLs) in a load balancer.' +
    ' Ensure that no two application servers in the same deployment having the same' +
    ' application name have different vhost paths. Example: http:://www.example.com, /index',
  :required => 'required',
  :recipes => [
    'rsc_tomcat::tags',
    'rsc_tomcat::application_backend',
  ]

attribute 'rsc_tomcat/bind_network_interface',
  :display_name => 'Application Bind Network Interface',
  :description => "The network interface to use for the bind address of the application server." +
  " It can be either 'private' or 'public' interface.",
  :default => 'private',
  :choice => ['public', 'private'],
  :required => 'optional',
  :recipes => [
  'rsc_tomcat::default',
  'rsc_tomcat::tags',
]


attribute 'rsc_tomcat/database/host',
  :display_name => 'Database Host',
  :description => 'The FQDN of the database server. Example: db.example.com',
  :default => 'localhost',
  :required => 'recommended',
  :recipes => ['rsc_tomcat::default']

attribute 'rsc_tomcat/database/user',
  :display_name => 'MySQL Application Username',
  :description => 'The username used to connect to the database. Example: cred:MYSQL_APPLICATION_USERNAME',
  :required => 'recommended',
  :recipes => ['rsc_tomcat::default']

attribute 'rsc_tomcat/database/password',
  :display_name => 'MySQL Application Password',
  :description => 'The password used to connect to the database. Example: cred:MYSQL_APPLICATION_PASSWORD',
  :required => 'recommended',
  :recipes => ['rsc_tomcat::default']

attribute 'rsc_tomcat/database/schema',
  :display_name => 'MySQL Database Name',
  :description => 'The schema name used to connect to the database. Example: mydb',
  :required => 'recommended',
  :recipes => ['rsc_tomcat::default']

attribute 'rsc_tomcat/java/version',
  :display_name => 'JAVA JDK version to install',
  :description => 'Indicate the version of JAVA JDK you want to install, Example: 7',
  :default =>'7',
  :required => 'optional',
  :recipes => ['rsc_tomcat::default']

attribute 'rsc_tomcat/java/flavor',
  :display_name => 'JVM Flavor to install ',
  :description => "Support: openjdk, Default: openjdk",
  :choice=> ['openjdk','oracle'],
  :required => 'required',
  :recipes => ['rsc_tomcat::default']

attribute 'rsc_tomcat/java_options',
  :display_name => 'Tomcat JAVA Options',
  :description => "Default: -Xmx128M -Djava.awt.headless=true",
  :required => 'recommended',
  :recipes => ['rsc_tomcat::default']

attribute 'tomcat/base_version',
  :display_name => 'Tomcat Version',
  :description => 'The version of Tomcat to install.  Empty means install the latest version',
  :required => "optional",
  :recipes => ['rsc_tomcat::default']

attribute 'tomcat/catalina_options',
  :display_name => 'Tomcat Catalina Options',
  :description => "Extra options to pass to the JVM only during start and run commands, default """,
  :required => 'optional',
  :recipes => ['rsc_tomcat::default']

attribute 'tomcat/install_method',
  :display_name => 'method used to install tomcat. ',
  :description => "",
  :choice => ["package","tar"],
  :required => 'optional',
  :recipes => ['rsc_tomcat::default']

attribute 'tomcat/tar_version',
  :display_name => 'Tomcat tar version',
  :description => "Tomcat version to install from tar",
  :required => 'optional',
  :recipes => ['rsc_tomcat::default']
