#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

# Puppet Task Name: enable_agent
#
# Re-enables the Puppet agent on any platform with a Puppet all-in-one (AIO)
# agent installed. Runs under the agent's bundled Ruby and uses Puppet's own
# lockfile API, so a single implementation covers *nix, macOS and Windows.
require 'json'
require 'puppet'
require 'puppet/agent'

# Wraps Puppet::Agent::Disabler, the public API behind `puppet agent --enable`.
class EnableAgentTask
  include Puppet::Agent::Disabler

  def initialize
    Puppet.settings.preferred_run_mode = :agent
    Puppet.initialize_settings unless Puppet.settings.global_defaults_initialized?
  end

  def run(_params = {})
    return { 'status' => 'already enabled', 'disabled' => false } unless disabled?

    previous_reason = disable_message
    enable
    { 'status' => 'enabled', 'disabled' => false, 'previous_reason' => previous_reason }
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    puts JSON.generate(EnableAgentTask.new.run)
  rescue StandardError => e
    puts JSON.generate('_error' => {
                         'kind' => 'agent_service_controller_tasks/enable-error',
                         'msg' => e.message,
                         'details' => { 'class' => e.class.to_s },
                       })
    exit 1
  end
end
