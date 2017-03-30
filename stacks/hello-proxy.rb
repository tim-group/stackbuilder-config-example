stack 'hello-proxy' do
  # Create a machineset with proxy_service capabilities
  proxy_service 'helloproxy' do
    # Create a new Apache vhost for a specific <application>, <fqdn>
    vhost('helloapp', 'hello.timgroup.com') do
      # Specify an additional server alias
      @aliases << 'helloworld.example.com'
      # Send apache logging to syslog
      @log_to_syslog = true
    end
    # Allow the nat server to discover and auto-configure itself for these proxy servers
    nat_config.dnat_enabled = true
    # For each virtual machine in the stack
    each_machine do |machine|
      # Specify that this machine should use the precise gold image
      machine.template(:precise)
    end
  end
end
