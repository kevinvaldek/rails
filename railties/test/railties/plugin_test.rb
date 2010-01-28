require "isolation/abstract_unit"
require "railties/shared_tests"

module RailtiesTest
  class PluginTest < Test::Unit::TestCase
    include ActiveSupport::Testing::Isolation
    include SharedTests

    def setup
      build_app

      @plugin = plugin "bukkits", "::LEVEL = config.log_level" do |plugin|
        plugin.write "lib/bukkits.rb", "class Bukkits; end"
        plugin.write "lib/another.rb", "class Another; end"
      end
    end

    test "plugin can load the file with the same name in lib" do
      boot_rails
      require "bukkits"
      assert_equal "Bukkits", Bukkits.name
    end

    test "it loads the plugin's init.rb file" do
      boot_rails
      assert_equal "loaded", BUKKITS
    end

    test "the init.rb file has access to the config object" do
      boot_rails
      assert_equal :debug, LEVEL
    end

    test "plugin_init_is_ran_before_application_ones" do
      plugin "foo", "$foo = true" do |plugin|
        plugin.write "lib/foo.rb", "module Foo; end"
      end

      app_file 'config/initializers/foo.rb', <<-RUBY
        raise "no $foo" unless $foo
        raise "no Foo" unless Foo
      RUBY

      boot_rails
      assert $foo
    end

    test "plugin should work without init.rb" do
      @plugin.delete("init.rb")

      boot_rails

      require "bukkits"
      assert_nothing_raised { Bukkits }
    end

    test "plugin cannot declare an engine for it" do
      @plugin.write "lib/bukkits.rb", <<-RUBY
        class Bukkits
          class Engine < Rails::Engine
          end
        end
      RUBY

      @plugin.write "init.rb", <<-RUBY
        require "bukkits"
      RUBY

      rescued = false

      begin
        boot_rails
      rescue Exception => e
        rescued = true
        assert_equal '"bukkits" is a Railtie/Engine and cannot be installed as plugin', e.message
      end

      assert rescued, "Expected boot rails to fail"
    end

    test "deprecated tasks are also loaded" do
      $executed = false
      @plugin.write "tasks/foo.rake", <<-RUBY
        task :foo do
          $executed = true
        end
      RUBY

      boot_rails
      require 'rake'
      require 'rake/rdoctask'
      require 'rake/testtask'
      Rails.application.load_tasks
      Rake::Task[:foo].invoke
      assert $executed
    end

  end
end
