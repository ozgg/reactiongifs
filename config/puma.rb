require 'pathname'

environment 'production'

app_root = Pathname.new('../../../../current').expand_path(__FILE__)
tmp_dir  = app_root.join('tmp')
pids_dir = tmp_dir.join('pids')
logs_dir = app_root.join('log')

pidfile pids_dir.join('puma.pid').to_s
state_path tmp_dir.join('puma.state').to_s

bind "unix://#{tmp_dir}/puma.sock"

stdout_redirect logs_dir.join('stdout.log').to_s, logs_dir.join('stderr.log').to_s, true
