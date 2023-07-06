class StatusController < ApplicationController
  def sys command
    begin
      output = `#{command}`
    rescue Errno::ENOENT
      puts "sys() Command not found: #{command}"
      Rails.logger.warn "WARN: #{controller_name}##{action_name}#sys() Command not found: #{command}"
      output = "Error: command not found: \"#{command}\""
    end
    output
  end

  def index
    @system = {}
    @system[:pwd] = sys('pwd')
    @system[:processors_available] = sys('nproc')
    memory_free = sys('free -m').split(" ")
    @system[:memory_total] = memory_free[7].to_i
    @system[:memory_available] = memory_free[12].to_i
    ip_brief = sys('ip --brief address show').split("\n").each do |line|
      adapter = line.split(" ")[0]
      ip = line.split(" ")[2].match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
      @system["addapter__#{adapter}"] = ip
    end
    @system[:hostname] = sys('hostname')
    @system[:lsb_release_description] = sys('lsb_release -s -d').chomp
    @system[:lsb_release_release] = sys('lsb_release -s -r')
    @system[:lsb_release_codename] = sys('lsb_release -s -c')
    @system[:nginx_version] = sys('nginx -v')
    @system[:passenger_version] = sys('passenger -v')
    @system[:timedatectl] = sys('timedatectl')
    @system[:RVM_INFO] = sys('rvm info')
  end
end
