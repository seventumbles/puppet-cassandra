require 'rubygems'
require 'json'

Puppet::Type.type(:opscenter_notifier).provide(:opscenter_api) do

  if Puppet::PUPPETVERSION.to_f < 3
    commands :opscenter_api => 'curl'
  else
     has_command(:opscenter_api, 'curl') do
       environment :HOME => "/tmp"
     end
  end

  #required callback for ensurable
  def create
    update_cluster_configs if resource[:seed_nodes].include? resource[:ip_address]
  end

  #required callback for ensurable
  def destroy
    #we never want puppet to remove a cluster from opscenter as part of a provisioning action
  end

  #required callback for ensurable
  def exists?
    #we always want create to be called
    false
  end

  #####

  def update_cluster_configs
    if get_cluster_configs.has_key? resource[:name]
      update_opscenter_cluster
    else
      new_opscenter_cluster
    end
  end

  def get_cluster_configs
    opscenter_url = "#{resource[:opscenter_ip]}/cluster-configs"
    JSON.parse opscenter_api('-s', opscenter_url)
  end

  def update_opscenter_cluster
    opscenter_url = "#{resource[:opscenter_ip]}/cluster-configs/#{resource[:name]}"
    notify_opscenter opscenter_url, 'PUT'
  end

  def new_opscenter_cluster
    opscenter_url = "#{resource[:opscenter_ip]}/cluster-configs"
    new_cluster_name = notify_opscenter opscenter_url, 'POST'

    #OpsCenter handles duplicate posts (made by race conditions) by creating a new cluster name with an autoincrement
    #number appended (mycluster -> mycluster1 -> mycluster2, etc).
    #When we lose the race, delete the newly created duplicate
    new_cluster_name = new_cluster_name.reverse.chomp('"').reverse.chomp('"')
    if new_cluster_name != resource[:name]
      delete_duplicate_from_opscenter("#{opscenter_url}/#{new_cluster_name}")
    end
  end

  def notify_opscenter(opscenter_url, method)
    seeds = resource[:seed_nodes].join(',')
    cluster_configs = {"cassandra" => {"seed_hosts" => "#{seeds}", "api_port" => resource[:api_port]}}.to_json
    opscenter_api('-s', '-X', method, '-H', '"application/json"', opscenter_url, '-d', cluster_configs)
  end

  def delete_duplicate_from_opscenter(opscenter_url)
    opscenter_api('-s', '-X', 'DELETE', opscenter_url)
  end
end
