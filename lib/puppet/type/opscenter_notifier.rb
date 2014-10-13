Puppet::Type.newtype(:opscenter_notifier) do
  desc 'Type for notifiying an OpsCenter installation of cluster information'

  ensurable do
    defaultto(:present)
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:name, :namevar => true) do
    desc 'Name of resource'
    newvalues(/^\S+$/)
  end

  newparam(:command) do
    desc 'command to execute on OpsCenter'
    defaultto('update_cluster_configs')
    newvalues(/^\S+$/)
  end

  newparam(:opscenter_ip) do
    desc 'ip address of OpsCenter'
    newvalues(/^\S+$/)
  end

  newparam(:ip_address) do
    desc 'ip address of node'
    newvalues(/^\S+$/)
  end

  newparam(:api_port) do
    desc 'Port to let OpsCenter know how to make rpc calls'
    newvalues(/^\d+$/)
  end

  newparam(:seed_nodes) do
    desc 'List of ip addresses of cassandra seed nodes to send to OpsCenter'
  end
end

