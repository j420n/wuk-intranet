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
    ensure                      => "directory",
  }

  apache::vhost { 'dev.intranet.wolseley.co.uk':
    serveraliases               => ['www.dev.intranet.wolseley.co.uk'],
    port                        => '80',
    serveradmin                 => 'web_admin_ripon@wolseley.co.uk',
    docroot                     => '/sites/intranet/wuk',
    redirect_status             => 'permanent',
    redirect_source             => '/testarena.html',
    redirect_dest               => 'http://dev.intranet2.wolseley.co.uk/testarena.html',
    rewrites                    => [
      {
        rewrite_cond            => ['%{REQUEST_URI} ^/bathstore/_admin(.*)'],
        rewrite_rule            => ['^/(.*) http://www.bathstore.com/__admin$2 [R,L]'],
      },
    ],
    additional_includes         => [
      '/usr/local/apache/conf/compression.conf',
    ],

    proxy_pass                  => [
      {
        'path' => '/login/',
        'url'  => 'http://login.wolseley.co.uk/',
        'reverse_urls' => ['http://login.wolseley.co.uk/']
      },
    ],

    custom_fragment             => '<Proxy http://dev.intranet.wolseley.co.uk/login/*>
Order deny,allow
Allow from all
</Proxy>',

    directories                 => [
      {
        path                    => '/sites/intranet/wuk',
        options                 => ['FollowSymLinks'],
        php_value               => 'include_path ".:/sites/intranet/wuk/pipeline/qcodo/wwwroot/includes/:/sites/intranet/wuk/"',
        rewrites                => [
          {
            comment             => 'Rewrite URLs for old worklog -> new worklog / Strip query string from projects/index.php and forward to /worklog/index.php',
            rewrite_rule        => '^projects/index.php?.+ /worklog/index.php$1? [R=301,L]'
          },
          {
            comment             => 'Any requests for /projects(/) sent to /worklog/',
            rewrite_rule        => '^projects(/)?$ /worklog/ [R=301,L]'
          },
          {
            comment             => 'If project.php is requested, redirect to project_overview with same query string',
            rewrite_rule        => '^projects/project.php(\?[a-z0-9=&]+)? /worklog/project_overview.php$1 [R=301,L]'
          },
          {
            comment             => 'If request.php is request, then serve it!',
            rewrite_rule        => '^projects/request.php /worklog/request.php [R=301,L]'
          },
          {
            comment             => 'Everything else, send to worklog home',
            rewrite_cond        => [
              'RewriteCond $1 download [OR]',
              'RewriteCond $1 logs     [OR]',
              'RewriteCond $1 report   [OR]',
              'RewriteCond $1 users    [OR]',
              'RewriteCond $1 review   [OR]',
              'RewriteCond $1 index'
            ],
            rewrite_rule        => '^projects/(.+)\.php(\?[a-zA-Z0-9=&%]+)?$      /worklog/index.php [R=301,L]'
          },
          {
            comment             => 'Rewrite rules for estimating quotelog',
            rewrite_cond        => ['$1 !^(_|index\.php|images|robots\.txt)'],
            rewrite_rule        => ['^estimating/(.*)$ /estimating/index.php/$1 [L]'],
          },
          {
            comment             => 'Rewrite rules for HR training calendar',
            rewrite_cond        => ['$1 !^(_|index\.php|images|robots\.txt)'],
            rewrite_rule        => ['^training_calendar/(.*)$ /training_calendar/index.php/$1 [L]'],
          },
          {
            comment             => 'Rewrite rules for moderator training calendar',
            rewrite_cond        => ['$1 !^(_|index\.php|images|robots\.txt)'],
            rewrite_rule        => ['^moderator_training/(.*)$ /moderator_training/index.php/$1 [L]'],
          },
          {
            comment             => 'Rewrite rule for Pay & Grading page',
            rewrite_rule        => ['^21220108$ /main.php?id=4610 [L]'],
          },
          {
            comment             => 'Rewrite rule for Flexible working',
            rewrite_rule        => ['^1213140308$ /main.php?id=4671 [L]'],
          },
          {
          comment               => 'Rewrite rule for Pensions',
          rewrite_rule          => ['^pensproc08$ /main.php?id=5227 [L]'],
          },
          {
            comment             => 'Rewrite rule for Ideas for Rob',
            rewrite_rule        => ['^ideasforrob$ /main.php?id=5492 [L]'],
          },
          {
            comment             => 'Rewrite for pip to intranet2',
            rewrite_rule        => ['^pip(.*) http://dev.intranet2.wolseley.co.uk/pip$1 [R,L]'],
          },
          {
            comment             => 'Rewrite for woltrain now for intranet2',
            rewrite_rule        => ['^woltrain(.*) http://dev.intranet2.wolseley.co.uk/woltrain$1 [R,L]'],
          },
        ]
      },
      {
        path                    => '/sites/intranet/wuk/returns',
        directoryindex          => 'british-gas-returns.php'
      },
      {
        path                    => '/sites/intranet/wuk/cw',
        php_value               => 'include_path "/sites/intranet/wuk/cw/includes/"'
      },
      {
        path                    => '/sites/intranet/wuk/leaguetables',
        options                 => ['Indexes','SymLinksIfOwnerMatch'],
      },
      {
        path                    => '/sites/intranet/wuk/pip',
        options                 => ['All'],
        allow_override          => ['All'],
      },
    ],
  }

  apache::vhost { 'dev.intranet2.wolseley.co.uk':
    port                        => '80',
    docroot                     => '/sites/intranet2',
    override                    => 'All',
    directories                 => [{
      path                      => '/sites/intranet2',
      options                   => ['Indexes','FollowSymLinks','MultiViews'],
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
