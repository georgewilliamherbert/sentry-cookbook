#
# Cookbook Name:: sentry
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#

include_recipe "sentry::mysql-server"
include_recipe "sentry::python-stuff"
include_recipe "sentry::sentry"
