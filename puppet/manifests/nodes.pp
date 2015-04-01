node default {
  crit( "Node only matched \"default\" for which there is no configuration, $::hostname" )
}

node wuk-dev {
  class {'beluga::mysql_server': }

  class { 'apache':
    mpm_module                  => 'prefork',
  }

  include apache::mod::rewrite
  include apache::mod::passenger
  include apache::mod::perl

  class { 'php52': }

  file { [ "/sites", "/sites/intranet", "/sites/intranet2" ]:
    ensure                      => "directory",
  }

  groupintranet { 'ssl-groupintranet.wolseley.com':
    ssl           => false, # THIS SHOULD BE TRUE TODO
    docroot       => '/sites/intranet/groupv2',
    serveradmin   => 'it.ops@wolseley.co.uk',
    serveraliases => ['groupintranet.wolseley.com']
  }

  groupintranet { 'groupintranet.wolseley.com':
    ssl         => false,
    docroot     => '/sites/intranet/groupv2',
    serveradmin => 'web_admin_ripon@wolseley.co.uk',
  }

  intranet2 { 'intranet2.wolseley.co.uk':
    docroot       => '/sites/intranet2/wuk',
    ssl           => false, # THIS SHOULD BE TRUE TODO
    serveraliases => ['intranet2.wolseley.co.uk']
  }

  intranet { 'intranet.wolseley.co.uk':
    serveraliases => ['www.intranet.wolseley.co.uk'],
  }

  class { 'beluga::developer_tools':
    install_grunt             => false,
    install_git               => true,
  }

  class { 'jenkins':
    configure_firewall        => false,
  }

}

# Intranet LinuxDev01
node e03422 {

  include prod_defaults

  class { 'apache':
    mpm_module                  => 'prefork',
  }

  include apache::mod::rewrite
  include apache::mod::passenger
  include apache::mod::perl

  class { 'php52': }

  class {'beluga::mysql_server': }

  class { 'beluga::developer_tools':
    install_grunt             => false,
    install_git               => true,
  }

  class { 'jenkins':
    configure_firewall        => false,
  }

  file { [ "/sites", "/sites/intranet", "/sites/intranet2" ]:
    ensure                      => "directory",
  }

  groupintranet { 'ssl-groupintranet.wolseley.com':
    ssl           => false, # THIS SHOULD BE TRUE TODO
    docroot       => '/sites/intranet/groupv2',
    serveradmin   => 'it.ops@wolseley.co.uk',
    serveraliases => ['groupintranet.wolseley.com']
  }

  groupintranet { 'groupintranet.wolseley.com':
    ssl         => false,
    docroot     => '/sites/intranet/groupv2',
    serveradmin => 'web_admin_ripon@wolseley.co.uk',
  }

  intranet2 { 'intranet2.wolseley.co.uk':
    docroot       => '/sites/intranet2/wuk',
    ssl           => false, # THIS SHOULD BE TRUE TODO
    serveraliases => ['intranet2.wolseley.co.uk']
  }

  intranet { 'intranet.wolseley.co.uk':
    serveraliases => ['www.intranet.wolseley.co.uk'],
  }

}

# Intranet LinuxStage01
node e03423 {

  include prod_defaults

  class { 'apache':
    mpm_module                  => 'prefork',
  }

  include apache::mod::rewrite
  include apache::mod::passenger
  include apache::mod::perl

  class { 'php52': }

  file { [ "/sites", "/sites/intranet", "/sites/intranet2" ]:
    ensure                      => "directory",
  }

  groupintranet { 'ssl-groupintranet.wolseley.com':
    ssl           => false, # THIS SHOULD BE TRUE TODO
    docroot       => '/sites/intranet/groupv2',
    serveradmin   => 'it.ops@wolseley.co.uk',
    serveraliases => ['groupintranet.wolseley.com']
  }

  groupintranet { 'groupintranet.wolseley.com':
    ssl         => false,
    docroot     => '/sites/intranet/groupv2',
    serveradmin => 'web_admin_ripon@wolseley.co.uk',
  }

  intranet2 { 'intranet2.wolseley.co.uk':
    docroot       => '/sites/intranet2/wuk',
    ssl           => false, # THIS SHOULD BE TRUE TODO
    serveraliases => ['intranet2.wolseley.co.uk']
  }

  intranet { 'intranet.wolseley.co.uk':
    serveraliases => ['www.intranet.wolseley.co.uk'],
  }


}

# Intranet LinuxStage02
node e03424 {

  include prod_defaults

  class { 'apache':
    mpm_module                  => 'prefork',
  }

  include apache::mod::rewrite
  include apache::mod::passenger
  include apache::mod::perl

  class { 'php52': }

  file { [ "/sites", "/sites/intranet", "/sites/intranet2" ]:
    ensure                      => "directory",
  }

  groupintranet { 'ssl-groupintranet.wolseley.com':
    ssl           => false, # THIS SHOULD BE TRUE TODO
    docroot       => '/sites/intranet/groupv2',
    serveradmin   => 'it.ops@wolseley.co.uk',
    serveraliases => ['groupintranet.wolseley.com']
  }

  groupintranet { 'groupintranet.wolseley.com':
    ssl         => false,
    docroot     => '/sites/intranet/groupv2',
    serveradmin => 'web_admin_ripon@wolseley.co.uk',
  }

  intranet2 { 'intranet2.wolseley.co.uk':
    docroot       => '/sites/intranet2/wuk',
    ssl           => false, # THIS SHOULD BE TRUE TODO
    serveraliases => ['intranet2.wolseley.co.uk']
  }

  intranet { 'intranet.wolseley.co.uk':
    serveraliases => ['www.intranet.wolseley.co.uk'],
  }

}

# Intranet LinuxIntranet01
node e02414 {

  include prod_defaults

  class { 'apache':
    mpm_module                  => 'prefork',
  }

  include apache::mod::rewrite
  include apache::mod::passenger
  include apache::mod::perl

  class { 'php52': }

  file { [ "/sites", "/sites/intranet", "/sites/intranet2" ]:
    ensure                      => "directory",
  }

  groupintranet { 'ssl-groupintranet.wolseley.com':
    ssl           => false, # THIS SHOULD BE TRUE TODO
    docroot       => '/sites/intranet/groupv2',
    serveradmin   => 'it.ops@wolseley.co.uk',
    serveraliases => ['groupintranet.wolseley.com']
  }

  groupintranet { 'groupintranet.wolseley.com':
    ssl         => false,
    docroot     => '/sites/intranet/groupv2',
    serveradmin => 'web_admin_ripon@wolseley.co.uk',
  }

  intranet2 { 'intranet2.wolseley.co.uk':
    docroot       => '/sites/intranet2/wuk',
    ssl           => false, # THIS SHOULD BE TRUE TODO
    serveraliases => ['intranet2.wolseley.co.uk']
  }

  intranet { 'intranet.wolseley.co.uk':
    serveraliases => ['www.intranet.wolseley.co.uk'],
  }

}

# Intranet LinuxIntranet02
node e02415 {

  include prod_defaults
  class {'intranet':}

  class { 'apache':
    mpm_module                  => 'prefork',
  }

  include apache::mod::rewrite
  include apache::mod::passenger
  include apache::mod::perl

  class { 'php52': }

  file { [ "/sites", "/sites/intranet", "/sites/intranet2" ]:
    ensure                      => "directory",
  }

  groupintranet { 'ssl-groupintranet.wolseley.com':
    ssl           => false, # THIS SHOULD BE TRUE TODO
    docroot       => '/sites/intranet/groupv2',
    serveradmin   => 'it.ops@wolseley.co.uk',
    serveraliases => ['groupintranet.wolseley.com']
  }

  groupintranet { 'groupintranet.wolseley.com':
    ssl         => false,
    docroot     => '/sites/intranet/groupv2',
    serveradmin => 'web_admin_ripon@wolseley.co.uk',
  }

  intranet2 { 'intranet2.wolseley.co.uk':
    docroot       => '/sites/intranet2/wuk',
    ssl           => false, # THIS SHOULD BE TRUE TODO
    serveraliases => ['intranet2.wolseley.co.uk']
  }

  intranet { 'intranet.wolseley.co.uk':
    serveraliases => ['www.intranet.wolseley.co.uk'],
  }

}

# Intranet DB Prod 01
node e02416 {

  include prod_defaults

  class {'beluga::mysql_server': }
  class {'intranet_db':}

}

# Intranet DB Prod 02
node e02417 {

  include prod_defaults

  class {'beluga::mysql_server': }
  class {'intranet_db':}

}

# Intranet DB Dev/Test 01
node e03425 {

  include prod_defaults

  class {'beluga::mysql_server': }
  class {'intranet_db':}

}

# Intranet DB Dev/Test 02
node e03426 {

  include prod_defaults

  class {'beluga::mysql_server': }
  class {'intranet_db':}

}

