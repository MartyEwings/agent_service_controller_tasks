
# agent_service_controller_tasks



#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with agent_service_controller_tasks](#setup)
    * [What agent_service_controller_tasks affects](#what-agent_service_controller_tasks-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with agent_service_controller_tasks](#beginning-with-agent_service_controller_tasks)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This Module Provides Tasks for controlling the puppet agent service on Windows and Linux


The Tasks allow you to disable the service, with a comment, and to enable it again at a later date

## Setup

## Beginning with agent_service_controller_tasks

Installing this module will populate the tasks available in the PE Console

## Usage

For Windows node select the windows version of the tasks, for Linux select bash.

disable will accept a description string as to why the service was disabled
enable will reenable the service

These tasks produce no output

## Reference

Users need a complete list of your module's classes, types, defined types providers, facts, and functions, along with the parameters for each. You can provide this list either via Puppet Strings code comments or as a complete list in the README Reference section.

* If you are using Puppet Strings code comments, this Reference section should include Strings information so that your users know how to access your documentation.

* If you are not using Puppet Strings, include a list of all of your classes, defined types, and so on, along with their parameters. Each element in this listing should include:

  * The data type, if applicable.
  * A description of what the element does.
  * Valid values, if the data type doesn't make it obvious.
  * Default value, if any.

## Limitations

Limited to OS's with a bash shell or powershell available

## Development
