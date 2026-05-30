#!/usr/bin/env powershell

# Puppet Task Name: enable_agent_windows
#
# Re-enables the Puppet agent on Windows AIO installations.
$ErrorActionPreference = 'Stop'

$puppetBin = Join-Path $env:ProgramFiles 'Puppet Labs\Puppet\bin\puppet.bat'
if (-not (Test-Path $puppetBin)) {
  $puppetBin = 'puppet'
}

& $puppetBin agent --enable
exit $LASTEXITCODE
