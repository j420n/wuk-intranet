#INCLUDE CLASSES DECLARED IN HIERADATA
#Look at files in hieradata directory
hiera_include("classes")

class wuk_defaults{
  class {'all_defaults': }
  class {'wuk_groups': } ->
  class {'wuk_users': }
}

class all_defaults {
  class { 'beluga':
    stage => pre,
  }
}

class prod_defaults {
  class {'wuk_defaults': }
  class {'sudo': }
  host {'e02414': # Intranet LAMP 01
    ip => '10.210.100.32'
  }
  host {'e02415': # Intranet LAMP 02
    ip => '10.210.100.33'
  }
  host {'e02416': # Intranet DB 01
    ip => '10.210.73.185'
  }
  host {'e02417': # Intranet DB 02
    ip => '10.210.73.186'
  }
  host {'e03422': # Intranet LAMP Dev/stage
    ip => '10.218.65.13'
  }
  host {'e03423': # Intranet LAMP Test 01
    ip => '10.218.100.11'
  }
  host {'e03424': # Intranet LAMP Test 02
    ip => '10.218.100.12'
  }
  host {'e03425': # Intranet DB Dev/Test 01
    ip => '10.218.65.14'
  }
  host {'e03426': # Intranet DB Dev/Test 01
    ip => '10.218.65.15'
  }
}

class wuk_users {
  beluga::user { 'noels':
    uid => 5001,
    groups => ['admins'],
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCuc0SV/j8yeDKINo8WOcaxrAbBxZuriZmT2OlXYEbZ3cWyzzevbI+nMcTc9UiivnFmFgTgV75qIlhv3p+dULF7Otu1fvGGFA0EY3ljeOPLqvF5hiqTmXDSvOEI3HQ0H5jiEWMmsFCSnVu5AaXuGKmHeotjQEczyYQmw0C7i8YV+HdnxlaN3A18SwzqfIClwuRDWogF3h3cQlHjXh4Kp68UOUB5LEX1XYP2/2l/dlXp+twJK7r/RI0JkLNLLDXaZjQpOkOVcuamcYemhbiDT4szVRz2SIkWAO/OwnGYOU0Zklv+7DJ1g1Gs8EQtr1l3LA6lv7Ah++kKUVKkUR8OkJlR',
    key_type => 'ssh-rsa',
  }

  beluga::user {'jasonb':
    uid => 5002,
    groups => ['admins'],
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCoypusMcT0LZTfvyh7DLC/xTPsOnEYS3JOSwP4PFmN5QnwQGO250kkXDQ6UttxfimJbquvZY2MN3jQbwlTwQIY8xap81v13WjxMIHmN4dYd5GVrIGz6fw7uen3N25r53MIVPjL2UiD9D6RYLPYi9D4VifyjHNvd23lHzNIBAQUBQMMD3x15dStpMQpBgxZKmTkFGtvX1sbpXPHn9JIF4WsCQJshd0KE3NpfzMZIsbjP2NNjujHeKxzbgRjR1U2cP8BWGezBk+ZIbvkAFfzqEuedR5t2tQmCEDmSnc3T+JfRl0qoyZWr9y3rQqroaMF0MvgpdzfX4XfKY4UqczZcQzF',
    key_type => 'ssh-rsa'
  }

  beluga::user {'djotto':
    uid     => 5003,
	groups  => ['admins'],
	ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCb0oQBfctaYbksZQnZp0MWIGtjJTd4o8tQGM3QJb39w31FiYFmXLo8XNLFnfZU1xr6WH2AeaaGtuPI5feemlzyDF58wHL1OSqETPQVqiSBiAz7WfiRl2Bdztu8yVvAEWWUJNDh9wncToa/dmBoMfq5K518iGoyO79NVU7FpzxCH9lSnL9bLHdC6bKXmuqUZ+lWRkTLVyUO9qt70GY58NohVJC15uUJ2tWA2TPl7PUMRvKL6TPjlosViQ8vBjFzWKO0+key8iWebz4Meu+xWJ9KDuH5ro4hSHOuIOduLARdw8DV6bnvTV4K9zC41dVIromNSj3Zwp0TQxOciC6/cg55',
	key_type => 'ssh-rsa',
  }
}

class wuk_groups {
  group {
    "admins":
    ensure  => present,
    gid     => 7000;
  }
}

class standards_site {

  mysql_user { ["standards@%"]:
    ensure => 'present',
    password_hash => mysql_password('standardspassword'),
  } ->

  mysql_grant { ["standards@%"]:
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => ["standards@%"],
  }
  mysql_database { 'standards':
      ensure  => 'present',
      charset => 'utf8',
  }
  file {['/var/www/private/', '/var/www/private/standards/','/var/www/files/', '/var/www/files/standards/', '/var/www/drupal/','/var/www/drupal/standards/']:
    ensure => 'directory',
    owner => 'co',
    group => 'www-data',
    mode => 775,
  }
  file {'/var/www/drupal/standards/logs':
    ensure => 'directory',
    owner => 'www-data',
    group => 'www-data',
  }
  apache::vhost { 'standards.data.gov.uk':
    override      => 'All',
    port          => 8080,
    manage_docroot  => false,
    docroot       => '/var/www/drupal/standards/current',
    docroot_owner => 'co',
    docroot_group => 'co',
    serveradmin   => 'support@dguteam.org.uk',
    serveraliases => [
      'standards.dguteam.org.uk',
      'standards'],
    log_level     => 'warn',
    logroot => '/var/www/drupal/standards/logs',
  }

  class dgu_fedt {
    #class { 'nginx': }

    #file { '/etc/nginx/conf.d/default.conf':
    #  ensure => absent,
    #}
    #file { '/etc/nginx/conf.d/default.conf':
    #  ensure => absent,
    #}

  }
}
