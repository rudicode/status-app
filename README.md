# Status App

Displays information on running system

- Ruby version
- Rails version
- Rails environment

- Memory
- CPU
- Network adapters
- Hostname
- nginx version
- passenger version
- timedatectl info
- rvm info

- All environment variables

### Use cases
- Used as a test deploy to new servers for checking the build of server images.
- Used as a test deploy within a cluster of containers, to verify automated cluster generation.

### TODO

- rescue from Bundler::RubyVersionMismatch error.
  get full path to script name (which script_name) and then use "bundle exec ruby script_name"
  NOTE this may not be an optimal solution since the script could be written for a specfic
  ruby version.
  NOTE: this comes up with passenger-status, which is a ruby script that should be run with
  passenger_system_ruby (v3.0.2 as of now) There is no guarantee that the script will work
  with any other version, although anything higher than 3.x should be ok.

