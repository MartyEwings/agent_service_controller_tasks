# frozen_string_literal: true

require 'bundler'
require 'puppet_litmus/rake_tasks' if Gem.loaded_specs.key? 'puppet_litmus'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-strings/tasks' if Gem.loaded_specs.key? 'puppet-strings'

PuppetLint.configuration.send('disable_relative')
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.ignore_paths = [".vendor/**/*.pp", ".bundle/**/*.pp", "pkg/**/*.pp", "spec/**/*.pp", "tests/**/*.pp", "types/**/*.pp", "vendor/**/*.pp"]

desc 'Syntax check shellscripts'
task :shellcheck do
  Dir['{tasks,files}/**/*.sh'].each do |shell_file|
    sh "shellcheck #{shell_file}" do |ok, res|
        exit res.exitstatus unless ok
    end
  end
end

desc 'Check task names'
 task :tasknames do
   errors = Dir['tasks/**/*'].map do |task|
       "Task name \"#{task}\" is invalid" if File.basename(task) !~ /\A[a-z][a-z0-9_]*\.[a-z0-9_]+\Z/
   end.compact
   abort errors.join("\n") if errors.any?
end

