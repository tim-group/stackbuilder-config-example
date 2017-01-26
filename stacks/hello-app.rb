stack 'hello-app' do
  # Create a machineset with app_service capabilities
  app_service 'helloapp' do
    # Specify the name of the application that will be deployed to these servers.
    # JavaHttpRef is a dummy application we have created (see github)
    self.application = 'JavaHttpRef'
    #Specify how many servers should be created (default: 2)
    self.instances = {
      'earth' => 2,
      'moon'  => 0,
    }

    self.jvm_args = '-Xms1G -Xmx1G'

    # Declare dependency on another stack (target)
    #   * The fqdn of servers in the source stack (on the prod network) will be appended to a list of dependant_instances on the target stack
    #   * The target stack will provide config_params to the source stack
    depend_on = 'hellodb', 'staging', :read_write if %w(staging).include? environment.name

    # For each virtual machine in the stack
    each_machine do |machine|
      # Specify memory requirements (default: 2097152)
      machine.ram = '2097152'
      # Specify number of virtual cpu cores
      machine.vcpus = '1'
      # Specify disk space for / partition (default: 3G)
      machine.modify_storage({ '/' => { :size => '5G' } })
      # Specify that this machine should use the trusty gold image
      machine.use_trusty
      # Specify that this machine should go on a KVM host with the 'HP' tag (staging env only)
      machine.allocation_tags << 'HP' if %w(staging).include? environment.name
    end
  end
end
