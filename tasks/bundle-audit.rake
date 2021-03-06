begin
  require 'bundler/audit/cli'

  namespace :bake do
    desc 'Check Gemfile.lock for security issues'
    task :'bundle-audit' do
      RakeNBake::Baker.log_step 'Updating DB of security advisories'
      system('bundle exec bundle-audit update')

      RakeNBake::Baker.log_step 'Checking gems for known security warnings'
      exit 1 unless system('bundle exec bundle-audit check')
    end
  end

rescue LoadError

  tasks = %w[bundle-audit].map(&:to_sym)

  namespace :bake do
    tasks.each do |t|
      desc "This task is not available"
      task t do
        RakeNBake::Baker.log_missing_gem 'bundler-audit'
        abort
      end
    end
  end
end
