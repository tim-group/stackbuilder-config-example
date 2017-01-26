stack 'puppetserver-cluster' do
   puppetserver_cluster 'puppetserver' do
    self.instances = {
      'earth' => 1
    }
    each_machine do |machine|
      machine.cnames = {} if environment.options[:disable_puppetmaster_cname_allocation]
    end
  end
end

# vim: set ts=2 sw=2 et :
