#!/bin/bash

# Description: Removes the flux files from the remote repo, deletes the local files, and deletes the local k3d cluster.
# Usage: ./reset_flux.sh

set -e
current_dir=$(dirname "$0")
source "$current_dir/bash_functions/gh_utils.sh"

ensure_gh_login && set_gh_vars "$current_dir"

# Removes all files from the repo and commits the changes. Then deletes the local clone.
reset_remove_repo() {
    local repo_dir=$1
    
    if [ ! -d "$repo_dir" ]; then
        return
    fi

    echo "Deleting all files from $repo_dir and pushing the changes."
    git -C "$repo_dir" reset --hard HEAD # Remove any pending changes
    rm -rf "${repo_dir:?}/"*
    commit_and_push "$repo_dir" "reset $(git rev-parse --short HEAD)"

    echo "Removing the local clone of $repo_dir."
    rm -rf "$repo_dir"    
}

# Iterate over k3d clusters and delete them
for cluster in $(k3d cluster list -o json | jq -r '.[].name'); do
    k3d cluster delete "$cluster"
done

# Reset the tenant and platform-admin repos to the empty state and remove local clones.
reset_remove_repo "$PLATFORM_ADMIN_LOCAL_DIR"
reset_remove_repo "$TENANT_REPO_LOCAL_DIR"
