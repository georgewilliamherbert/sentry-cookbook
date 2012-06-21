# set the passwords
node.set_unless['mysql']['server_debian_password'] = "password1"
node.set_unless['mysql']['server_root_password']   = "password2"
default['mysql']['use_upstart'] = platform?("ubuntu") && node.platform_version.to_f >= 10.04
default['mysql']['allow_remote_root']         = false

#sentry stuff
default['mysql']['sentry_user']               = 'sentry_user'
default['mysql']['sentry_passw']              = 'password3'
default['mysql']['sentry_db']                 = 'sentry'

case node["platform"]
when "centos", "redhat", "fedora", "suse"
  default['mysql']['package_name']            = "mysql-server"
  default['mysql']['service_name']            = "mysqld"
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"

  set['mysql']['conf_dir']                    = '/etc'
  set['mysql']['socket']                      = "/var/lib/mysql/mysql.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['grants_path']                 = "/etc/mysql_grants.sql"
else
  default['mysql']['package_name']            = "mysql-server"
  default['mysql']['service_name']            = "mysql"
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"

  set['mysql']['conf_dir']                    = '/etc/mysql'
  set['mysql']['confd_dir']                   = '/etc/mysql/conf.d'
  set['mysql']['socket']                      = "/var/run/mysqld/mysqld.sock"
  set['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  set['mysql']['grants_path']                 = "/etc/mysql/grants.sql"
end


