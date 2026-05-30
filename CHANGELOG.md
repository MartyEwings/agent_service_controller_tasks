# Changelog

All notable changes to this project will be documented in this file.


## Release 2.0.0

**Features**

Updated to PDK 3.4.0 (modern template, GitHub Actions-ready tooling)
Added support for Puppet 7 and 8 (Puppet Enterprise 2021.x – 2025.x)
Refreshed supported operating systems: RHEL/CentOS/Rocky/AlmaLinux/OracleLinux 8 & 9, Debian 11 & 12, Ubuntu 20.04/22.04/24.04, Windows 2019/2022/2025/10/11, and recent macOS releases
Tasks now invoke the AIO `puppet` binary at its canonical location, with a fallback to `PATH`

**Bugfixes**

Windows tasks now call `puppet.bat` and propagate the exit code
Bash tasks now fail fast (`set -euo pipefail`)

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
