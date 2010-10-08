## capistrano-scalr

The capistrano-scalr gem conveniently packages modified versions of Donovan Bray's [Scalr capistrano recipes](http://groups.google.com/group/scalr-discuss/web/scalr-with-capistrano).

## Installation and Usage

First, install the gem:

    gem install capistrano-scalr

After gem installation, add the following to your deploy.rb:

    set :gateway, "<gateway_host>"
    role :gw, gateway, :no_release => true
    set :gateway_type, "<centos|ubuntu>"
    require 'capistrano-scalr'

The above will automatically connect to your scalr farm using the gateway you specify (the primary database server is a logical choice, since it usually stays pretty static), enumerate the instances in your farm, and populate the `scalr_hosts` array with the instances. You can then define roles based on `scalr_hosts`:

    role :lb, :no_release => true do
      scalr_hosts['loadbalancer']
    end
    role :web, :no_release => true do 
      scalr_hosts['www'] 
    end 
    role :app do 
     scalr_hosts['app'] 
    end 
    role :db, :no_release => true do 
     scalr_hosts['mysql'] 
    end
    role :memcached, :no_release => true do 
      scalr_hosts['memcached'] 
    end

I also recommend that you use ssh-agent on your development workstation, enable agent forwarding on your scalr hosts, and set this in deploy.rb:

    set :ssh_options, { :forward_agent => true }

Once you have completed the above, you can test for proper operation by running the scalr:enum cap task:

    $ cap scalr:enum
      * executing `scalr:enum'
     ** SCALR Hosts:
      * executing "find /etc/aws/hosts | cut -d\"/\" -f5,6 | grep \"/\""
        servers: ["scalrgw.domain.net"]
      * establishing connection to gateway `scalrgw.domain.net'
      * Creating gateway using scalrgw.domain.net
      * establishing connection to `scalrgw.domain.net' via gateway
        [scalrgw.domain.net] executing command
     ** app/10.0.0.1
     ** app/10.0.0.2
     ** www/10.0.0.3
     ** www/10.0.0.4
     ** mysql/10.0.0.5
     ** mysql/10.0.0.6
     ** mysql-slave/10.0.0.5
     ** mysql-master/10.0.0.6
        command finished

You should now be able to deploy to your scalr farm via capistrano, and not have to worry about having to adjust your deploy.rb when instances change.

## TODO

- Auto-detect gateway platform

## Credits

- Thanks to [Donovan Bray](http://www.donovanbray.com), the original author of the Scalr capistrano recipes on which this gem's recipes are based
- Thanks to [Jamis Buck](http://weblog.jamisbuck.org) for the fantastic [Capistrano](http://capify.org)