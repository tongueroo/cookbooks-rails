node[:packages].each do |pkg|
  package pkg[:name] do
    version pkg[:version] if pkg[:version] && !pkg[:version].empty?
    action :install
  end
end