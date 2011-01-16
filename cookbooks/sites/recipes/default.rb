#
# Cookbook Name:: sites
# Recipe:: default
#

# package "apache2" do
#   name "apache2"
#   version "2.2.11"
#   # version node[:apache][:version]
# end

execute "apache2-restart" do 
  command "/etc/init.d/apache2 restart"
  action :nothing 
end

# 37signals does it this way...
service "apache2" do
  name "apache2"
  supports :restart => true, :reload => true
  action :enable
end

Dir[File.expand_path('../../templates/default/sites/*.erb', __FILE__)].each do |path|
  domain = File.basename(path).gsub('.erb','')
  dest = "/etc/apache2/sites-available/#{domain}"
  template dest do
    source "sites/#{domain}.erb"
    mode 0644
    variables :env => node[:environment][:name]
    # notifies :run, resources(:execute => "apache2-restart")
    notifies :restart, resources(:service => "apache2")
    backup 0
  end
  execute("enable-site-#{domain}") do
    command "a2ensite #{domain}"
    not_if { File.exist?("/etc/apache2/sites-enabled/#{domain}") }
  end
end

Dir[File.expand_path('../../templates/default/deploy_shared/*.erb', __FILE__)].each do |path|
  file = File.basename(path).gsub('.erb','')
  app = file.match(/(.*)\.database.yml/)[1]
  dest = "/data/#{app}/shared/config/database.yml"
  
  directory File.dirname(dest) do
    mode 0755
    recursive true
  end
  template dest do
    source "deploy_shared/#{file}.erb"
    mode 0644
    variables :password => node[:mysql][:server_root_password]
    backup 0
  end
end

service "apache2" do
  action :start
end
