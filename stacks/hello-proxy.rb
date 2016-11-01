stack 'hello-proxy' do
  # Create a machineset with proxy_service capabilities
  proxy_service 'helloproxy' do
    # Create a new Apache vhost for a specific application
    vhost('helloapp') do
      # Specify an additional server alias
      @aliases << 'helloworld.example.com'
      add_properties :apache_logs_to_syslog => true
    end
    # Allow the nat server to discover and auto-configure itself for these proxy servers
    enable_nat
  end
end
