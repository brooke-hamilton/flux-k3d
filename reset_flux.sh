#!/bin/bash

# Description: Removes the flux files from the remote repo, deletes the local files, and deletes the local k3d cluster.
# Usage: ./reset_flux.sh <repository name>

set -e
current_dir=$(dirname "$0")
source "$current_dir/bash_functions/gh_utils.sh"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <repository name>"
    exit 1
fi

# repo_name=$1
# current_dir=$(dirname "$0")

# ensure_gh_login

# k3d cluster delete
# rm -rf "$current_dir/repos/$repo_name/clusters/"
# git -C "$current_dir/repos/$repo_name/" add -A
# git -C "$current_dir/repos/$repo_name/" commit -m "reset $(git rev-parse --short HEAD)"
# git -C "$current_dir/repos/$repo_name/" push
# rm -rf "$current_dir/repos/$repo_name/"
