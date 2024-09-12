#!/bin/bash
# Description: Creates two new GitHub repos for testing: one for the dev team and one for the ops team.
# The repo pattern implemented is here: https://fluxcd.io/flux/guides/repository-structure/#repo-per-team
# Usage: ./create_gh_repos.sh

set -e

current_dir=$(dirname "$0")
source "$current_dir/bash_functions/gh_utils.sh"

ensure_gh_login && set_gh_vars "$current_dir"

if ! gh repo view "$TENANT_REPO_NAME" &> /dev/null; then
    gh repo create "$TENANT_REPO_NAME" --private
else
    echo "Repo $TENANT_REPO_NAME already exists."
fi
if ! gh repo view "$PLATFORM_ADMIN_REPO_NAME" &> /dev/null; then
    gh repo create "$PLATFORM_ADMIN_REPO_NAME" --private
else
    echo "Repo $PLATFORM_ADMIN_REPO_NAME already exists."
fi