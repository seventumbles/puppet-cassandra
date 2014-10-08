class cassandra::agent(
  $opscenter_ip
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
  }
}
