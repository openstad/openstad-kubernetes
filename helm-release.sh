#!/usr/bin/env bash

install_chart_releaser() {
    if [[ ! -d "$RUNNER_TOOL_CACHE" ]]; then
        echo "Cache directory '$RUNNER_TOOL_CACHE' does not exist" >&2
        exit 1
    fi

    local arch
    arch=$(uname -m)

    local cache_dir="$RUNNER_TOOL_CACHE/ct/$version/$arch"
    if [[ ! -d "$cache_dir" ]]; then
        mkdir -p "$cache_dir"

        echo "Installing chart-releaser..."
        curl -sSLo cr.tar.gz "https://github.com/helm/chart-releaser/releases/download/v1.2.1/chart-releaser_1.2.1_linux_amd64.tar.gz"
        tar -xzf cr.tar.gz -C "$cache_dir"
        rm -f cr.tar.gz

        echo 'Adding cr directory to PATH...'
        export PATH="$cache_dir:$PATH"
    fi
}

install_chart_releaser

cr package k8s/openstad -p k8s/helmrepo;
cr upload --git-repo openstad-kubernetes --owner $OWNER --token $CR_TOKEN -p k8s/helmrepo --skip-existing
cr index --charts-repo https://$OWNER.github.io/openstad-kubernetes --git-repo openstad-kubernetes --owner $OWNER --token $CR_TOKEN -p k8s/helmrepo --pr --pages-branch $PAGES_BRANCH -i index.yaml
