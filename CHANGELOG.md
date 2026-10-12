# Changelog

All notable changes to this project will be documented in this file.


## Release 3.0.0

**Features**

Updated to PDK 4.0.1 (pdk-default template 4.0.1, puppetcore gem source support)
Added support for Puppet 9; supported Puppet range is now `>= 8.0.0 < 10.0.0`
Replaced the separate shell and PowerShell implementations with a single native Ruby implementation per task, running on the Puppet agent's bundled Ruby on every platform
Tasks now use Puppet's `Puppet::Agent::Disabler` API directly instead of shelling out to the `puppet` binary
Tasks are idempotent and return structured JSON (`status`, `disabled`, `reason` / `previous_reason`)
CI tests against Puppet 8 (Ruby 3.2) and Puppet 9 (Ruby 4.0)

**Backwards-incompatible changes**

Dropped support for Puppet 7 (end of life). Use release 2.0.0 for Puppet 7 agents.
The private `disable_agent_bash`, `disable_agent_windows`, `enable_agent_bash` and `enable_agent_windows` implementation tasks have been removed. The public `disable_agent` and `enable_agent` task names are unchanged.
Bolt over WinRM may need the `.rb` interpreter pointed at the Puppet agent's Ruby (see README).

**Known Issues**

None


## Release 2.0.0

**Features**

Updated to PDK 3.4.0 (modern template, GitHub Actions-ready tooling)
Added support for Puppet 7 and 8 (Puppet Enterprise 2021.x – 2025.x)
Refreshed supported operating systems: RHEL/CentOS/Rocky/AlmaLinux/OracleLinux 8 & 9, Debian 11 & 12, Ubuntu 20.04/22.04/24.04, Windows 2019/2022/2025/10/11, and recent macOS releases
Tasks now invoke the AIO `puppet` binary at its canonical location, with a fallback to `PATH`
Consolidated the per-platform tasks into single cross-platform tasks (`disable_agent`, `enable_agent`) that select the shell or PowerShell implementation automatically via task `implementations`/feature requirements

**Bugfixes**

Windows tasks now call `puppet.bat` and propagate the exit code
Bash tasks now fail fast (`set -euo pipefail`)

**Backwards-incompatible changes**

The platform-specific task names have been removed. Replace any references to
`disable_agent_bash`/`disable_agent_windows` with `disable_agent`, and
`enable_agent_bash`/`enable_agent_windows` with `enable_agent`.

**Known Issues**

None


## Release 1.0.0


**Features**

Updated to PDK 1.10.0
Added PE 2019.0.X support 

**Bugfixes**

Fixed absolute file paths in windows tasks

**Known Issues**






## Release 0.1.1

**Features**

**Bugfixes**

Fixed an issue with the disable bash where parameters being passes caused it not to run

**Known Issues**
