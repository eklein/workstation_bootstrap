include_recipe "pivotal_workstation::homebrew"

unless brew_installed? "memcached"
  brew_install "memcached"

  directory "/Users/#{node["current_user"]}/Library/LaunchAgents" do
    owner node["current_user"]
    action :create
  end

  execute "copy memcached plist to ~/Library/LaunchAgents" do
    command "cp `brew --prefix memcached`/homebrew.mxcl.memcached.plist #{WS_HOME}/Library/LaunchAgents/"
    user node["current_user"]
  end

  execute "load the memcached plist into the mac daemon startup thing" do
    command "launchctl load -w #{WS_HOME}/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
    user node["current_user"]
  end
end
