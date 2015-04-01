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

  class{'webnode':

  group_ssl_intranet_hostname      =>  'ssl-dev.groupintranet.wolseley.com',
  group_ssl_intranet_docroot       =>  '/sites/intranet/groupv2',
  group_ssl_intranet_serveradmin   =>  'admin@localhost',
  group_ssl_intranet_serveraliases =>  ['dev.groupintranet.wolseley.com'],
  group_intranet_hostname          =>  'dev.groupintranet.wolseley.com',
  group_intranet_docroot           =>  '/sites/intranet/groupv2',
  group_intranet_serveradmin       =>  'admin@localhost',
  group_intranet_serveraliases     =>  ['dev.groupintranet.wolseley.com'],
  intranet2_hostname               =>  'dev.intranet2.wolseley.co.uk',
  intranet2_docroot                =>  '/sites/intranet2/wuk',
  intranet2_serveraliases          =>  ['dev.intranet2.wolseley.com'],
  intranet_hostname                =>  'dev.intranet.wolseley.co.uk',
  intranet_docroot                 =>  '/sites/intranet2/wuk',
  intranet_serveraliases           =>  ['www.dev.intranet.wolseley.com'],

  }
}

# Intranet LinuxStage01
node e03423 {

  class{'webnode':

    group_ssl_intranet_hostname      =>  'ssl-stage1.groupintranet.wolseley.com',
    group_ssl_intranet_docroot       =>  '/sites/intranet/groupv2',
    group_ssl_intranet_serveradmin   =>  'it.ops@wolseley.co.uk',
    group_ssl_intranet_serveraliases =>  ['stage1.groupintranet.wolseley.com'],
    group_intranet_hostname          =>  'stage1.groupintranet.wolseley.com',
    group_intranet_docroot           =>  '/sites/intranet/groupv2',
    group_intranet_serveradmin       =>  'web_admin_ripon@wolseley.co.uk',
    group_intranet_serveraliases     =>  ['stage1.groupintranet.wolseley.com'],
    intranet2_hostname               =>  'stage1.intranet2.wolseley.co.uk',
    intranet2_docroot                =>  '/sites/intranet2/wuk',
    intranet2_serveraliases          =>  ['stage1.intranet2.wolseley.com'],
    intranet_hostname                =>  'stage1.intranet.wolseley.co.uk',
    intranet_docroot                 =>  '/sites/intranet2/wuk',
    intranet_serveraliases           =>  ['www.stage1.intranet.wolseley.com'],

  }
}

# Intranet LinuxStage02
node e03424 {

  class{'webnode':

    group_ssl_intranet_hostname      =>  'ssl-stage2.groupintranet.wolseley.com',
    group_ssl_intranet_docroot       =>  '/sites/intranet/groupv2',
    group_ssl_intranet_serveradmin   =>  'it.ops@wolseley.co.uk',
    group_ssl_intranet_serveraliases =>  ['stage2.groupintranet.wolseley.com'],
    group_intranet_hostname          =>  'groupintranet.wolseley.com',
    group_intranet_docroot           =>  '/sites/intranet/groupv2',
    group_intranet_serveradmin       =>  'web_admin_ripon@wolseley.co.uk',
    group_intranet_serveraliases     =>  ['stage2.groupintranet.wolseley.com'],
    intranet2_hostname               =>  'stage2.intranet2.wolseley.co.uk',
    intranet2_docroot                =>  '/sites/intranet2/wuk',
    intranet2_serveraliases          =>  ['stage2.intranet2.wolseley.com'],
    intranet_hostname                =>  'stage2.intranet.wolseley.co.uk',
    intranet_docroot                 =>  '/sites/intranet2/wuk',
    intranet_serveraliases           =>  ['www.stage2.intranet.wolseley.com'],

  }
}

# Intranet LinuxIntranet01
node e02414 {

  class{'webnode':

    group_ssl_intranet_hostname      =>  'ssl-groupintranet.wolseley.com',
    group_ssl_intranet_docroot       =>  '/sites/intranet/groupv2',
    group_ssl_intranet_serveradmin   =>  'it.ops@wolseley.co.uk',
    group_ssl_intranet_serveraliases =>  ['groupintranet.wolseley.com'],
    group_intranet_hostname          =>  'groupintranet.wolseley.com',
    group_intranet_docroot           =>  '/sites/intranet/groupv2',
    group_intranet_serveradmin       =>  'web_admin_ripon@wolseley.co.uk',
    group_intranet_serveraliases     =>  ['groupintranet.wolseley.com'],
    intranet2_hostname               =>  'intranet2.wolseley.co.uk',
    intranet2_docroot                =>  '/sites/intranet2/wuk',
    intranet2_serveraliases          =>  ['intranet2.wolseley.com'],
    intranet_hostname                =>  'intranet.wolseley.co.uk',
    intranet_docroot                 =>  '/sites/intranet2/wuk',
    intranet_serveraliases           =>  ['www.intranet.wolseley.com'],

  }
}

# Intranet LinuxIntranet02
node e02415 {

  class{'webnode':

    group_ssl_intranet_hostname      =>  'ssl-groupintranet.wolseley.com',
    group_ssl_intranet_docroot       =>  '/sites/intranet/groupv2',
    group_ssl_intranet_serveradmin   =>  'it.ops@wolseley.co.uk',
    group_ssl_intranet_serveraliases =>  ['groupintranet.wolseley.com'],
    group_intranet_hostname          =>  'groupintranet.wolseley.com',
    group_intranet_docroot           =>  '/sites/intranet/groupv2',
    group_intranet_serveradmin       =>  'web_admin_ripon@wolseley.co.uk',
    group_intranet_serveraliases     =>  ['groupintranet.wolseley.com'],
    intranet2_hostname               =>  'intranet2.wolseley.co.uk',
    intranet2_docroot                =>  '/sites/intranet2/wuk',
    intranet2_serveraliases          =>  ['intranet2.wolseley.com'],
    intranet_hostname                =>  'intranet.wolseley.co.uk',
    intranet_docroot                 =>  '/sites/intranet2/wuk',
    intranet_serveraliases           =>  ['www.intranet.wolseley.com'],

  }
}

# Intranet DB Prod 01
node e02416 {

  include dbnode

}

# Intranet DB Prod 02
node e02417 {

  include dbnode

}

# Intranet DB Dev/Test 01
node e03425 {

  include dbnode

}

# Intranet DB Dev/Test 02
node e03426 {

  include dbnode

}

