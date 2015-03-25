#!/bin/bash
set -e

puppet_base='/vagrant/puppet'
to_provision='/vagrant/puppet/manifests/site.pp'

if [ -f /vagrant/vagrant.pp ] ;
then
  echo 'Found local vagrant.pp - using that instead'
  to_provision='/vagrant/vagrant.pp'
fi

# Don't change config if there are already keys
if [ ! -f /home/vagrant/.ssh/id_rsa ];
then

#    yum install puppet -y
#    yum install ruby -y
#    yum install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel -y
#    yum install ruby-rdoc ruby-devel -y
#    yum install rubygems -y
#    gem update
#    gem install hiera
#    gem install hiera-eyaml

    gem install hiera-puppet
    ln -s /usr/lib/ruby/gems/1.8/gems/hiera-puppet-1.0.0/ /vagrant/puppet/modules/hiera-puppet

    rm -rf /etc/puppet
    ln -sf /vagrant/puppet /etc/
    ln -sf /etc/puppet/hiera.yaml /etc/

    if [ ! -f /vagrant/keys/private_key.pkcs7.pem ];
    then
        cd /home/vagrant
        eyaml createkeys
    fi
fi

ln -sf /vagrant/hieradata /etc/

/usr/bin/puppet apply --verbose \
  --manifestdir=${puppet_base}/manifests \
  --modulepath=${puppet_base}/modules \
  ${to_provision}
