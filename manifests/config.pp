class cassandra::config(
    $config_path,
    $max_heap_size,
    $heap_newsize,
    $jmx_port,
    $additional_jvm_opts,
    $permissions_validity_in_ms,
    $cluster_name,
    $start_native_transport,
    $start_rpc,
    $listen_address,
    $broadcast_address,
    $rpc_address,
    $rpc_port,
    $rpc_server_type,
    $native_transport_port,
    $storage_port,
    $partitioner,
    $data_file_directories,
    $commitlog_directory,
    $saved_caches_directory,
    $initial_token,
    $num_tokens,
    $authenticator,
    $authorizer,
    $seeds,
    $concurrent_reads,
    $concurrent_writes,
    $in_memory_compaction_limit_in_mb,
    $incremental_backups,
    $snapshot_before_compaction,
    $auto_snapshot,
    $multithreaded_compaction,
    $endpoint_snitch,
    $internode_compression,
    $disk_failure_policy,
    $thread_stack_size,
    $client_encryption_cipher_suites,
    $client_encryption_truststore,
    $server_encryption_cipher_suites,
    $compaction_preheat_key_cachetrue,
    $batch_size_warn_threshold_in_kb,
    $hadoop_enabled,
    $solr_enabled,
    $spark_enabled,
    $cfs_enabled,
    $rackdc_dc,
    $rackdc_rack,
) {
    group { 'cassandra':
        ensure  => present,
        require => Class['cassandra::install'],
    }

    user { 'cassandra':
        ensure  => present,
        require => Group['cassandra'],
    }

    File {
        owner   => 'cassandra',
        group   => 'cassandra',
        mode    => '0644',
        require => Class['cassandra::install'],
    }

    file { $data_file_directories:
        ensure  => directory,
    }

    file { "${config_path}/cassandra-env.sh":
        ensure  => file,
        content => template("${module_name}/cassandra-env.sh.erb"),
    }

    file { "${config_path}/cassandra.yaml":
        ensure  => file,
        content => template("${module_name}/cassandra.yaml.erb"),
    }

    file { "${config_path}/cassandra-rackdc.properties":
        ensure  => file,
        content => template("${module_name}/cassandra-rackdc.properties.erb"),
    }

    file { '/etc/default/dse':
        owner   => 'root',
        group   => 'opscenter-admin',
        mode    => '0775',
        ensure  => file,
        content => template("${module_name}/dse.erb"),
    }
}
