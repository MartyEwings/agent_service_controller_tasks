# frozen_string_literal: true

require 'spec_helper'
require 'json'

# Structural unit tests for the module's Bolt task metadata. Each task is a
# single cross-platform Ruby implementation, so guard against platform-specific
# implementations creeping back in.
RSpec.describe 'task metadata' do
  def tasks_dir
    File.expand_path('../../tasks', __dir__)
  end

  def load_task(file)
    JSON.parse(File.read(File.join(tasks_dir, file)))
  end

  shared_examples 'a cross-platform ruby task' do |task_name|
    subject(:task) { load_task("#{task_name}.json") }

    it 'uses puppet_task_version 1' do
      expect(task['puppet_task_version']).to eq(1)
    end

    it 'reads parameters as JSON on stdin' do
      expect(task['input_method']).to eq('stdin')
    end

    it 'has no per-platform implementations' do
      expect(task).not_to have_key('implementations')
    end

    it 'ships a single executable Ruby implementation', :aggregate_failures do
      impls = Dir[File.join(tasks_dir, "#{task_name}.*")].map { |f| File.basename(f) } - ["#{task_name}.json"]
      expect(impls).to eq(["#{task_name}.rb"])
      expect(File.executable?(File.join(tasks_dir, "#{task_name}.rb"))).to be(true)
    end

    it "uses the Puppet agent's bundled Ruby" do
      shebang = File.open(File.join(tasks_dir, "#{task_name}.rb"), &:readline).chomp
      expect(shebang).to eq('#!/opt/puppetlabs/puppet/bin/ruby')
    end
  end

  describe 'disable_agent' do
    subject(:task) { load_task('disable_agent.json') }

    it_behaves_like 'a cross-platform ruby task', 'disable_agent'

    it 'requires a String reason parameter' do
      expect(task['parameters']['reason']['type']).to eq('String')
    end
  end

  describe 'enable_agent' do
    subject(:task) { load_task('enable_agent.json') }

    it_behaves_like 'a cross-platform ruby task', 'enable_agent'

    it 'takes no parameters' do
      expect(task['parameters']).to be_empty
    end
  end
end
