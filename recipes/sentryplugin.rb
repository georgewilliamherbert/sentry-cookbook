node['sentry']['plugins'].each do |pkg|
  sentry_pippkg "#{pkg}" do
    pipcmd "#{node['pip']['cmd']}"
    action :install
    provider "sentry_pip"
  end
end
