#!/bin/bash

# Puppet Task Name: disable_agent_bash
#
# Disables the Puppet agent on *nix / macOS AIO installations.
set -euo pipefail

# Canonical location of the puppet binary for all-in-one (AIO) agents.
# Fall back to whatever is on PATH for non-standard installs.
puppet_bin='/opt/puppetlabs/bin/puppet'
if [ ! -x "${puppet_bin}" ]; then
  puppet_bin="$(command -v puppet)"
fi

# PT_reason is supplied by Bolt as an environment variable at runtime.
# shellcheck disable=SC2154
"${puppet_bin}" agent --disable "${PT_reason}"
