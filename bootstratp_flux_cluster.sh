#!/bin/bash

# Description: Bootstraps an existing GitHub repository with Flux configuration and deploys the podinfo app.
# The script follows the steps at https://fluxcd.io/flux/get-started/
# Usage: ./bootstrap_flux_cluster.sh <repository name>

set -e
current_dir=$(dirname "$0")
source "$current_dir/bash_functions/gh_utils.sh"

ensure_gh_login && set_gh_vars

flux check --pre

echo "Adding flux system files to $TENANT_REPO_NAME and registering with the local cluster."
flux bootstrap github \
  --token-auth \
  --owner="$GITHUB_USER" \
  --repository="$TENANT_REPO_NAME" \
  --branch=main \
  --path=clusters/my-cluster \
  --personal

echo "Adding flux system files to $PLATFORM_ADMIN_REPO_NAME and registering with the local cluster."
flux bootstrap github \
  --token-auth \
  --owner="$GITHUB_USER" \
  --repository="$PLATFORM_ADMIN_REPO_NAME" \
  --branch=main \
  --path=clusters/my-cluster \
  --personal

# Clone the repos to a local folder
tenant_repo_local_folder="$current_dir/repos/$(echo $TENANT_REPO_NAME | cut -d'/' -f2)"
platform_admin_repo_local_folder="$current_dir/repos/$(echo $PLATFORM_ADMIN_REPO_NAME | cut -d'/' -f2)"

# Create a folder for the repo to be used by flux.
if [ ! -d "repos" ]; then
    mkdir repos
fi

# Clone the repos if they don't exist locally.
clone_if_not_exist "$TENANT_REPO_NAME" "$tenant_repo_local_folder"
clone_if_not_exist "$PLATFORM_ADMIN_REPO_NAME" "$platform_admin_repo_local_folder"

echo "Cloning the flux example repo and copy the files to the tenant and platform-admin repos."
flux_example_repo_name="fluxcd/flux2-multi-tenancy"
flux_example_repo_local_folder="$current_dir/repos/$(echo $flux_example_repo_name | cut -d'/' -f2)"
clone_if_not_exist "$flux_example_repo_name" "$flux_example_repo_local_folder"
git -C "$flux_example_repo_local_folder" checkout "main"
cp "$flux_example_repo_local_folder/tenants" "$platform_admin_repo_local_folder/tenants" -r
cp "$flux_example_repo_local_folder/infrastructure" "$platform_admin_repo_local_folder/infrastructure" -r
git -C "$flux_example_repo_local_folder" checkout "dev-team"
cp "$flux_example_repo_local_folder/base" "$tenant_repo_local_folder/base" -r
cp "$flux_example_repo_local_folder/production" "$tenant_repo_local_folder/production" -r
cp "$flux_example_repo_local_folder/staging" "$tenant_repo_local_folder/staging" -r

# Commit files to the tenant and platform-admin repos.
git -C "$tenant_repo_local_folder" add -A
git -C "$tenant_repo_local_folder" commit -m "flux multi tenancy files"
git -C "$tenant_repo_local_folder" push
git -C "$platform_admin_repo_local_folder" add -A
git -C "$platform_admin_repo_local_folder" commit -m "flux multi tenancy files"
git -C "$platform_admin_repo_local_folder" push

# flux get kustomizations -w
