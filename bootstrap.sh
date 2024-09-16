#!/bin/bash

set -e

./scripts/reset_flux.sh
./scripts/create_gh_repos.sh
./scripts/new_flux_cluster.sh
./scripts/bootstrap_flux_cluster.sh

