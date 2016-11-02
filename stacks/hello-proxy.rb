stack 'hello-proxy' do
  # Create a machineset with proxy_service capabilities
  proxy_service 'helloproxy' do
    # Create a new Apache vhost for a specific <application>, <fqdn>
    vhost('helloapp', 'hello.timgroup.com') do
      # Specify an additional server alias
      @aliases << 'helloworld.example.com'
      # Send apache logging to syslog
      add_properties :apache_logs_to_syslog => true
    end
    # Allow the nat server to discover and auto-configure itself for these proxy servers
    enable_nat
  end
end
