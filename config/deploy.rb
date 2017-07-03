require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina_sidekiq/tasks'
require 'mina/puma'

set :application, 'cidademn'
set :domain, '138.197.125.16' #homologacao.ruaalecrim.com.br
set :deploy_to, "/var/www/cidademn"
set :repository, 'git@github.com:hantys/cidadeMN.git'

set :branch, 'master'

set :user, "deploy"
set :forward_agent, true
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log', 'tmp', 'public/uploads', 'public/assets']
set :rvm_path, '/usr/local/rvm/scripts/rvm'
set :sidekiq_pid, "#{deploy_to}/#{shared_path}/tmp/pids/sidekiq.pid"
set :keep_releases, 10
# set :pumactl_socket, '/home/deploy/pumactl.sock'
# set :puma_socket, '/home/deploy/puma.sock'

task :environment do
  invoke :'rvm:use[ruby-2.4.1@default]'
  # invoke :'rvm:use', 'ruby-2.3.3'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/uploads"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/public/assets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/assets"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]

  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile:force'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'puma:hard_restart'

    end
  end
end
