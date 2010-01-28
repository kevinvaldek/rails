require "isolation/abstract_unit"

module ApplicationTests
  class ConfigurationTest < Test::Unit::TestCase
    include ActiveSupport::Testing::Isolation

    def new_app
      File.expand_path("#{app_path}/../new_app")
    end

    def copy_app
      FileUtils.cp_r(app_path, new_app)
    end

    def setup
      FileUtils.rm_rf(new_app) if File.directory?(new_app)
      build_app
      boot_rails
      FileUtils.rm_rf("#{app_path}/config/environments")
    end

    test "Rails::Application.instance is nil until app is initialized" do
      require 'rails'
      assert_nil Rails::Application.instance
      require "#{app_path}/config/environment"
      assert_equal AppTemplate::Application.instance, Rails::Application.instance
    end

    test "the application root is set correctly" do
      require "#{app_path}/config/environment"
      assert_equal Pathname.new(app_path), Rails.application.root
    end

    test "the application root can be seen from the application singleton" do
      require "#{app_path}/config/environment"
      assert_equal Pathname.new(app_path), AppTemplate::Application.root
    end

    test "the application root can be set" do
      copy_app
      add_to_config <<-RUBY
        config.root = '#{new_app}'
      RUBY

      use_frameworks []

      require "#{app_path}/config/environment"
      assert_equal Pathname.new(new_app), Rails.application.root
    end

    test "the application root is Dir.pwd if there is no config.ru" do
      File.delete("#{app_path}/config.ru")

      use_frameworks []

      Dir.chdir("#{app_path}") do
        require "#{app_path}/config/environment"
        assert_equal Pathname.new("#{app_path}"), Rails.application.root
      end
    end

    test "Rails.root should be a Pathname" do
      add_to_config <<-RUBY
        config.root = "#{app_path}"
      RUBY
      require "#{app_path}/config/environment"
      assert_instance_of Pathname, Rails.root
    end

    test "marking the application as threadsafe sets the correct config variables" do
      add_to_config <<-RUBY
        config.threadsafe!
      RUBY

      require "#{app_path}/config/application"
      assert AppTemplate::Application.config.action_controller.allow_concurrency
    end

    test "the application can be marked as threadsafe when there are no frameworks" do
      FileUtils.rm_rf("#{app_path}/config/environments")
      add_to_config <<-RUBY
        config.threadsafe!
      RUBY

      use_frameworks []

      assert_nothing_raised do
        require "#{app_path}/config/application"
      end
    end

    test "Frameworks are not preloaded by default" do
      require "#{app_path}/config/environment"

      assert ActionController.autoload?(:RecordIdentifier)
    end

    test "frameworks are preloaded with config.preload_frameworks is set" do
      add_to_config <<-RUBY
        config.preload_frameworks = true
      RUBY

      require "#{app_path}/config/environment"

      assert !ActionController.autoload?(:RecordIdentifier)
    end

    test "runtime error is raised if config.frameworks= is used" do
      add_to_config "config.frameworks = []"

      assert_raises RuntimeError do
        require "#{app_path}/config/environment"
      end
    end

    test "runtime error is raised if config.frameworks is used" do
      add_to_config "config.frameworks -= []"

      assert_raises RuntimeError do
        require "#{app_path}/config/environment"
      end
    end
    
    test "filter_parameters should be able to set via config.filter_parameters" do
      add_to_config <<-RUBY
        config.filter_parameters += [ :foo, 'bar', lambda { |key, value|
          value = value.reverse if key =~ /baz/
        }]
      RUBY

      assert_nothing_raised do
        require "#{app_path}/config/application"
      end
    end
  end
end
