action :install do
  pip_cmd = case new_resource.platform 
    when "centos", "redhat", "suse", "fedora"
      "/usr/bin/pip-python"
    when "ubuntu","debian"
      "/usr/bin/pip"
    else
      "/usr/bin/pip"
    end
  execute "install PyPI package" do
    not_if "#{pip_cmd} freeze |grep #{new_resource.name}"
    command "#{pip_cmd} install #{new_resource.name}"
  end
end

action :uninstall do
  execute "uninstall PyPI package" do
    pip_cmd = case new_resource.platform
    when "centos", "redhat", "suse", "fedora"
      "/usr/bin/pip-python"
    when "ubuntu","debian"
      "/usr/bin/pip"
    else
      "/usr/bin/pip"
    end
    only_if "#{pip_cmd} freeze |grep #{new_resource.name}"
    command "#{pip_cmd} uninstall #{new_resource.name}"
  end
end

action :upgrade do
  execute "upgrade PyPI package" do
    pip_cmd = case new_resource.platform
    when "centos", "redhat", "suse", "fedora"
      "/usr/bin/pip-python"
    when "ubuntu","debian"
      "/usr/bin/pip"
    else
      "/usr/bin/pip"
    end
    not_if "#{pip_cmd} freeze |grep #{new_resource.name}"
    command "#{pip_cmd} install --upgrade #{new_resource.name}"
  end
end

