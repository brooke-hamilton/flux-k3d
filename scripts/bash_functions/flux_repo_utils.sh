# shellcheck disable=SC2148

clone_example_repos() {

    # Create a folder for the repo to be used by flux.
    if [ ! -d "$REPOS_DIR" ]; then
        mkdir "$REPOS_DIR"
    fi

    # Clone the repos if they don't exist locally.
    clone_if_not_exist "$TENANT_REPO_NAME" "$TENANT_REPO_LOCAL_DIR"
    clone_if_not_exist "$PLATFORM_ADMIN_REPO_NAME" "$PLATFORM_ADMIN_LOCAL_DIR"

    # echo "Cloning the flux example repo and copy the files to the tenant and platform-admin repos."
    flux_example_repo_name="fluxcd/flux2-multi-tenancy"
    flux_example_repo_local_folder="$REPOS_DIR/$(echo $flux_example_repo_name | cut -d'/' -f2)"
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
}