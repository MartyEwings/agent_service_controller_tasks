
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
Each task is a single native Ruby implementation that runs on the Ruby bundled
with the Puppet agent, so the same task runs on \*nix, macOS and Windows with no
platform-specific variants.

* `disable_agent` accepts a `reason` string describing why the service was disabled.
* `enable_agent` re-enables the service.

Rather than shelling out to `puppet agent --disable/--enable`, the tasks call
Puppet's public lockfile API (`Puppet::Agent::Disabler`) directly, which manages
the same `agent_disabled_lockfile` that the `puppet agent` command uses. Both
tasks are idempotent and return structured JSON, for example:

```json
{"status": "disabled", "disabled": true, "reason": "Maintenance window CHG0012345"}
{"status": "already disabled", "disabled": true, "reason": "Earlier reason"}
{"status": "enabled", "disabled": false, "previous_reason": "Maintenance window CHG0012345"}
{"status": "already enabled", "disabled": false}
```

If the agent is already disabled, `disable_agent` leaves the existing lock and
reason in place (matching `puppet agent --disable` behaviour) and reports it.

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

Both tasks read their parameters as JSON on stdin and are implemented in
`tasks/<name>.rb` with the shebang `#!/opt/puppetlabs/puppet/bin/ruby`.

## Limitations

Requires a Puppet all-in-one (AIO) agent on the target, since the tasks run on
the agent's bundled Ruby and load Puppet's own libraries. Supports Puppet 8
(Ruby 3.2) and Puppet 9, covering Puppet Enterprise 2025.x and later and the
matching Puppet core releases run via Bolt. Puppet 7 is no longer supported;
use release 2.0.0 of this module for Puppet 7 agents. See `metadata.json` for
the full list of supported operating systems.

When running the tasks with Bolt over WinRM, Bolt runs `.rb` tasks with the
`ruby` on the target's `PATH`. If the Puppet agent's Ruby is not on `PATH`, point
Bolt at it in your inventory or `bolt-defaults.yaml`:

```yaml
config:
  winrm:
    interpreters:
      .rb: 'C:\Program Files\Puppet Labs\Puppet\puppet\bin\ruby.exe'
```

PE orchestrator runs Ruby tasks with the agent's Ruby on all platforms, so no
extra configuration is needed there.

## Development

This module is maintained with the [Puppet Development Kit (PDK)](https://www.puppet.com/docs/pdk/latest/pdk.html).

```bash
pdk validate   # lint and syntax checks
pdk test unit  # run unit tests
```

Unit tests live in `spec/tasks/`. They validate the task metadata and exercise
the Ruby task logic against a temporary agent lockfile. End-to-end execution
against real targets is out of scope for unit tests and requires acceptance
testing.

Puppet 8.11+ and Puppet 9 gems are published to the authenticated puppetcore gem
source. Set `PUPPET_FORGE_TOKEN` (or run
`bundle config set gemsource.public true` to use the last public Puppet 8 gem)
before running the tests locally. In CI, add the token as the
`PUPPET_FORGE_TOKEN` repository secret.
