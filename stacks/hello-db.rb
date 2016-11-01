stack 'hello-db' do
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
