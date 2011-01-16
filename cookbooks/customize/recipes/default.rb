dir = "/root"

templates = {
  "bashrc.erb" => "#{dir}/.bashrc"
}
templates.each do |src, dest|
  template dest do 
    mode 0644 
    source src 
    backup 0
  end 
end

files = {
  "bash_profile"      => "#{dir}/.bash_profile",
  "git-aliases.sh"    => "#{dir}/.git-aliases.sh",
  "git-completion.sh" => "#{dir}/.git-completion.sh",
  "gitconfig"         => "#{dir}/.gitconfig",
  "gitignore"         => "#{dir}/.gitignore",
  "irbrc"             => "#{dir}/.irbrc",
  "vimrc"             => "#{dir}/.vimrc"
}
files.each do |src, dest|
  cookbook_file dest do 
    mode 0644 
    source src
    backup 0
  end 
end
