# frozen_string_literal: true

require 'spec_helper'
require 'json'

# Structural unit tests for the module's Bolt task metadata. These guard the
# cross-platform `implementations` wiring (shell vs powershell selection)
# without requiring live targets, which would need acceptance testing instead.
RSpec.describe 'task metadata' do
  def tasks_dir
    File.expand_path('../../tasks', __dir__)
  end

  def load_task(file)
    JSON.parse(File.read(File.join(tasks_dir, file)))
  end

  shared_examples 'a cross-platform task' do |task_file, expected_implementations|
    subject(:task) { load_task(task_file) }

    it 'uses puppet_task_version 1' do
      expect(task['puppet_task_version']).to eq(1)
    end

    it 'declares exactly the shell and powershell implementations' do
      features = task['implementations'].map { |impl| impl['requirements'] }.flatten
      expect(features).to contain_exactly('shell', 'powershell')
    end

    it 'references implementation scripts that exist on disk' do
      task['implementations'].each do |impl|
        expect(File.exist?(File.join(tasks_dir, impl['name']))).to be(true)
      end
    end

    it 'maps each platform feature to the expected script' do
      mapping = task['implementations'].each_with_object({}) do |impl, acc|
        acc[impl['requirements'].first] = impl['name']
      end
      expect(mapping).to eq(expected_implementations)
    end
  end

  describe 'disable_agent' do
    subject(:task) { load_task('disable_agent.json') }

    it_behaves_like 'a cross-platform task', 'disable_agent.json',
                    'shell' => 'disable_agent_bash.sh',
                    'powershell' => 'disable_agent_windows.ps1'

    it 'requires a String reason parameter' do
      expect(task['parameters']['reason']['type']).to eq('String')
    end
  end

  describe 'enable_agent' do
    subject(:task) { load_task('enable_agent.json') }

    it_behaves_like 'a cross-platform task', 'enable_agent.json',
                    'shell' => 'enable_agent_bash.sh',
                    'powershell' => 'enable_agent_windows.ps1'

    it 'takes no parameters' do
      expect(task['parameters']).to be_empty
    end
  end

  describe 'private implementation tasks' do
    [
      'disable_agent_bash.json',
      'disable_agent_windows.json',
      'enable_agent_bash.json',
      'enable_agent_windows.json',
    ].each do |file|
      it "#{file} is hidden from the task list (private)" do
        expect(load_task(file)['private']).to be(true)
      end
    end
  end
end
