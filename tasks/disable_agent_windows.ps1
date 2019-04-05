#!/usr/bin/env powershell

[CmdletBinding()]
Param(
 [String]
  $reason
  )
# Puppet Task Name: disable_agent_windows
#
C:\"Program Files"\"Puppet Labs"\Puppet\bin\puppet agent --disable $reason
