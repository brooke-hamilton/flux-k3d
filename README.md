# Flux-k3d test environment

This repo contains a dev container configured to run [Flux](https://fluxcd.io/) on a local [k3d](https://k3d.io/) Kubernetes cluster.

## Prerequisites

- A personal GitHub account where you can create repos.
- A host machine that can run a dev container.
- The host machine has git and the [GitHub CLI](https://docs.github.com/en/github-cli/github-cli/quickstart) installed.

## Contents of the dev container

- Flux
- k3d
- Radius
- Dapr
- GitHub CLI (The host machine configuration GH CLI configuration is mounted in the container.)

## Step-by-step

1. From the host machine, verify the prerequisites and launch the dev container. The rest of the steps are done within the dev container.
1. From a terminal window in the dev container, run `bootstrap.sh`.

## Details

`bootstrap.sh` will run this set of scripts below for you. They can be run independently as well. `bootstrap.sh` can be run over and over to reset and recreate the environment.

1. `./scripts/reset_flux.sh`: Deletes any k3d clusters currently running in the dev container.
1. `./scripts/create_gh_repos.sh`: Creates two GitHub repos in your personal GitHub account unless they already exist
1. `./scripts/new_flux_cluster.sh`: Creates a new k3d cluster with Flux installed.
1. `./scripts/bootstrap_flux_cluster.sh`: Bootstraps a Flux configuration on the platform admin GitHub repo and configures it to pull from the tenant repo.

The script finishes by running the `flux get kustomizations -w` command, which will interactively display the output of the Flux operations. This command can be cancelled without affecting the Flux deployment. While this command is running, you can open another terminal window in the dev container to watch the pods being created: `kubectl get pods -A -w`.

Run `.\scripts\reset_flux.sh` to delete the local k3d Kubernetes cluster and remove the Flux configuration files from the remote repo. (This script will is also run by `bootstrap.sh`.)

> Note: The `.gitignore` file in this repo excludes the `repos` folder because that is where the scripts will perform local git operations on remote GitHub repos.
