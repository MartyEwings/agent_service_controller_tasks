#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

# Puppet Task Name: disable_agent
#
# Disables the Puppet agent on any platform with a Puppet all-in-one (AIO)
# agent installed. Runs under the agent's bundled Ruby and uses Puppet's own
# lockfile API, so a single implementation covers *nix, macOS and Windows.
require 'json'
require 'puppet'
require 'puppet/agent'

# Wraps Puppet::Agent::Disabler, the public API behind `puppet agent --disable`.
class DisableAgentTask
  include Puppet::Agent::Disabler

  def initialize
    Puppet.settings.preferred_run_mode = :agent
    Puppet.initialize_settings unless Puppet.settings.global_defaults_initialized?
  end

  def run(params)
    reason = params['reason']

    if disabled?
      # Puppet keeps the original lock (and its message) if already disabled.
      return { 'status' => 'already disabled', 'disabled' => true, 'reason' => disable_message }
    end

    disable(reason)
    { 'status' => 'disabled', 'disabled' => true, 'reason' => reason }
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    input = $stdin.read.to_s
    params = input.strip.empty? ? {} : JSON.parse(input)
    puts JSON.generate(DisableAgentTask.new.run(params))
  rescue StandardError => e
    puts JSON.generate('_error' => {
                         'kind' => 'agent_service_controller_tasks/disable-error',
                         'msg' => e.message,
                         'details' => { 'class' => e.class.to_s },
                       })
    exit 1
  end
end
