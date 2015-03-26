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

  file { [ "/sites", "/sites/intranet", "/sites/intranet2" ]:
    ensure => "directory",
  }

  apache::vhost { 'dev.intranet.wolseley.co.uk':
    port                        => '80',
    docroot                     => '/sites/intranet',
    override                    => 'All',
    directories                 => [{
      path                    => '/sites/intranet',
      options                 => ['Indexes','FollowSymLinks','MultiViews'],
    }],
  }
  apache::vhost { 'dev.intranet2.wolseley.co.uk':
    port                        => '80',
    docroot                     => '/sites/intranet2',
    override                    => 'All',
    directories                 => [{
      path                    => '/sites/intranet2',
      options                 => ['Indexes','FollowSymLinks','MultiViews'],
    }],
  }

  exec { 'download-php52':
    cwd     => '/vagrant',
    command => 'sudo curl -O http://museum.php.net/php5/php-5.2.17.tar.gz',
    path    => '/usr/local/bin/:/usr/bin/:/bin/',
    creates => '/vagrant/php-5.2.17.tar.gz',
  } ->
  exec { "extract-php52":
    cwd     => "/vagrant",
    command => "tar -zxvf php-5.2.17.tar.gz",
    path    => "/usr/local/bin/:/usr/bin/:/bin/",
    creates => '/vagrant/php-5.2.17',
  } ->
  exec { "make-php52":
    cwd     => "/vagrant/php-5.2.17",
    command => "bash ./configure --with-apxs2 --with-libdir=lib64 --build=x86_64-redhat-linux-gnu --host=x86_64-redhat-linux-gnu --target=x86_64-redhat-linux-gnu --program-prefix= --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/usr/com --mandir=/usr/share/man --infodir=/usr/share/info --cache-file=../config.cache --with-libdir=lib64 --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --disable-debug --with-pic --disable-rpath --without-pear --with-bz2 --with-curl --with-exec-dir=/usr/bin --with-freetype-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --without-gdbm --with-gettext --with-gmp --with-iconv --with-jpeg-dir=/usr --with-openssl --with-pcre-regex=/usr --with-zlib --with-layout=GNU --enable-exif --enable-ftp --enable-magic-quotes --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-wddx --with-kerberos --enable-ucd-snmp-hack --with-unixODBC=shared,/usr --enable-shmop --enable-calendar --without-mime-magic --without-sqlite --with-libxml-dir=/usr --enable-force-cgi-redirect --enable-pcntl --enable-mbstring=shared --enable-mbregex --with-gd=shared --enable-bcmath=shared --enable-dba=shared --with-db4=/usr --with-xmlrpc=shared --with-ldap=shared --with-ldap-sasl --with-mysql --with-mysqli=shared,/usr/bin/mysql_config --enable-dom=shared --with-snmp=shared,/usr --enable-soap=shared --with-xsl=shared,/usr --enable-xmlreader=shared --enable-xmlwriter=shared --enable-fastcgi --enable-pdo --with-pdo-odbc=shared,unixODBC,/usr --with-pdo-mysql --enable-json=shared --enable-zip=shared --with-readline --with-xpm-dir=/usr",
    path    => "/usr/local/bin/:/usr/bin/:/bin/",
    creates => '/vagrant/php-5.2.17/php5.spec'
  } ->
  exec { "install-php52":
    cwd     => "/vagrant/php-5.2.17",
    command => "make -j 2 && sudo make install",
    path    => "/usr/local/bin/:/usr/bin/:/bin/",
    creates => '/usr/bin/php',
  }

  class { 'beluga::developer_tools':
    install_grunt             => false,
    install_git               => true,
  }

  class { 'jenkins':
    configure_firewall        => false,
  }

}
