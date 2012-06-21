mysql_packages = case node['platform']
  when "centos", "redhat", "suse", "fedora"
    %w{mysql mysql-devel}
  when "ubuntu","debian"
    if(platform?("debian") && (node.platform_version.to_f < 6.0)) || (platform?("ubuntu") && (node.platform_version.to_f < 10.0))
      %w{mysql-client libmysqlclient15-dev}
    else
      %w{mysql-client libmysqlclient-dev}
    end
  else
    %w{mysql-client libmysqlclient-dev}
  end

mysql_packages.each do |mysql_pack|
  package mysql_pack do
    action :install
  end
end

