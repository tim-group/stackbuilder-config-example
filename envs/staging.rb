# Staging Environment
env 'staging',
  {
    # Primary location where stacks will be located
    :primary_site=>'earth',
    # Secondary location where stacks will be located
    :secondary_site=>'moon',
    # Unique reference for load balancers to use in this environment (to avoid conflicts ensure this number is unique in every environment
    # FIXME: Ideally we would auto-generate this number
    :lb_virtual_router_id=>130,
} do
  instantiate_stack 'hello-app'
  instantiate_stack 'hello-db'
  instantiate_stack 'hello-proxy'
  instantiate_stack 'loadbalancer-service'
  instantiate_stack 'nat-service'
end

# vim: set ts=2 sw=2 et :
