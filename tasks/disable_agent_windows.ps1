#!/usr/bin/env powershell

[CmdletBinding()]
Param(
  [String]
  $reason
)
# Puppet Task Name: disable_agent_windows
#
# Disables the Puppet agent on Windows AIO installations.
$ErrorActionPreference = 'Stop'

$puppetBin = Join-Path $env:ProgramFiles 'Puppet Labs\Puppet\bin\puppet.bat'
if (-not (Test-Path $puppetBin)) {
  $puppetBin = 'puppet'
}

& $puppetBin agent --disable $reason
exit $LASTEXITCODE
