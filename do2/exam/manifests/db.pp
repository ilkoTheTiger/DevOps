package { git: }

vcsrepo { '/code':
  ensure => present,
  provider => git,
  source => 'https://github.com/shekeriev/do2-app-pack.git',
}

class { '::mysql::server':
  root_password => '12345',
  remove_default_accounts => true,
  restart => true,
  override_options => {
    mysqld => { bind-address => '0.0.0.0'}
  },
}

mysql::db { 'db1':
  user => 'root',
  password => '12345',
  host => '%',
  sql => ['/code/app2/db/db_setup.sql'],
  enforce_sql => true,
}

mysql::db { 'db12':
  user => 'root',
  password => '12345',
  host => '%',
  sql => ['/code/app4/db/db_setup.sql'],
  enforce_sql => true,
}

file_line { 'hosts-web':
  ensure => present,
  path => '/etc/hosts',
  line => '192.168.99.101  WebServer  web',
  match => '^192.168.99.101',
}

file_line { 'hosts-db':
  ensure => present,
  path => '/etc/hosts',
  line => '192.168.99.102  DBServer  db',
  match => '^192.168.99.102',
}

class { 'firewall': }

firewall { '000 accept 3306/tcp':
  action => 'accept',
  dport => 3306,
  proto => 'tcp',
}
