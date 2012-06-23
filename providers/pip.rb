action :install do
  execute "install PyPI package" do
#    not_if "#{new_resource.pipcmd} freeze |grep #{new_resource.name}"
    command "#{new_resource.pipcmd} install #{new_resource.name}"
  end
end

action :uninstall do
  execute "uninstall PyPI package" do
#    only_if "#{new_resource.pipcmd} freeze |grep #{new_resource.name}"
    command "#{new_resource.pipcmd} uninstall #{new_resource.name}"
  end
end

action :upgrade do
  execute "upgrade PyPI package" do
#    not_if "#{new_resource.pipcmd} freeze |grep #{new_resource.name}"
    command "#{new_resource.pipcmd} install --upgrade #{new_resource.name}"
  end
end

