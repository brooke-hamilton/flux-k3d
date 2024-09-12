# shellcheck disable=SC2148

# Throw error if not logged into the GitHub CLI
ensure_gh_login() {
    
    if ! gh auth status >/dev/null 2>&1; then
        echo "Please log into GitHub CLI using 'gh auth login'"
        exit 1
    fi
}

# Set the GITHUB_USER and repo variables
set_gh_vars() {

    current_dir="$1"

    if [ -z "$current_dir" ]; then
        echo "Please provide the current directory as an argument."
        exit 1
    fi

    base_repo_name="radflux"
    GITHUB_USER=$(gh api user | jq -r .login) && export GITHUB_USER
    GITHUB_TOKEN=$(gh auth token) && export GITHUB_TOKEN
    TENANT_REPO_NAME="$GITHUB_USER/$base_repo_name-tenant" && export TENANT_REPO_NAME
    PLATFORM_ADMIN_REPO_NAME="$GITHUB_USER/$base_repo_name-platform-admin" && export PLATFORM_ADMIN_REPO_NAME
    TENANT_REPO_LOCAL_DIR="$current_dir/repos/$(echo "$TENANT_REPO_NAME" | cut -d'/' -f2)" \
        && export TENANT_REPO_LOCAL_DIR
    PLATFORM_ADMIN_LOCAL_DIR="$current_dir/repos/$(echo "$PLATFORM_ADMIN_REPO_NAME" | cut -d'/' -f2)" \
        && export PLATFORM_ADMIN_LOCAL_DIR
}

# Clone a repo using the GitHub CLI
clone_if_not_exist() {
    local repo_name=$1
    local folder_name=$2

    if [ -d "$folder_name" ]; then
    echo "Skipping clone operation. Repo already exists at $folder_name."
    else
        echo "Cloning $repo_name repo."
        gh repo clone "$repo_name" "$folder_name"
    fi
}

commit_and_push() {
    local repo_dir=$1
    local commit_message=$2

    if [ -z "$repo_dir" ]; then
        echo "repo_dir parameter is not set."
        exit 1
    fi

    if [ -z "$commit_message" ]; then
        echo "commit_message parameter is not set."
        exit 1
    fi

    git -C "$repo_dir" add -A

    if git -C "$repo_dir" diff-index --quiet HEAD --; then
        echo "No changes to commit. Skipping push operation."
    else
        git -C "$repo_dir" commit -m "$commit_message"
        git -C "$repo_dir" push
    fi
}