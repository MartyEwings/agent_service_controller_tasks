#!/usr/bin/env powershell

[CmdletBinding()]
Param(
 [String]
  $reason
  )
# Puppet Task Name: disable_agent_windows
#
puppet agent --disable $reason
