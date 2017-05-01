require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'spree/testing_support/extension_rake'

RSpec::Core::RakeTask.new

task :default do
  if Dir["spec/dummy"].empty?
    Rake::Task[:test_app].invoke
    Dir.chdir("../../")
  end
  Rake::Task[:spec].invoke
end

module InjectDeviseIntoDummyApp
  def test_dummy_inject_extension_requirements
    super
    inside dummy_path do
      inject_require_for('spree_auth_devise')
    end
  end
end
Spree::DummyGenerator.prepend InjectDeviseIntoDummyApp

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_api_auth'
  Rake::Task['extension:test_app'].invoke
end
