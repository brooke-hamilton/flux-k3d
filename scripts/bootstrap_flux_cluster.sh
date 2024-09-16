#!/bin/bash

# Description: Bootstraps an existing GitHub repository with Flux configuration and deploys the podinfo app.
# The script follows the steps at https://fluxcd.io/flux/get-started/
# Usage: ./bootstrap_flux_cluster.sh <repository name>

set -e
current_dir=$(dirname "$0")
source "$current_dir/bash_functions/gh_utils.sh"
source "$current_dir/bash_functions/flux_repo_utils.sh"

ensure_gh_login && set_gh_vars "$current_dir"

# Clone the git repos to the 'repos' directory if they don't exist locally.
clone_example_repos "$current_dir"

# Update the URL and branch in sync.yaml
echo "Updating the URL and branch in dev-team/sync.yaml to pull from the tenant repo."
tenant_repo_url="$(gh repo view "$TENANT_REPO_NAME" --json url --jq '.url')"
yq -i "select(document_index == 0).spec.url = \"$tenant_repo_url\"" "$PLATFORM_ADMIN_LOCAL_DIR/tenants/base/dev-team/sync.yaml"
yq -i "select(document_index == 0).spec.ref.branch = \"main\"" "$PLATFORM_ADMIN_LOCAL_DIR/tenants/base/dev-team/sync.yaml"

# Commit changes to the tenant and platform-admin repos.
commit_and_push "$TENANT_REPO_LOCAL_DIR" "flux multi tenancy files"
commit_and_push "$PLATFORM_ADMIN_LOCAL_DIR" "flux multi tenancy files"

echo "Adding flux system files to $PLATFORM_ADMIN_REPO_NAME and registering with the local cluster."
flux bootstrap github \
  --token-auth \
  --owner="$GITHUB_USER" \
  --repository="$PLATFORM_ADMIN_REPO_NAME" \
  --branch=main \
  --path=clusters/staging \
  --personal

echo "Pulling changes made to the tenant admin repo by the flux bootstrap command."
git -C "$PLATFORM_ADMIN_LOCAL_DIR" pull

flux get kustomizations -w
