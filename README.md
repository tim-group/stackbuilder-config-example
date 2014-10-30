Stackbuilder Config
=========
This is a DSL that is used by [stackbuilder] to configure allocate, provision 'Stacks' of Virtual Machines

[stackbuilder]:https://github.com/tim-group/stackbuilder
[provisioning-tools]:https://github.com/tim-group/provisioning-tools

Terminology
-----------
##### Computenode:
* This is a dom0 (KVM host) that has been configured to host stack built Virtual Machines
* Dependencies:
  * [provisioning-tools]

#####Environments:
* Container of Stacks
* Attributes:
  * primary_site (location)
  * secondary_site (location)

#####Stack:
* Container of Virtual Services
* Exist in 0 or more environment
* Can be configured differently but are generally identical across all environments

#####Virtual Service:
* Container consisting of 1 or more Virtual Machine's
* Load balanced these can work jointly to provide a service eg. several apache servers provide proxying
* Non-load balanced virtual machines, operate in a standalone basis (JBOVM)

#####Virtual Machine:
* A single machine of a given type: e.g a single apache virtual machine
* Can be individually configured but are generally identical to their siblings

---------------------------------

Usage information
-----------



###Virtual Machines


####Show Virtual Machine spec for Virtual Machine staging-helloapp-001
```sh
$ env='staging' rake sbx:staging-helloapp-001:to_specs
      - !ruby/sym networks:
      - !ruby/sym mgmt
      - !ruby/sym prod
    !ruby/sym ram: "2097152"
    !ruby/sym fabric: earth
    !ruby/sym domain: earth.net.local
    !ruby/sym vcpus: "1"
    !ruby/sym qualified_hostnames:
      !ruby/sym mgmt: staging-helloapp-001.mgmt.earth.net.local
      !ruby/sym prod: staging-helloapp-001.earth.net.local
    !ruby/sym hostname: staging-helloapp-001
    !ruby/sym availability_group: staging-helloapp
    !ruby/sym storage:
      !ruby/sym /:
        !ruby/sym type: os
        !ruby/sym prepare:
          !ruby/sym method: image
          !ruby/sym options:
            !ruby/sym path: /var/local/images/gold/generic.img
        !ruby/sym size: "5G"
```

####Show ENC data (puppet code) for a Virtual Machine staging-helloapp-001
```sh
env='staging' rake sbx:staging-helloapp-001:to_enc
---
  "role::http_app":
    port: "8000"
    dependencies:
      db.hello.hostname: staging-hellodb-001.earth.net.local
      db.hello.database: hello
      db.hello.username: JavaHttpRef
      db.hello.password_hiera_key: enc/staging/JavaHttpRef/mysql_password
    environment: staging
    vip_fqdn: staging-helloapp-vip.earth.net.local
    group: blue
    dependant_instances:
      - staging-helloproxy-001.earth.net.local
      - staging-helloproxy-002.earth.net.local
      - staging-lb-001.earth.net.local
      - staging-lb-002.earth.net.local
    application: JavaHttpRef
```

####Show all options available for the Virtual Machine staging-helloapp-001
```sh
$ env='staging' rake -T staging-helloapp-001
rake sbx:staging-helloapp-001:allocate            # allocate these machines to hosts (but don't actually launch them - this is a dry run)
rake sbx:staging-helloapp-001:allocate_vips       # allocate IPs for these virtual services
rake sbx:staging-helloapp-001:audit_hosts         # new hosts model auditing
rake sbx:staging-helloapp-001:clean               # clean away all traces of these machines
rake sbx:staging-helloapp-001:disable_notify      # disable notify for these machines
rake sbx:staging-helloapp-001:enable_notify       # enable notify for these machines
rake sbx:staging-helloapp-001:free_ip_allocation  # frees up ip and vip allocation of these machines
rake sbx:staging-helloapp-001:free_ips            # free IPs
rake sbx:staging-helloapp-001:free_vips           # free IPs for these virtual services
rake sbx:staging-helloapp-001:launch              # launch these machines
rake sbx:staging-helloapp-001:mping               # perform an MCollective ping against these machines
rake sbx:staging-helloapp-001:orc:resolve         # deploys the up2date version of the artifact according to the cmdb using orc
rake sbx:staging-helloapp-001:provision           # perform all steps required to create and configure the machine(s)
rake sbx:staging-helloapp-001:puppet:clean        # Remove signed certs from puppetmaster
rake sbx:staging-helloapp-001:puppet:poll_sign    # sign outstanding Puppet certificate signing requests for these machines
rake sbx:staging-helloapp-001:puppet:run          # run Puppet on these machines
rake sbx:staging-helloapp-001:puppet:sign         # sign outstanding Puppet certificate signing requests for these machines
rake sbx:staging-helloapp-001:puppet:wait         # wait for puppet to complete its run on these machines
rake sbx:staging-helloapp-001:reprovision         # perform a clean followed by a provision
rake sbx:staging-helloapp-001:resolve             # resolve the IP numbers of these machines
rake sbx:staging-helloapp-001:test                # carry out all appropriate tests on these machines
rake sbx:staging-helloapp-001:to_enc              # outputs the specs for these machines, in the format to feed to the provisioning tools
rake sbx:staging-helloapp-001:to_specs            # outputs the specs for these machines, in the format to feed to the provisioning tools
rake sbx:staging-helloapp-001:to_vip_spec         # outputs the specs for these machines, in the format to feed to the provisioning tools
```

### Stacks
####Show all stacks available with the name 'helloworld'
```sh
$ env='staging' rake -T helloworld
rake sbx:helloworld:allocate            # allocate these machines to hosts (but don't actually launch them - this is a dry run)
rake sbx:helloworld:allocate_vips       # allocate IPs for these virtual services
rake sbx:helloworld:audit_hosts         # new hosts model auditing
rake sbx:helloworld:clean               # clean away all traces of these machines
rake sbx:helloworld:disable_notify      # disable notify for these machines
rake sbx:helloworld:enable_notify       # enable notify for these machines
rake sbx:helloworld:free_ip_allocation  # frees up ip and vip allocation of these machines
rake sbx:helloworld:free_ips            # free IPs
rake sbx:helloworld:free_vips           # free IPs for these virtual services
rake sbx:helloworld:launch              # launch these machines
rake sbx:helloworld:mping               # perform an MCollective ping against these machines
rake sbx:helloworld:orc:resolve         # deploys the up2date version of the artifact according to the cmdb using orc
rake sbx:helloworld:provision           # perform all steps required to create and configure the machine(s)
rake sbx:helloworld:puppet:clean        # Remove signed certs from puppetmaster
rake sbx:helloworld:puppet:poll_sign    # sign outstanding Puppet certificate signing requests for these machines
rake sbx:helloworld:puppet:run          # run Puppet on these machines
rake sbx:helloworld:puppet:sign         # sign outstanding Puppet certificate signing requests for these machines
rake sbx:helloworld:puppet:wait         # wait for puppet to complete its run on these machines
rake sbx:helloworld:reprovision         # perform a clean followed by a provision
rake sbx:helloworld:resolve             # resolve the IP numbers of these machines
rake sbx:helloworld:test                # carry out all appropriate tests on these machines
rake sbx:helloworld:to_specs            # outputs the specs for these machines, in the format to feed to the provisioning tools
rake sbx:helloworld:to_vip_spec         # outputs the specs for these machines, in the format to feed to the provisioning tools
```





