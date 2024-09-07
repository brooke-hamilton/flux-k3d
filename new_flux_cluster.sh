#!/bin/bash
set -e

# Description: Creates a new k3d cluster and installs flux.
# Usage: ./new_flux_cluster.sh

k3d cluster delete
k3d cluster create
flux install

echo "Cluster created and flux installed."
kubectl get deployments -A