require 'base64'
require 'digest'
require 'net/ssh'

d=directory node['tmate']['keys_dir'] do
  recursive true
  action :nothing
end
d.run_action :create

include_recipe 'tmate-slave::gen_keys'

template "/root/tmate.conf" do
  source 'tmate-client.conf.erb'
end
