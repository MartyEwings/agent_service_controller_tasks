
# agent_service_controller_tasks

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with agent_service_controller_tasks](#setup)
    * [Beginning with agent_service_controller_tasks](#beginning-with-agent_service_controller_tasks)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module provides Puppet tasks for controlling the Puppet agent service on Windows, Linux and macOS.

The tasks allow you to disable the agent (recording a comment explaining why) and to re-enable it again at a later date.

## Setup

### Beginning with agent_service_controller_tasks

Installing this module populates the tasks available in the Puppet Enterprise console (or runnable via `bolt task run`).

## Usage

For Windows nodes select the `windows` version of the tasks; for Linux and macOS select the `bash` version.

* `disable` accepts a `reason` string describing why the service was disabled.
* `enable` re-enables the service.

The tasks call the agent's all-in-one (AIO) `puppet` binary at its standard
location (`/opt/puppetlabs/bin/puppet` on \*nix/macOS,
`C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat` on Windows), falling back
to `puppet` on `PATH` for non-standard installs.

### Examples

Run from the PE console, or with Bolt:

```bash
# Disable the agent on Linux/macOS targets
bolt task run agent_service_controller_tasks::disable_agent_bash \
  reason='Maintenance window CHG0012345' --targets linux_nodes

# Re-enable the agent on Linux/macOS targets
bolt task run agent_service_controller_tasks::enable_agent_bash --targets linux_nodes

# Disable the agent on Windows targets
bolt task run agent_service_controller_tasks::disable_agent_windows \
  reason='Maintenance window CHG0012345' --targets windows_nodes

# Re-enable the agent on Windows targets
bolt task run agent_service_controller_tasks::enable_agent_windows --targets windows_nodes
```

## Reference

This module ships the following tasks:

| Task                                | Platform         | Parameters | Description                                  |
| ----------------------------------- | ---------------- | ---------- | -------------------------------------------- |
| `disable_agent_bash`                | \*nix / macOS    | `reason` (String) | Disables the Puppet agent service        |
| `enable_agent_bash`                 | \*nix / macOS    | _none_     | Re-enables the Puppet agent service          |
| `disable_agent_windows`             | Windows          | `reason` (String) | Disables the Puppet agent service        |
| `enable_agent_windows`              | Windows          | _none_     | Re-enables the Puppet agent service          |

## Limitations

Requires a Puppet all-in-one (AIO) agent install. Supports Puppet 7 and 8 (Puppet
Enterprise 2021.x through 2025.x). See `metadata.json` for the full list of
supported operating systems. The bash tasks require a `bash` shell; the Windows
tasks require PowerShell.

## Development

This module is maintained with the [Puppet Development Kit (PDK)](https://www.puppet.com/docs/pdk/latest/pdk.html).

```bash
pdk validate   # lint and syntax checks
pdk test unit  # run unit tests
```
