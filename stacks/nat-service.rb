stack 'nat-service' do
  nat_service
    # For each virtual machine in the stack
    each_machine do |machine|
      # Specify that this machine should use the precise gold image
      machine.template(:precise)
    end
end

# vim: set ts=2 sw=2 et :
