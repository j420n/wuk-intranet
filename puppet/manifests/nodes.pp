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
  include apache::mod::php

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
