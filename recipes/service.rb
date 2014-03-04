directory node[:tmate][:log_path] do
  recursive true
end

template '/etc/init/tmate.conf' do
  source 'tmate.conf.erb'
  owner 'root'
  mode '0644'
  variables :app_path => node[:tmate][:app_path],
            :log_path => node[:tmate][:log_path],
            :keys_dir => node[:tmate][:keys_dir],
            :listen_port => node[:tmate][:listen_port],
            :hostname => "#{node[:hostname]}.#{node[:tmate][:domain]}"
end

service "tmate" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :restart]
end
