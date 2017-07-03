if ENV.fetch("RAILS_ENV") == 'development'

  threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
  threads threads_count, threads_count

  port        ENV.fetch("PORT") { 3000 }

  environment ENV.fetch("RAILS_ENV") { "development" }

  plugin :tmp_restart

else
  threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
  threads threads_count, threads_count

  # Specifies the `port` that Puma will listen on to receive requests, default is 3000.
  #
  port        ENV.fetch("PORT") { 3000 }

  pidfile "/var/www/cidademn/shared/tmp/pids/puma.pid"
  stdout_redirect "/var/www/cidademn/shared/log/stdout", "/var/www/cidademn/shared/log/stderr"

  bind "unix:///var/www/cidademn/shared/tmp/sockets/puma.sock"

  daemonize true
  threads 0, 4

  preload_app!

  on_worker_boot do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection
    end
  end

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect!
  end

end
