#
# Cookbook Name:: sentry
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#

# this will install python packages required to setup sentry
python_packages = case node['platform']
when "centos", "redhat", "suse", "fedora"
  %w{python python-devel python-pip python-setuptools}
when "ubuntu","debian"
  %w{python python-dev python-pip python-setuptools}
else
  %w{python python-devel python-pip python-setuptools}
end

python_packages.each do |pkg|
  package pkg do
    action :install
  end
end

# OS libraries on which the pythong ones depend
lib_packages = case node['platform']
when "centos", "redhat", "suse", "fedora"
  %w{ libevent libevent-devel zlib zlib-devel openssl openssl-devel}
when "ubuntu","debian"
  %w{ libevent libevent-dev zlib1g zlib1g-devel libssl-dev}
end

lib_packages.each do |lib_pack|
  package lib_pack do
    action :install
  end
end

# install required python packages
# using our own provider
(%w{ lxml pyOpenSSL MySQL-python virtualenv gevent}).each do |pkg|
  sentry_pippkg "#{pkg}" do
    pipcmd "#{node['pip']['cmd']}"
    action :install
    provider "sentry_pip"
  end
end

