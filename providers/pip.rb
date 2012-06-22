puts "================================================"
puts node.inspect

pip_cmd = case node['platform']
  when "centos", "redhat", "suse", "fedora"
    "/usr/bin/pip-python"
  when "ubuntu","debian"
    "/usr/bin/pip"
  else
    "/usr/bin/pip"
  end

action :install do
  execute "install PyPI package" do
    not_if "#{pip_cmd} freeze |grep #{new_resource.name}"
    command "#{pip_cmd} install #{new_resource.name}"
  end
end

action :uninstall do
  execute "uninstall PyPI package" do
    only_if "#{pip_cmd} freeze |grep #{new_resource.name}"
    command "#{pip_cmd} uninstall #{new_resource.name}"
  end
end

action :upgrade do
  execute "upgrade PyPI package" do
    not_if "#{pip_cmd} freeze |grep #{new_resource.name}"
    command "#{pip_cmd} install --upgrade #{new_resource.name}"
  end
end
