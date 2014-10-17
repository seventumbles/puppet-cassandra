class cassandra(
    $package_name                     = $cassandra::params::package_name,
    $version                          = $cassandra::params::version,
    $service_name                     = $cassandra::params::service_name,
    $config_path                      = $cassandra::params::config_path,
    $include_repo                     = $cassandra::params::include_repo,
    $repo_name                        = $cassandra::params::repo_name,
    $repo_baseurl                     = $cassandra::params::repo_baseurl,
    $repo_gpgkey                      = $cassandra::params::repo_gpgkey,
    $repo_repos                       = $cassandra::params::repo_repos,
    $repo_release                     = $cassandra::params::repo_release,
    $repo_pin                         = $cassandra::params::repo_pin,
    $repo_gpgcheck                    = $cassandra::params::repo_gpgcheck,
    $repo_enabled                     = $cassandra::params::repo_enabled,
    $repo_user                        = $cassandra::params::repo_user,
    $repo_password                    = $cassandra::params::repo_password,
    $max_heap_size                    = $cassandra::params::max_heap_size,
    $heap_newsize                     = $cassandra::params::heap_newsize,
    $jmx_port                         = $cassandra::params::jmx_port,
    $additional_jvm_opts              = $cassandra::params::additional_jvm_opts,
    $permissions_validity_in_ms       = $cassandra::params::permissions_validity_in_ms,
    $cluster_name                     = $cassandra::params::cluster_name,
    $listen_address                   = $cassandra::params::listen_address,
    $broadcast_address                = $cassandra::params::broadcast_address,
    $start_native_transport           = $cassandra::params::start_native_transport,
    $start_rpc                        = $cassandra::params::start_rpc,
    $rpc_address                      = $cassandra::params::rpc_address,
    $rpc_port                         = $cassandra::params::rpc_port,
    $rpc_server_type                  = $cassandra::params::rpc_server_type,
    $native_transport_port            = $cassandra::params::native_transport_port,
    $storage_port                     = $cassandra::params::storage_port,
    $partitioner                      = $cassandra::params::partitioner,
    $data_file_directories            = $cassandra::params::data_file_directories,
    $commitlog_directory              = $cassandra::params::commitlog_directory,
    $saved_caches_directory           = $cassandra::params::saved_caches_directory,
    $initial_token                    = $cassandra::params::initial_token,
    $num_tokens                       = $cassandra::params::num_tokens,
    $authenticator                    = $cassandra::params::authenticator,
    $authorizer                       = $cassandra::params::authorizer,
    $seeds                            = $cassandra::params::seeds,
    $concurrent_reads                 = $cassandra::params::concurrent_reads,
    $concurrent_writes                = $cassandra::params::concurrent_writes,
    $in_memory_compaction_limit_in_mb = $cassandra::params::in_memory_compaction_limit_in_mb,
    $incremental_backups              = $cassandra::params::incremental_backups,
    $snapshot_before_compaction       = $cassandra::params::snapshot_before_compaction,
    $auto_snapshot                    = $cassandra::params::auto_snapshot,
    $multithreaded_compaction         = $cassandra::params::multithreaded_compaction,
    $endpoint_snitch                  = $cassandra::params::endpoint_snitch,
    $internode_compression            = $cassandra::params::internode_compression,
    $disk_failure_policy              = $cassandra::params::disk_failure_policy,
    $thread_stack_size                = $cassandra::params::thread_stack_size,
    $service_enable                   = $cassandra::params::service_enable,
    $service_ensure                   = $cassandra::params::service_ensure,
    $hadoop_enabled                   = $cassandra::params::hadoop_enabled,
    $solr_enabled                     = $cassandra::params::solr_enabled,
    $spark_enabled                    = $cassandra::params::spark_enabled,
    $cfs_enabled                      = $cassandra::params::cfs_enabled,
    $client_encryption_cipher_suites  = $cassandra::params::client_encryption_cipher_suites,
    $client_encryption_truststore     = $cassandra::params::client_encryption_truststore,
    $server_encryption_cipher_suites  = $cassandra::params::server_encryption_cipher_suites,
    $compaction_preheat_key_cachetrue = $cassandra::params::compaction_preheat_key_cachetrue,
    $batch_size_warn_threshold_in_kb  = $cassandra::params::batch_size_warn_threshold_in_kb,
    $topology_default                 = $cassandra::params::topology_default,
    $topology                         = $cassandra::params::topology,
    $rackdc_dc                        = $cassandra::params::rackdc_dc,
    $rackdc_rack                      = $cassandra::params::rackdc_rack,
    $opscenter_ip                     = $cassandra::params::opscenter_ip,
) inherits cassandra::params {
    # Validate input parameters
    validate_bool($include_repo)

    validate_absolute_path($commitlog_directory)
    validate_absolute_path($saved_caches_directory)

    validate_string($cluster_name)
    validate_string($partitioner)
    validate_string($initial_token)
    validate_string($endpoint_snitch)
    validate_string($rackdc_dc)
    validate_string($rackdc_rack)

    validate_bool($start_rpc)
    validate_bool($start_native_transport)
    validate_re($rpc_server_type, '^(hsha|sync|async)$')
    validate_bool($incremental_backups)
    validate_bool($snapshot_before_compaction)
    validate_bool($auto_snapshot)
    validate_bool($multithreaded_compaction)
    validate_re($authenticator, '^(AllowAllAuthenticator|PasswordAuthenticator)$')
    validate_re($authorizer, '^(AllowAllAuthorizer|CassandraAuthorizer)$')
    validate_re($internode_compression, '^(all|dc|none)$')
    validate_re($disk_failure_policy, '^(stop|best_effort|ignore)$')
    validate_bool($service_enable)
    validate_re($service_ensure, '^(running|stopped)$')

    validate_array($additional_jvm_opts)
    validate_array($seeds)
    validate_array($data_file_directories)

    if(!is_integer($permissions_validity_in_ms)) {
        fail('permissions_validity_in_ms must be an integer')
    }

    if(!is_integer($thread_stack_size)) {
        fail('thread_stack_size must be an integer')
    }

    if(!is_integer($concurrent_reads)) {
        fail('concurrent_reads must be an integer')
    }

    if(!is_integer($concurrent_writes)) {
        fail('concurrent_writes must be an integer')
    }

    if(!is_integer($num_tokens)) {
        fail('num_tokens must be an integer')
    }

    if(!is_integer($jmx_port)) {
        fail('jmx_port must be a port number between 1 and 65535')
    }

    if(!empty($opscenter_ip) and !is_ip_address($opscenter_ip)) {
        fail('opscenter_ip must be an IP address')
    }

    if(!is_ip_address($listen_address)) {
        fail('listen_address must be an IP address')
    }

    if(!empty($broadcast_address) and !is_ip_address($broadcast_address)) {
        fail('broadcast_address must be an IP address')
    }

    if(!is_ip_address($rpc_address)) {
        fail('rpc_address must be an IP address')
    }

    if(!is_integer($rpc_port)) {
        fail('rpc_port must be a port number between 1 and 65535')
    }

    if(!is_integer($native_transport_port)) {
        fail('native_transport_port must be a port number between 1 and 65535')
    }

    if(!is_integer($storage_port)) {
        fail('storage_port must be a port number between 1 and 65535')
    }

    if(empty($seeds)) {
        fail('seeds must not be empty')
    }

    if(empty($data_file_directories)) {
        fail('data_file_directories must not be empty')
    }

    if(!empty($initial_token)) {
        notice("Starting with Cassandra 1.2 you shouldn't set an initial_token but set num_tokens accordingly.")
    }

    # Anchors for containing the implementation class
    anchor { 'cassandra::begin': }

    include java7

    if($include_repo) {
        class { 'cassandra::repo':
            repo_name => $repo_name,
            baseurl   => "http://${repo_user}:${repo_password}@${repo_baseurl}",
            gpgkey    => $repo_gpgkey,
            repos     => $repo_repos,
            release   => $repo_release,
            pin       => $repo_pin,
            gpgcheck  => $repo_gpgcheck,
            enabled   => $repo_enabled,
        }
        Class['cassandra::repo'] -> Class['cassandra::install']
    }

    include cassandra::install

    class { 'cassandra::config':
        config_path                      => $config_path,
        max_heap_size                    => $max_heap_size,
        heap_newsize                     => $heap_newsize,
        jmx_port                         => $jmx_port,
        additional_jvm_opts              => $additional_jvm_opts,
        permissions_validity_in_ms       => $permissions_validity_in_ms,
        cluster_name                     => $cluster_name,
        start_native_transport           => $start_native_transport,
        start_rpc                        => $start_rpc,
        listen_address                   => $listen_address,
        broadcast_address                => $broadcast_address,
        rpc_address                      => $rpc_address,
        rpc_port                         => $rpc_port,
        rpc_server_type                  => $rpc_server_type,
        native_transport_port            => $native_transport_port,
        storage_port                     => $storage_port,
        partitioner                      => $partitioner,
        data_file_directories            => $data_file_directories,
        commitlog_directory              => $commitlog_directory,
        saved_caches_directory           => $saved_caches_directory,
        initial_token                    => $initial_token,
        num_tokens                       => $num_tokens,
        authenticator                    => $authenticator,
        authorizer                       => $authorizer,
        seeds                            => $seeds,
        concurrent_reads                 => $concurrent_reads,
        concurrent_writes                => $concurrent_writes,
        in_memory_compaction_limit_in_mb => $in_memory_compaction_limit_in_mb,
        incremental_backups              => $incremental_backups,
        snapshot_before_compaction       => $snapshot_before_compaction,
        auto_snapshot                    => $auto_snapshot,
        multithreaded_compaction         => $multithreaded_compaction,
        endpoint_snitch                  => $endpoint_snitch,
        internode_compression            => $internode_compression,
        disk_failure_policy              => $disk_failure_policy,
        thread_stack_size                => $thread_stack_size,
        client_encryption_cipher_suites  => $client_encryption_cipher_suites,
        client_encryption_truststore     => $client_encryption_truststore,
        server_encryption_cipher_suites  => $server_encryption_cipher_suites,
        compaction_preheat_key_cachetrue => $compaction_preheat_key_cachetrue,
        batch_size_warn_threshold_in_kb  => $batch_size_warn_threshold_in_kb,
        hadoop_enabled                   => $hadoop_enabled,
        solr_enabled                     => $solr_enabled,
        spark_enabled                    => $spark_enabled,
        cfs_enabled                      => $cfs_enabled,
        rackdc_dc                        => $rackdc_dc,
        rackdc_rack                      => $rackdc_rack,
        opscenter_ip                     => $opscenter_ip,
    }

    class { 'cassandra::topology':
        config_path      => $config_path,
        topology         => $topology,
        topology_default => $topology_default,
    }

    class { 'cassandra::service':
        service_enable => $service_enable,
        service_ensure => $service_ensure,
    }->
    class { 'cassandra::agent':
        opscenter_ip  => $opscenter_ip,
        ip_address    => $::ipaddress,
        api_port      => $rpc_port,
        seed_nodes    => $seeds,
    }

    anchor { 'cassandra::end': }

    Anchor['cassandra::begin'] -> Class['cassandra::install'] -> Class['cassandra::config'] ~> Class['cassandra::service'] -> Anchor['cassandra::end']
}
