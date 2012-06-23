#
# Cookbook Name:: sentry
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#

#if apache isn't installed then /var/www doesn't exist!
if !File.directory?("/var/www")
  directory "/var/www" do
    owner "root"
    group "root"
    mode 0755
  end
end

directory node['sentry']['dir'] do
    owner node['www']['user']
    group node['www']['user']
    mode 0775
end

sentry_pippkg "sentry" do
  pipcmd "#{node['pip']['cmd']}"
  action :install
  provider "sentry_pip"
end

template "/etc/sentry.conf.py" do
  source "sentry.conf.py.erb"
  owner "root"
  group "root"
  mode "0644"
end

# initialize sentry
#execute "sentry init" do
#  command "sentry init --config=/etc/sentry.conf.py"
#  action :run
#end

#create an initial DB
execute "create init DB" do
  command "sentry --config=/etc/sentry.conf.py upgrade --noinput"
  action :run
end

# place the authentication template
template "/etc/sentry.su.json" do
  source "sentryauth.json.erb"
  owner "root"
  group "root"
  mode  "0600"
  action :create
end

#create superuser by running something like
execute "create superuser" do
  command "sentry --config=/etc/sentry.conf.py loaddata /etc/sentry.su.json"
  action :run
end

# install supervisor package
package "supervisor" do
  action :install
end

template node['supervisor']['config'] do
  if (["centos", "redhat", "fedora", "suse"].include? node["platform"])
    source "supervisor.conf.redhat.erb"
  else
    source "supervisor.conf.debian.erb"
  end
  owner "root"
  group "root"
  mode  "0644"
  action :create
end

service "supervisor" do
  service_name node['supervisor']['service']
  action [:enable, :start] 
end
