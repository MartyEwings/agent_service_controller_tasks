
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

The tasks work with both **Puppet Enterprise** (run them from the PE console or
orchestrator) and **open-source Puppet / Puppet core** (run them with
[Bolt](https://www.puppet.com/docs/bolt/latest/bolt.html) via `bolt task run`).
The only requirement is a Puppet all-in-one (AIO) agent on the target.

### Use cases

Temporarily pausing the agent is useful whenever you need Puppet to stop
enforcing state for a window of time, for example:

* **Maintenance windows** — disable the agent across a set of nodes before
  patching, upgrades or hardware work, then re-enable it once the change is
  complete. Pass the change reference (e.g. a change ticket number) as the
  `reason` so it is recorded in the agent's lock file.
* **Incident response / troubleshooting** — stop Puppet reverting manual
  changes while you investigate an issue, then re-enable to resume enforcement.
* **Staged rollouts** — hold the agent on a subset of nodes while validating a
  change elsewhere.

Because the disable reason is stored on the node, anyone running `puppet agent`
manually sees why it was disabled, and `enable_agent` cleanly reverses it.

## Setup

### Beginning with agent_service_controller_tasks

Installing this module makes the tasks available in the Puppet Enterprise
console and orchestrator, and to Bolt (`bolt task show`, `bolt task run`).

## Usage

There is a single task for each action — `disable_agent` and `enable_agent`.
Each task ships both a shell and a PowerShell implementation, and Puppet/Bolt
automatically selects the correct one based on the target's platform (the
`shell` feature for \*nix/macOS, the `powershell` feature for Windows). You no
longer need to pick a platform-specific task by hand.

* `disable_agent` accepts a `reason` string describing why the service was disabled.
* `enable_agent` re-enables the service.

The tasks call the agent's all-in-one (AIO) `puppet` binary at its standard
location (`/opt/puppetlabs/bin/puppet` on \*nix/macOS,
`C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat` on Windows), falling back
to `puppet` on `PATH` for non-standard installs.

### Examples

Run from the PE console, or with Bolt. The same task works against a mix of
Linux, macOS and Windows targets:

```bash
# Disable the agent (any supported platform)
bolt task run agent_service_controller_tasks::disable_agent \
  reason='Maintenance window CHG0012345' --targets all_nodes

# Re-enable the agent (any supported platform)
bolt task run agent_service_controller_tasks::enable_agent --targets all_nodes
```

## Reference

This module ships the following tasks:

| Task            | Parameters        | Description                          |
| --------------- | ----------------- | ------------------------------------ |
| `disable_agent` | `reason` (String) | Disables the Puppet agent service    |
| `enable_agent`  | _none_            | Re-enables the Puppet agent service  |

Each task automatically selects the correct implementation per platform:

| Implementation (private) | Selected when target has feature |
| ------------------------ | -------------------------------- |
| `*_bash.sh`              | `shell` (\*nix / macOS)          |
| `*_windows.ps1`          | `powershell` (Windows)           |

## Limitations

Requires a Puppet all-in-one (AIO) agent install. Supports Puppet 7 and 8,
covering both Puppet Enterprise (2021.x through 2025.x) and the matching
open-source Puppet releases run via Bolt. See `metadata.json` for the full list
of supported operating systems. The bash tasks require a `bash` shell; the
Windows tasks require PowerShell.

## Development

This module is maintained with the [Puppet Development Kit (PDK)](https://www.puppet.com/docs/pdk/latest/pdk.html).

```bash
pdk validate   # lint and syntax checks
pdk test unit  # run unit tests
```

Unit tests live in `spec/tasks/` and validate the task metadata structure
(the cross-platform `implementations` wiring, parameters, and that the
implementation scripts exist). End-to-end execution against real targets is
out of scope for unit tests and requires acceptance testing.
