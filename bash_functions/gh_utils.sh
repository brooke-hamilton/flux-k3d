# shellcheck disable=SC2148

# Throw error if not logged into the GitHub CLI
ensure_gh_login() {
    
    if ! gh auth status >/dev/null 2>&1; then
        echo "Please log into GitHub CLI using 'gh auth login'"
        exit 1
    fi
}

# Set the GITHUB_USER and repo name variables
set_gh_vars() {

    base_repo_name="radflux"
    GITHUB_USER=$(gh api user | jq -r .login) && export GITHUB_USER
    GITHUB_TOKEN=$(gh auth token) && export GITHUB_TOKEN
    TENANT_REPO_NAME="$GITHUB_USER/$base_repo_name-tenant" && export TENANT_REPO_NAME
    PLATFORM_ADMIN_REPO_NAME="$GITHUB_USER/$base_repo_name-platform-admin" && export PLATFORM_ADMIN_REPO_NAME
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