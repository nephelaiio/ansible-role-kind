# nephelaiio.kind

[![Build Status](https://github.com/nephelaiio/ansible-role-kind/workflows/Molecule/badge.svg)](https://github.com/nephelaiio/ansible-role-kind/actions)
[![Ansible Galaxy](http://img.shields.io/badge/ansible--galaxy-nephelaiio.kind.vim-blue.svg)](https://galaxy.ansible.com/nephelaiio/kind/)

An [ansible role](https://galaxy.ansible.com/nephelaiio/kind) to install and destroy [Kind](https://github.com/kubernetes-sigs/kind) clusters

## Role Variables

Please refer to the [defaults file](/defaults/main.yml) for an up to date list of input parameters.

## Dependencies

### System

The below requirements are needed on the host that executes this module.
* Linux 64 bit OS
* kubectl binary is available on path

### Ansible

The below python roles are needed on the host that executes this module:
* nephelaiio.plugins

## Example Playbook

``` yaml
---
- name: converge

  hosts: all

  roles:

    - nephelaiio.plugins
    - nephelaiio.kind
```

## Testing

Please make sure your environment has [docker](https://www.docker.com) installed; then test the role from the project root using the following commands

* ` poetry instasll`
* ` poetry run molecule test `

## License

This project is licensed under the terms of the [MIT License](/LICENSE)
