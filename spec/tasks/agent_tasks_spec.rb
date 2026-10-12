# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'
require_relative '../../tasks/disable_agent'
require_relative '../../tasks/enable_agent'

# Exercises the task logic against a temporary agent_disabled_lockfile, the
# same file `puppet agent --disable/--enable` manages on a real node.
RSpec.describe 'agent service controller tasks' do
  # rspec-puppet stubs Puppet.features.root? to true and leaves global defaults
  # uninitialised, so letting the tasks initialise settings for real would load
  # the host's puppet.conf and try to create root-owned dirs (/var/log/puppetlabs).
  before(:each) do
    allow(Puppet.settings).to receive(:preferred_run_mode=)
    allow(Puppet).to receive(:initialize_settings)
  end

  around(:each) do |example|
    Dir.mktmpdir do |dir|
      Puppet[:agent_disabled_lockfile] = File.join(dir, 'agent_disabled.lock')
      example.run
    end
  end

  let(:lockfile) { Puppet[:agent_disabled_lockfile] }

  describe DisableAgentTask do
    it 'disables the agent and records the reason', :aggregate_failures do
      result = described_class.new.run('reason' => 'CHG0012345')

      expect(result).to eq('status' => 'disabled', 'disabled' => true, 'reason' => 'CHG0012345')
      expect(JSON.parse(File.read(lockfile))).to eq('disabled_message' => 'CHG0012345')
    end

    it 'keeps the original reason when already disabled' do
      described_class.new.run('reason' => 'first')
      result = described_class.new.run('reason' => 'second')

      expect(result).to eq('status' => 'already disabled', 'disabled' => true, 'reason' => 'first')
    end
  end

  describe EnableAgentTask do
    it 'removes the lock and reports the previous reason', :aggregate_failures do
      DisableAgentTask.new.run('reason' => 'maintenance')
      result = described_class.new.run

      expect(result).to eq('status' => 'enabled', 'disabled' => false, 'previous_reason' => 'maintenance')
      expect(File.exist?(lockfile)).to be(false)
    end

    it 'is a no-op when the agent is already enabled' do
      expect(described_class.new.run).to eq('status' => 'already enabled', 'disabled' => false)
    end
  end
end
