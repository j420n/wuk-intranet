node default {
  crit( "Node only matched \"default\" for which there is no configuration, $::hostname" )
}

node wuk-dev {
  class {'beluga::mysql_server': }

  class { 'apache':
    mpm_module                  => 'prefork',
  }
  #include apache::mod::php
  include apache::mod::rewrite

  exec { 'download-php52':
    cwd     => '/vagrant',
    command => 'sudo curl -O http://museum.php.net/php5/php-5.2.17.tar.gz',
    path    => '/usr/local/bin/:/usr/bin/:/bin/',
  } ->
  exec { "extract-php52":
    cwd     => "/vagrant",
    command => "tar -zxvf php-5.2.17.tar.gz",
    path    => "/usr/local/bin/:/usr/bin/:/bin/",
  } ->
  exec { "make-php52":
    cwd     => "/vagrant/php-5.2.17",
    command => "bash ./configure --with-apxs2 --with-libdir=lib64 --build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu --target=x86_64-redhat-linux-gnu --program-prefix= --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/usr/com --mandir=/usr/share/man --infodir=/usr/share/info --cache-file=../config.cache --with-libdir=lib64 --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --disable-debug --with-pic --disable-rpath --without-pear --with-bz2 --with-curl --with-exec-dir=/usr/bin --with-freetype-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --without-gdbm --with-gettext --with-gmp --with-iconv --with-jpeg-dir=/usr --with-openssl --with-pcre-regex=/usr --with-zlib --with-layout=GNU --enable-exif --enable-ftp --enable-magic-quotes --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-wddx --with-kerberos --enable-ucd-snmp-hack --with-unixODBC=shared,/usr --enable-shmop --enable-calendar --without-mime-magic --without-sqlite --with-libxml-dir=/usr --enable-force-cgi-redirect --enable-pcntl --enable-mbstring=shared --enable-mbregex --with-gd=shared --enable-bcmath=shared --enable-dba=shared --with-db4=/usr --with-xmlrpc=shared --with-ldap=shared --with-ldap-sasl --with-mysql --with-mysqli=shared,/usr/bin/mysql_config --enable-dom=shared --with-snmp=shared,/usr --enable-soap=shared --with-xsl=shared,/usr --enable-xmlreader=shared --enable-xmlwriter=shared --enable-fastcgi --enable-pdo --with-pdo-odbc=shared,unixODBC,/usr --with-pdo-mysql --enable-json=shared --enable-zip=shared --with-readline --with-xpm-dir=/usr",
    path    => "/usr/local/bin/:/usr/bin/:/bin/",
  } ->
  exec { "install-php52":
    cwd     => "/vagrant/php-5.2.17",
    command => "make -j 2 && sudo make install",
    path    => "/usr/local/bin/:/usr/bin/:/bin/",
  }

}

node /.*\.dgudev/ {
  # Thinking of modifying this for your own needs?
  # Don't! Create 'vagrant.pp' in the same directory
  # as your Vagrantfile and the vagrant provisioner
  # will use that instead.

  include beluga::mail_server
  include beluga::drush_server
  include beluga::mysql_server
  include beluga::ruby_frontend
  include dgu_defaults
  include memcached
  include orgdc
  include redis

  class { 'sudo':
    purge                     => false,
    config_file_replace       => false,
  }

  class { 'beluga::developer_tools':
    install_git               => true,
    install_vim               => true,
  }


  class { 'beluga::frontend_traffic_director':
    extra_selectors           => $extra_selectors,
    frontend_domain           => 'dgud7',
    backend_domain            => 'dgud7',
  }

  class { 'jenkins':
    configure_firewall        => false,
  }

  include dgu_solr

  beluga::drupal_site { 'standards':
    site_owner => 'co'
  }
  beluga::drupal_site { 'dgud7':
    site_owner => 'co'
  }
  package {'puppetmaster':
    ensure  =>  latest,
  }

  host{'localhost':
    ensure => present,
    host_aliases => ['dgud7', 'standards', 'ckan'],
    ip => '127.0.0.1',
  }
}

node standards {

  include prod_defaults
  network_config { 'eth0':
    ensure  => 'present',
    family  => 'inet',
    method  => 'static',
    ipaddress => '46.43.41.17',
    netmask => '255.255.255.192',
    onboot  => 'true',
  }

  class {"beluga::developer_tools":
    install_git => true,
  }

  class {'beluga::apache_frontend_server': }

  class {'beluga::mysql_server': }

  class { 'beluga::drush_server': }
  include standards_site

}

node puppetmaster {
  include prod_defaults
}

node dataconversion {
  include epimorphics_defaults
  include java
  class { "tomcat":
  }
  include orgdc
}

node dataservice {
  include epimorphics_defaults
  include java
  class { "tomcat":
  }
}

node epdev {
  include epimorphics_defaults
  include java
  class { "tomcat":
  }
}
