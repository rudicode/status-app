class StatusController < ApplicationController
  def sys command
    begin
      output = `#{command}`.chomp
      raise Errno::ENOENT if $?.exitstatus > 0 # on any error
    rescue Errno::ENOENT
      puts "sys() Error command: #{command}"
      Rails.logger.warn "WARN: #{controller_name}##{action_name}#sys() Error command: #{command}"
      output = "Error command: \"#{command}\""
    end
    output
  end

  def index
    start_time = Time.current
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
    @system[:hostname_ip] = sys('hostname -I')
    @system[:lsb_release_description] = sys('lsb_release -s -d').chomp
    @system[:lsb_release_release] = sys('lsb_release -s -r')
    @system[:lsb_release_codename] = sys('lsb_release -s -c')
    @system[:nginx_version] = sys('nginx -v 2>&1') # nginx outputs to stderr and we need to redirect it to stdout
    @system[:passenger_version] = sys('passenger -v')
    # need sudo because passenger-status use passenger_system_ruby, which is differnt from the ruby in the Gemfile
    # therfore the rails app does not run it.
    # NOTE this only happens when running from inside the rails app
    @system[:passenger_status] = sys('suso passenger-status')
    @system[:timedatectl] = sys('timedatectl')
    @system[:RVM_INFO] = sys('rvm info')
    @total_time = Time.current - start_time
  end
end
