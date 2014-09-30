class cassandra::topology(
  $config_path,
  $topology,
  $topology_default
) {
  file { "${config_path}/cassandra-topology.properties":
    ensure  => file,
    content => template("${module_name}/cassandra-topology.properties.erb"),
  }
}
