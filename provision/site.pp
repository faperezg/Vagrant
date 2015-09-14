Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ] }

class { 'apache':
  serveradmin => 'fperez@corplaurus.int',
  default_vhost => false,
  default_mods => true,
  mpm_module => 'prefork',
}
apache::mod { 'rewrite': }
apache::vhost { 'webconsole.corplaurus.int non-ssl':
  servername  => 'webconsole.corplaurus.int',
  port        => '80',
  docroot     => '/var/www/web',
  directories => [
    {
      'path'           => '/var/www/web',
      'allow'          => 'from all',
      'allow_override' => 'All',
      'options'        => ['Indexes', 'MultiViews'],
    }
  ],
  access_log_file => 'webconsole_access.log',
  error_log_file  => 'webconsole_error.log',
  logroot         => '/var/log/apache2',
}
apache::vhost { 'webconsole.corplaurus.int ssl':
  servername  => 'webconsole.corplaurus.int',
  port        => '443',
  docroot     => '/var/www/web',
  directories => [
    {
      'path'           => '/var/www/web',
      'allow'          => 'from all',
      'allow_override' => 'All',
      'options'        => ['Indexes', 'MultiViews'],
    }
  ],
  access_log_file => 'webconsole_ssl_access.log',
  error_log_file  => 'webconsole_ssl_error.log',
  logroot         => '/var/log/apache2',
  ssl             => true,
  ssl_cert        => '/etc/ssl/local/apache.pem',
  ssl_key         => '/etc/ssl/local/apache.key',
  ssl_protocol    => '-ALL +SSLv3 +TLSv1',
  ssl_cipher      => 'ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM',
}
class {'::apache::mod::php': }

class { 'php': }
php::module { "apc":
  module_prefix => "php-",
  require => Package[php],
}
php::module { "curl":
  require => Package[php],
}
php::module { "gd":
  require => Package[php],
}
php::module { "gmp":
  require => Package[php],
}
php::module { "imagick":
  require => Package[php],
}
php::module { "imap":
  require => Package[php],
}
php::module { "intl":
  require => Package[php],
}
php::module { "ldap":
  require => Package[php],
}
php::module { "mcrypt":
  require => Package[php],
}
php::module { "mysql":
  require => Package[php],
}
php::module { "mysqlnd":
  require => Package[php],
}
php::module { "sqlite":
  require => Package[php],
}
php::module { "pspell":
  require => Package[php],
}
php::module { "snmp":
  require => Package[php],
}
php::module { "xdebug":
  require => Package[php],
}
php::module { "xmlrpc":
  require => Package[php],
}
php::module { "xsl":
  require => Package[php],
}
augeas { "php.ini":
  notify  => Service[httpd],
  require => Package[php],
  context => "/files/etc/php5/apache2/php.ini/PHP",
  changes => [
    "set short_open_tag Off",
    "set max_execution_time 600",
    "set error_reporting 'E_ALL & ~E_STRICT'",
    "set display_errors On",
    "set display_startup_errors On",
    "set post_max_size 10M",
    "set upload_max_filesize 10M",
    "set date.timezone 'America/Caracas'",
  ];
}
ini_setting { "xdebug.remote_enable":
  ensure  => present,
  notify  => Service[httpd],
  path    => "/etc/php5/mods-available/xdebug.ini",
  section => "",
  setting => "xdebug.remote_enable",
  value   => "1",
}
ini_setting { "xdebug.remote_connect_back":
  ensure  => present,
  notify  => Service[httpd],
  path    => "/etc/php5/mods-available/xdebug.ini",
  section => "",
  setting => "xdebug.remote_connect_back",
  value   => "1",
}
ini_setting { "xdebug.remote_handler":
  ensure  => present,
  notify  => Service[httpd],
  path    => "/etc/php5/mods-available/xdebug.ini",
  section => "",
  setting => "xdebug.remote_handler",
  value   => "dbgp",
}
ini_setting { "xdebug.remote_mode":
  ensure  => present,
  notify  => Service[httpd],
  path    => "/etc/php5/mods-available/xdebug.ini",
  section => "",
  setting => "xdebug.remote_mode",
  value   => "req",
}
ini_setting { "xdebug.remote_port":
  ensure  => present,
  notify  => Service[httpd],
  path    => "/etc/php5/mods-available/xdebug.ini",
  section => "",
  setting => "xdebug.remote_port",
  value   => "9000",
}
ini_setting { "xdebug.idekey":
  ensure  => present,
  notify  => Service[httpd],
  path    => "/etc/php5/mods-available/xdebug.ini",
  section => "",
  setting => "xdebug.idekey",
  value   => "xdebug",
}
ini_setting { "xdebug.max_nesting_level":
  ensure  => present,
  notify  => Service[httpd],
  path    => "/etc/php5/mods-available/xdebug.ini",
  section => "",
  setting => "xdebug.max_nesting_level",
  value   => "250",
}

class { 'composer':
  require => Package[php],
}

class { '::mysql::server':
  create_root_user => true,
  root_password => '',
  override_options => {
    'mysqld' => {
      'collation-server' => 'utf8mb4_general_ci',
      'character-set-server' => 'utf8mb4',
      'bind-address' => '0.0.0.0',
    }
  },
  users => {
    'webconsole@%' => {
      ensure                   => 'present',
      max_connections_per_hour => '0',
      max_queries_per_hour     => '0',
      max_updates_per_hour     => '0',
      max_user_connections     => '0',
      password_hash            => '*576BF5D27349B012232E896C58AA0F2DA0F2E7E9',
    },
  },
  databases   => {
    'webconsole'  => {
      ensure  => 'present',
      charset => 'utf8mb4',
      collate => 'utf8mb4_general_ci',
    },
  },
  grants => {
    'webconsole@%/webconsole.*' => {
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL'],
      table      => 'webconsole.*',
      user       => 'webconsole@%',
    }
  },
  restart => true,
}
