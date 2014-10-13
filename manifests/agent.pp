class cassandra::agent(
  $opscenter_ip,
  $ip_address,
  $api_port,
  $seed_nodes
) {
  file { '/var/lib/datastax-agent/conf/address.yaml':
    ensure  => file,
    content => template("${module_name}/address.yaml.erb"),
    require => Package['dse-full'],
    notify => Service['datastax-agent']
  }

  service { 'datastax-agent':
    ensure     => running,
    enable     => true,
    subscribe  => File['/var/lib/datastax-agent/conf/address.yaml'],
    require    => File['/var/lib/datastax-agent/conf/address.yaml'],
    notify     => Exec['wait-for-cassandra-to-listen'],
  }

  if (!empty($opscenter_ip)) {
    package { 'curl':
      ensure => 'present',
    }
    exec {'wait-for-cassandra-to-listen':
      command     => "curl -s 172.28.128.4:9160",
      path        => '/usr/bin',
      refreshonly => true,
      tries       => 30,
      try_sleep   => 3,
      returns     => [0, 52],
      require     => Class['cassandra::service'],
      notify      => Opscenter_notifier['notify_opscenter_of_cluster_configs'],
    }
    opscenter_notifier {'notify_opscenter_of_cluster_configs':
      command       => 'update_cluster_configs',
      opscenter_ip  => $opscenter_ip,
      ip_address    => $ip_address,
      api_port      => $api_port,
      seed_nodes    => $seed_nodes,
    }
  }
}
