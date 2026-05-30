#!/bin/bash

# Puppet Task Name: enable_agent_bash
#
# Re-enables the Puppet agent on *nix / macOS AIO installations.
set -euo pipefail

# Canonical location of the puppet binary for all-in-one (AIO) agents.
# Fall back to whatever is on PATH for non-standard installs.
puppet_bin='/opt/puppetlabs/bin/puppet'
if [ ! -x "${puppet_bin}" ]; then
  puppet_bin="$(command -v puppet)"
fi

"${puppet_bin}" agent --enable
