class cassandra::install {
    package { 'dse-full':
        ensure => $cassandra::version,
        name   => $cassandra::package_name,
    }

    $python_cql_name = $::osfamily ? {
        'Debian'    => 'python-cql',
        'RedHat'    => 'python26-cql',
        default     => 'python-cql',
    }

    package { $python_cql_name:
        ensure => installed,
    }
}
