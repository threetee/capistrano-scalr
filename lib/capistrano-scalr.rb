# module Capistrano
#   module Scalr
#     # Your code goes here...
#   end
# end

unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/scalr requires Capistrano 2"
end

Capistrano::Configuration.instance(:must_exist).load do
  
  ###
  # Code below is stolen from Jamis' capistrano-ext
  def _cset(name, *args, &block)
    unless exists?(name)
      set(name, *args, &block)
    end
  end

  # =========================================================================
  # These variables MUST be set in the client capfiles. If they are not set,
  # the deploy will fail with an error.
  # =========================================================================

  _cset(:gateway) { abort "Please specify the instance to use as a gateway. Example: set :gateway, 'foo'" }
  _cset(:gateway_type)  { abort "Please specify the type of instance for your gateway. Example: set :gateway_type, 'ubuntu'" }
  ###
  
  ###
  # Modified recipes, initially taken from http://groups.google.com/group/scalr-discuss/web/scalr-with-capistrano
  namespace :scalr do 
    desc "Enumerate SCALR hosts" 
    # task :enum, :roles=>[:db],  :only => { :primary => true } do 
    task :enum, :roles=>[:gw] do 
      hosts = Hash.new 
      logger.info "SCALR Hosts:"
      if (gateway_type == 'centos')
        hosts_cmd = 'find /etc/scalr/private.d/hosts | cut -d"/" -f6,7 | grep "/"'
      elsif (gateway_type == 'ubuntu')
        hosts_cmd = 'find /etc/aws/hosts | cut -d"/" -f5,6 | grep "/"'
      else
        abort "You must specify a gateway type"
      end
      run hosts_cmd, :pty => true do |ch, stream, out| 
        next if out.chomp == '' 
        logger.info out.sub(/\//,' ') 
        out.split("\r\n").each do |host| 
          host=host.split("/") 
          (hosts[host[0]] ||= []) << host[1] 
        end 
      end
      if hosts.has_key?('mysql')
        if hosts['mysql'].size > 1 
          hosts['mysql'] = hosts['mysql'] - hosts['mysql-master']
        end
      end
      set :scalr_hosts, hosts
    end 
  end 

  scalr.enum

  role :lb, :no_release => true do
    scalr_hosts['loadbalancer']
  end
  role :web, :no_release => true do 
    scalr_hosts['www'] 
  end 
  role :app do 
    scalr_hosts['app'] 
  end 
  role :db, :no_release => true  do 
    scalr_hosts['mysql'] 
  end 
  role :memcached, :no_release => true do 
    scalr_hosts['memcached'] 
  end
  ###
  
end