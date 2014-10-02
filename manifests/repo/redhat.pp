class cassandra::repo::redhat(
    $repo_name,
    $baseurl,
    $gpgkey,
    $gpgcheck,
    $enabled
) {
    yumrepo { $repo_name:
        descr    => 'DataStax Repo for DataStax Enterprise',
        baseurl  => $baseurl,
        gpgkey   => $gpgkey,
        gpgcheck => $gpgcheck,
        enabled  => $enabled,
    }
}
