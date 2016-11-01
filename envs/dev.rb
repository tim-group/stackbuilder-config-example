# Local Development Environment
env 'dev',
  {
    # Primary location where stacks will be located
    :primary_site=>'local',
    # Unique reference for load balancers to use in this environment (to avoid conflicts ensure this number is unique in every environment
    # FIXME: Ideally we would auto-generate this number
    :lb_virtual_router_id=>1,
} do
  instantiate_stack 'hello-app'
  instantiate_stack 'hello-db'
  instantiate_stack 'hello-proxy'
  instantiate_stack 'loadbalancer-service'
  instantiate_stack 'nat-service'
end

# vim: set ts=2 sw=2 et :
