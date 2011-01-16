#
# Cookbook Name:: rubygems
# Recipe:: default
#

unless `gem -v`.strip >= "1.3.7"
  bash "update rubygems to >= 1.3.7" do
    code <<-EOH
      gem install rubygems-update -v 1.3.7
      update_rubygems
    EOH
  end
end

node[:gems].each do |pkg|
  next if has_gem?(pkg[:name], pkg[:version].empty? ? nil : pkg[:version])
  gem_package pkg[:name] do
    if pkg[:version] && !pkg[:version].empty?
      version pkg[:version]
    end
    if pkg[:source] && !pkg[:source].empty?
      source pkg[:source]
    end
    action :install
  end
end

gem_sources = %w(
  http://rubygems.org
)
gem_sources.each do |src|
  bash "add #{src} gem source" do
    code <<-EOH
      gem sources -a #{src}
    EOH
    not_if "gem sources | grep #{src}"
  end
end

