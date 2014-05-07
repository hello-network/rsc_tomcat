name             'rs-services_rails'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures rs-services_rails'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends 'marker', '~> 1.0.0'
depends 'application_ruby', '~> 3.0.2'
depends 'mysql', '4.0.14'
depends 'database', '~> 1.5.2'
depends 'git', '~> 2.7.0'
depends 'collectd', '~> 1.1.0'
depends 'rightscale_tag'
