node['sentry']['plugins'].each do |pkg|
  sentry_pippkg "#{pkg}" do
    pipcmd "#{node['pip']['cmd']}"
    action :install
    provider "sentry_pip"
  end
end

# not sure if this is needed after the plugins have been installed
# but surely doesn't hurt to bounce the supervisor :)
service "supervisor" do
  service_name node['supervisor']['service']
  action :restart
end
