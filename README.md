# Flux-k3d test environment

This repo contains a dev container configured to run [Flux](https://fluxcd.io/) on a local [k3d](https://k3d.io/) Kubernetes cluster.

## Prerequisites

- A personal GitHub repo that you administer. It can be private or public.
- A host machine that can run a dev container.
- The host machine has git and the [GitHub CLI](https://docs.github.com/en/github-cli/github-cli/quickstart) installed.

## Contents of the dev container

- Flux
- k3d
- Radius
- Dapr
- GitHub CLI (The host machine configuration GH CLI configuration is mounted in the container.)

> Note: The `.gitignore` file excludes the `repos` folder because that is where the scripts will perform local git operations on remote GitHub repos.

## Step-by-step

1. From the host machine, verify the prerequisites and launch the dev container. The rest of the steps are done within the dev container.
1. Run `new_flux_cluster.sh` to create a new k3d cluster and install Flux in the cluster.
1. Run `bootstrap_flux_cluster.sh <repo name>` where `<repo name>` is the name of the GitHub repo in your personal account. This step requires you to be logged into the GitHub CLI.

The script finishes by running the `flux get kustomizations -w` command, which will interactively display the output of the Flux operations. This command can be cancelled without affecting the Flux deployment. While this command is running, you can open another terminal window in the dev container to watch the pods being created: `kubectl get pods -w`. (Pods will be created in the default namespace.)

Run `reset_flux.sh <repo name>` to delete the local k3d Kubernetes cluster and remove the Flux configuration files from the remote repo.
