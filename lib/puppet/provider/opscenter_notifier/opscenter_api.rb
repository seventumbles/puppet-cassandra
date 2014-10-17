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
    seeds = resource[:seed_nodes].join(',')
    cluster_configs = {"cassandra" => {"seed_hosts" => "#{seeds}", "api_port" => resource[:api_port]}}.to_json
    opscenter_url = resource[:opscenter_ip] + '/cluster-configs'
    opscenter_api('-o', 'result.txt',
                  '-X',
                  'POST',
                  '-H',
                  '"application/json"',
                  opscenter_url,
                  '-d',
                  cluster_configs)
  end

end
