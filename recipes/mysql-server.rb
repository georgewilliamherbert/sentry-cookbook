include_recipe "mysql::client"

# this is to avoid any interaction with debian based OS during mysql install
if platform?(%w{debian ubuntu})

  directory "/var/cache/local/preseeding" do
    owner "root"
    group node['mysql']['root_group']
    mode 0755
    recursive true
  end

  # we need to make sure debconf is installed to proceed with the next step
  package debconf do
    action :install
  end

  execute "preseed mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    owner "root"
    group node['mysql']['root_group']
    mode "0600"
    notifies :run, resources(:execute => "preseed mysql-server"), :immediately
  end

  template "#{node['mysql']['conf_dir']}/debian.cnf" do
    source "debian.cnf.erb"
    owner "root"
    group node['mysql']['root_group']
    mode "0600"
  end

end

package node['mysql']['package_name'] do
  action :install
end

#do this only for debian boxes
if(defined? node['mysql']['confd_dir']) do
  directory node['mysql']['confd_dir'] do
    owner "mysql"
    group "mysql"
    action :create
    recursive true
  end
end

service "mysql" do
  service_name node['mysql']['service_name']
  #only if the node uses upstart - UBUNTU >= 10.04
  if node['mysql']['use_upstart']
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
  end
  supports :status => true, :restart => true
  # why is the action NOTHING here ?
  action :start
end

# don't save the node data on chef-solo
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

# set the root password on platforms which don't support pre-seeding
unless platform?(%w{debian ubuntu})
  execute "assign-root-password" do
    command "\"#{node['mysql']['mysqladmin_bin']}\" -u root password \"#{node['mysql']['server_root_password']}\""
    action :run
    only_if "\"#{node['mysql']['mysql_bin']}\" -u root -e 'show databases;'"
  end
end

grants_path = node['mysql']['grants_path']
begin
  t = resources("template[#{grants_path}]")
rescue
  Chef::Log.info("Could not find previously defined grants.sql resource")
  t = template grants_path do
    source "grants.sql.erb"
    owner "root"
    group node['mysql']['root_group']
    mode "0600"
    action :create
  end
end

# set up the privileges on DB for sentry and create sentry DB
execute "mysql-install-privileges" do
  command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" < \"#{grants_path}\""
  action :nothing
  subscribes :run, resources("template[#{grants_path}]"), :immediately
end

