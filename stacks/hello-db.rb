stack 'hello-db' do
  # MySQL Cluster Virtual Service
  mysql_cluster 'hellodb' do
    self.database_name = "hello"
    self.instances = { 'local' => 2 }
    self.instances = {
      'earth' => {
        :master => 1,
        :slave  => 0,
        :backup => 0
      },
      'moon' => {
        :master => 0,
        :slave => 0,
        :backup => 0
      }
    } if %w(staging).include? environment.name

    # Disable persistent storage (rebuilding server will rebuild storage == All data lost)
    self.create_persistent_storage_override
    each_machine do |machine|
      # Use Ubuntu precise
      machine.template(:precise)
      # By default all MySQL databases are protected from shutdown (non-destroyable). This option will override the default behaviour
      machine.destroyable = true
    end
  end
end
