class cassandra::install {
    package { 'dse-full':
        ensure => $cassandra::version,
        name   => $cassandra::package_name,
    }
}
