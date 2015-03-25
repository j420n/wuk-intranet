class all_defaults{
  class { 'beluga':
    stage => pre,
  }
}
class dgu_defaults{
  class {'all_defaults': }
  class {'dgu_groups': } ->
  class {'dgu_users': } ->
  class {'dgu_keys': }
}

class prod_defaults {
  class {'dgu_defaults': }
  class {'sudo': }
  host {'puppet':
    ip => '46.43.41.19'
  }
  host {'standards':
    ip => '46.43.41.17'
  }
  host {'dataconverter':
    ip => '46.43.41.16'
  }
  host {'dataservice':
    ip => '46.43.41.18'
  }
}

class dgu_users {
  beluga::user { 'noels':
    uid => 5001,
    groups => ['admins'],
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCuc0SV/j8yeDKINo8WOcaxrAbBxZuriZmT2OlXYEbZ3cWyzzevbI+nMcTc9UiivnFmFgTgV75qIlhv3p+dULF7Otu1fvGGFA0EY3ljeOPLqvF5hiqTmXDSvOEI3HQ0H5jiEWMmsFCSnVu5AaXuGKmHeotjQEczyYQmw0C7i8YV+HdnxlaN3A18SwzqfIClwuRDWogF3h3cQlHjXh4Kp68UOUB5LEX1XYP2/2l/dlXp+twJK7r/RI0JkLNLLDXaZjQpOkOVcuamcYemhbiDT4szVRz2SIkWAO/OwnGYOU0Zklv+7DJ1g1Gs8EQtr1l3LA6lv7Ah++kKUVKkUR8OkJlR',
    key_type => 'ssh-rsa',
  }

  beluga::user {'jasonb':
    uid => 5005,
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCoypusMcT0LZTfvyh7DLC/xTPsOnEYS3JOSwP4PFmN5QnwQGO250kkXDQ6UttxfimJbquvZY2MN3jQbwlTwQIY8xap81v13WjxMIHmN4dYd5GVrIGz6fw7uen3N25r53MIVPjL2UiD9D6RYLPYi9D4VifyjHNvd23lHzNIBAQUBQMMD3x15dStpMQpBgxZKmTkFGtvX1sbpXPHn9JIF4WsCQJshd0KE3NpfzMZIsbjP2NNjujHeKxzbgRjR1U2cP8BWGezBk+ZIbvkAFfzqEuedR5t2tQmCEDmSnc3T+JfRl0qoyZWr9y3rQqroaMF0MvgpdzfX4XfKY4UqczZcQzF',
    key_type => 'ssh-rsa'
  }

  beluga::user {'djotto':
    uid     => 5018,
	groups  => ['admins'],
	ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCb0oQBfctaYbksZQnZp0MWIGtjJTd4o8tQGM3QJb39w31FiYFmXLo8XNLFnfZU1xr6WH2AeaaGtuPI5feemlzyDF58wHL1OSqETPQVqiSBiAz7WfiRl2Bdztu8yVvAEWWUJNDh9wncToa/dmBoMfq5K518iGoyO79NVU7FpzxCH9lSnL9bLHdC6bKXmuqUZ+lWRkTLVyUO9qt70GY58NohVJC15uUJ2tWA2TPl7PUMRvKL6TPjlosViQ8vBjFzWKO0+key8iWebz4Meu+xWJ9KDuH5ro4hSHOuIOduLARdw8DV6bnvTV4K9zC41dVIromNSj3Zwp0TQxOciC6/cg55',
	key_type => 'ssh-rsa',
  }
}

class dgu_keys {

  beluga::user::key {'jenkins_deployment':
    user => 'co',
    ssh_key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAyd/uQuz+TAekzlXN0BJjxjdQhhjw/ilVZrjatVwZqBc92gR0vb4GqK3N1FIxKxnQ5ITFktiJuIV3t6FLtG6kjrZWpir0su4qQaAtk3OvZy4m0yDeYyBgUewRWJ8LkRKc1jE/V4KQWfUGFnp8FAkf3Z7WWuMsrmPbyXeKxhhXAWA+twMPG/eal7GYplA+7Vs5HMeqLsneOKlOIFORoE6c5Wro/jZtd+zZtjVOusZcL4ivlaj9SjjcAV71RjQdWR/WwAmewA9DE8QSKNwCbbC4t9Wt7MMyQAFnCS7fOBn54/Pmchc71wYr5s/2/z3m6CCTmamA5tA5nbIuPjZIiaT4cw==',
    key_type => 'ssh-rsa'
  }
}

class dgu_groups {
  group {
    "admins":
    ensure  => present,
    gid     => 7000;
  }
}

class epimorphics_users {
  beluga::user {'epimorphics':
    groups => ['admins'],
    uid => 6000,
  }
}

class epimorphics_keys {
  beluga::user::key {'dave@epimorphics.com':
    user => 'epimorphics',
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC42Ox+TLOfsTsb1kKybfj3WPOzrEjlfRnL8n1fl0218PLfSbpgaY7pUZZyoptfS5mpSTn3vzvmswib5nEY6wDM94PMdhZtjTIlfy6v84yoibq/Qn3PyVD72V7/lsKchuMElzLtFhPVptNu/OZ4vhkuj9k+z/PL2+RfqULUE+gQcomCYccGvdqu74/BX8QZqLkdygElksO7MSI4ohS//P73eCynqdI4cRAZf9V3CktQySesmYaFW3pdCgYhLq4XWMREcGlGw9aZ0W/uQYo9vw98MqCtThJPY/sW5ZgiTAOjtDRDXVIN45t96Zy5Y0Fbv677UOnZDdLVaoEdxIqlIuYv',
    key_type => 'ssh-rsa',
  }
}

class epimorphics_defaults {

  class { 'beluga::facts::role':
    stage => pre,
    role => 'epimorphics',
  } ->
  class {'prod_defaults': } ->
  class {'epimorphics_users': } ->
  class {'epimorphics_keys': }
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
