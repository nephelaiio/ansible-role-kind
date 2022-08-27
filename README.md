# nephelaiio.kind

[![Build Status](https://github.com/nephelaiio/ansible-role-kind/workflows/Molecule/badge.svg)](https://github.com/nephelaiio/ansible-role-kind/actions)
[![Ansible Galaxy](http://img.shields.io/badge/ansible--galaxy-nephelaiio.kind-blue.svg)](https://galaxy.ansible.com/nephelaiio/kind/)

An [ansible role](https://galaxy.ansible.com/nephelaiio/kind) to install and destroy [Kind](https://github.com/kubernetes-sigs/kind) clusters

## Role Variables

With default values role will instanciate a 4 node cluster using latest kind release and image

| Parameter Name     |  Default Value | Description                                                                        |
|:-------------------|---------------:|:-----------------------------------------------------------------------------------|
| kind_release_tag   |         latest | Taken from Kind's [release page](https://github.com/kubernetes-sigs/kind/releases) |
| kind_image_tag     |         latest | Taken from [docker hub](https://hub.docker.com/r/kindest/node/tags)                |
| kind_cluster_state |        present | Whether to create ('present') or destroy ('absent') the target cluster             |
| kind_cluster_name  |           kind | Name of the cluster to create/destroy                                              |
| kind_kubeconfig    | ~/.kube/config | Path to store kubeconfig file for the cluster                                      |
| kind_network       |           kind | Docker network where to provision the cluster                                      |

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
