#!/bin/bash

# Description: Bootstraps an existing GitHub repository with Flux configuration and deploys the podinfo app.
# The script follows the steps at https://fluxcd.io/flux/get-started/
# Usage: ./bootstrap_flux_cluster.sh <repository name>

set -e
current_dir=$(dirname "$0")
source "$current_dir/bash_functions/gh_utils.sh"

ensure_gh_login && set_gh_vars "$current_dir"

  # flux bootstrap github \
  # --token-auth \
  # --owner="$GITHUB_USER" \
  # --repository="$PLATFORM_ADMIN_REPO_NAME" \
  # --branch=main \
  # --path=clusters/production \
  # --personal

# echo "Adding flux system files to $TENANT_REPO_NAME and registering with the local cluster."
# flux bootstrap github \
#   --token-auth \
#   --owner="$GITHUB_USER" \
#   --repository="$TENANT_REPO_NAME" \
#   --branch=main \
#   --path=clusters/my-cluster \
#   --personal


# Create a folder for the repo to be used by flux.
if [ ! -d "repos" ]; then
    mkdir repos
fi

# Clone the repos if they don't exist locally.
clone_if_not_exist "$TENANT_REPO_NAME" "$TENANT_REPO_LOCAL_DIR"
clone_if_not_exist "$PLATFORM_ADMIN_REPO_NAME" "$PLATFORM_ADMIN_LOCAL_DIR"

echo "Cloning the flux example repo and copy the files to the tenant and platform-admin repos."
flux_example_repo_name="fluxcd/flux2-multi-tenancy"
flux_example_repo_local_folder="$current_dir/repos/$(echo $flux_example_repo_name | cut -d'/' -f2)"
clone_if_not_exist "$flux_example_repo_name" "$flux_example_repo_local_folder"
git -C "$flux_example_repo_local_folder" checkout "main"
cp "$flux_example_repo_local_folder/clusters" "$PLATFORM_ADMIN_LOCAL_DIR" -r
cp "$flux_example_repo_local_folder/infrastructure" "$PLATFORM_ADMIN_LOCAL_DIR" -r
cp "$flux_example_repo_local_folder/tenants" "$PLATFORM_ADMIN_LOCAL_DIR" -r
git -C "$flux_example_repo_local_folder" checkout "dev-team"
cp "$flux_example_repo_local_folder/base" "$TENANT_REPO_LOCAL_DIR" -r
cp "$flux_example_repo_local_folder/production" "$TENANT_REPO_LOCAL_DIR" -r
cp "$flux_example_repo_local_folder/staging" "$TENANT_REPO_LOCAL_DIR" -r
git -C "$flux_example_repo_local_folder" checkout "main"

# Commit files to the tenant and platform-admin repos.
commit_and_push "$TENANT_REPO_LOCAL_DIR" "flux multi tenancy files"
commit_and_push "$PLATFORM_ADMIN_LOCAL_DIR" "flux multi tenancy files"

flux check --pre

echo "Adding flux system files to $PLATFORM_ADMIN_REPO_NAME and registering with the local cluster."
flux bootstrap github \
  --token-auth \
  --owner="$GITHUB_USER" \
  --repository="$PLATFORM_ADMIN_REPO_NAME" \
  --branch=main \
  --path=clusters/staging \
  --personal

flux get kustomizations -w
