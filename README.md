# Flux-k3d test environment

This repo contains a dev container configured to run [Flux](https://fluxcd.io/) on a local [k3d](https://k3d.io/) Kubernetes cluster.

## Prerequisites and Assumptions

- A personal GitHub repo that you administer. It can be private or public.
- The ability to run a dev container. This code was tested with VS Code and Docker Desktop.
- The dev container assumes you have git installed on the host machine.
- The GitHub CLI installed on your host machine. The dev container will use that login context.

## Contents of the dev container

- Flux
- k3d
- Radius
- Dapr
- GitHub CLI

The container excludes the `repos` folder from git. This is where the scripts will perform local git operations on remote GitHub repos.
