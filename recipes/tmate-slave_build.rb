git node['tmate']['app_path'] do
  repository "https://github.com/nviennot/tmate-slave.git"
  action :sync
  user "root"
  group "root"
  notifies :run, "bash[compile tmate]", :immediately
end

bash "compile tmate" do
  action :nothing
  user "root"
  cwd node['tmate']['app_path']
  code <<-EOH
    STATUS=0
    ./autogen.sh || STATUS=1
    ./configure || STATUS=1
    make || STATUS=1
    exit $STATUS
  EOH
end
