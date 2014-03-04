include_recipe "tmate-slave"
include_recipe "tmate-slave::ssh_port"
include_recipe "tmate-slave::gen_config"
include_recipe "tmate-slave::service"
ruby_block "show tmate config" do
  block do
    puts "Add the following to ~/.tmate.conf on boxes that should use this server:"
    puts open('/root/tmate.conf').read
  end
end
