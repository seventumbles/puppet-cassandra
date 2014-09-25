class cassandra::repo::redhat(
    $repo_name,
    $baseurl,
    $gpgcheck,
    $enabled
) {
    yumrepo { $repo_name:
        descr    => 'DataStax Repo for DataStax Enterprise',
        baseurl  => $baseurl,
        gpgcheck => $gpgcheck,
        enabled  => $enabled,
    }
}
