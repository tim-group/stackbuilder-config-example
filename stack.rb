## Stacks Config
#
# This is a DSL that is used by stacks to configure services allows the following to be defined:
#
# Computenode
#   * KVM host that has been setup to host Stacks
#
# Environments
#   * Contain a primary_site (location)
#   * Contain a secondary_site (location)
#   * Container for Stacks
#
# Stack
#   * Container of Virtual Services
#   * Exist in 0 or more environment
#   * Can be configured differently but are generally identical across all environments
#
# Virtual Service
#   * Container consisting of 1 or more virtual machine
#   * Load balanced these can work jointly to provide a service eg. several apache servers provide proxying
#   * Non-load balanced virtual machines, operate in a standalone basis (JBOVM)
#
# Virtual Machine
#   * A single machine of a given type: e.g a single apache virtual machine
#   * Can be individually configured but are generally identical to their siblings
#

stack 'helloworld' do
  # Create a virtual proxy stack
  virtual_proxyserver 'helloproxy' do
    # Create a new Apache vhost for a specific application
    vhost('helloapp', {:server_name => 'hello.example.com'}, vhost_properties={:apache_logs_to_syslog => true}) do
      # Specify an additional server alias
      with_alias "helloworld.example.com"
    end
    # Allow the nat server to discover and auto-configure itself for these proxy servers
    enable_nat
  end

  # Create a virtual application server stack
  virtual_appserver 'helloapp' do
    # Specify the name of the application that will be deployed to these servers.
    # JavaHttpRef is a dummy application we have created (see github)
    self.application = 'JavaHttpRef'
    #Specify how many servers should be created (default: 2)
    self.instances = 2
    # Declare dependency on another stack (target)
    #   * The fqdn of servers in the source stack (on the prod network) will be appended to a list of dependant_instances on the target stack
    #   * The target stack will provide config_params to the source stack
    depend_on = 'hellodb'
    # For each machine in the stack
    each_machine do |machine|
      # Specify memory requirements (default: 2097152)
      machine.ram = '2097152'
      # Specify number of virtual cpu cores
      machine.vcpus = '1'
      # Specify disk space for / partition (default: 3G)
      machine.modify_storage({ '/' => { :size => '5G' } })
    end
  end
end


stack 'hello_db' do
  # MySQL Cluster Virtual Service
  mysql_cluster 'hellodb' do
    self.database_name = "hello"
    # Specify number of backup instances (default: 1) in the secondary_site
    self.backup_instances = 0
    # Specify number of master instances (default: 1) in the primary_site
    self.master_instances = 1
    # Specify number of slave instances (default: 1) in the primary_site
    self.slave_instances = 0
    # Disable persistent storage (rebuilding server will rebuild storage == All data lost)
    self.create_persistent_storage_override
    each_machine do |machine|
      # By default all MySQL databases are protected from shutdown (non-destroyable). This option will override the default behaviour
      machine.allow_destroy(true)
    end
  end
end

stack 'puppet_master' do
  puppetmaster 'puppetmaster' do
    self.instances = 1
    each_machine do |machine|
      machine.cnames = {} if environment.options[:disable_puppetmaster_cname_allocation]
    end
  end
end

# Special stack for 'fabric virtual services'
# Fabric virtual services are common
stack 'fabric' do
  natserver
  loadbalancer
end

# Staging Environment
env 'staging',
  {
    # Primary location where stacks will be located
    :primary_site=>'earth',
    # Secondary location where stacks will be located
    :secondary_site=>'moon',
    # Unique reference for load balancers to use in this environment (to avoid conflicts ensure this number is unique in every environment
    # FIXME: Ideally we would auto-generate this number
    :lb_virtual_router_id=>130,
    # Do Compute nodes in this environment support persistent storage? (default: truee)
    :persistent_storage_supported=>true,
    # Allow every machine to be destroyable (Overrides individiual allow_destroy settings for all Virtual Machines)
    :every_machine_destroyable=>true,
} do
  instantiate_stack 'fabric'
  instantiate_stack 'helloworld'
  instantiate_stack 'hello_db'
end

# Local Development Environment
env 'dev',
  {
    # Primary location where stacks will be located
    :primary_site=>'local',
    # Unique reference for load balancers to use in this environment (to avoid conflicts ensure this number is unique in every environment
    # FIXME: Ideally we would auto-generate this number
    :lb_virtual_router_id=>1,
    # Do Compute nodes in this environment support persistent storage? (default: truee)
    :persistent_storage_supported=>false,
    # Allow every machine to be destroyable (Overrides individiual allow_destroy settings for all Virtual Machines)
    :every_machine_destroyable=>true,
} do
  instantiate_stack 'fabric'
  instantiate_stack 'helloworld'
  instantiate_stack 'hello_db'
end

# vim: set ts=2 sw=2 et :
