stack 'hello-app' do
  # Create a machineset with app_service capabilities
  app_service 'helloapp' do
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
