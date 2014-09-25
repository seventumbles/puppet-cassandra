class cassandra::repo (
    $repo_name,
    $baseurl,
    $repos,
    $release,
    $pin,
    $gpgcheck,
    $enabled
){
    case $::osfamily {
        'Debian': {
            class { 'cassandra::repo::debian':
                repo_name  => $repo_name,
                location   => $baseurl,
                repos      => $repos,
                release    => $release,
                pin        => $pin,
            }
        }
        'RedHat': {
            class { 'cassandra::repo::redhat':
                repo_name => $repo_name,
                baseurl   => $baseurl,
                gpgcheck  => $gpgcheck,
                enabled   => $enabled,
            }
        }
        default: {
            fail("OS family ${::osfamily} not supported")
        }
    }
}
