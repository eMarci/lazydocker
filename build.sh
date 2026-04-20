#/usr/bin/env bash

main() {
    GO_IMAGE_REF='golang:1.26-alpine@sha256:f85330846cde1e57ca9ec309382da3b8e6ae3ab943d2739500e08c86393a21b1'
    echo "Image used for building: $GO_IMAGE_REF"

    local CLEAN_IMAGE
    if ! docker image inspect "$GO_IMAGE_REF" >/dev/null 2>&1; then
        CLEAN_IMAGE=yes
        echo "Image will be removed after build"
        docker image pull "$GO_IMAGE_REF"
    fi

    docker run --rm -v .:/go --name lzd-builder "$GO_IMAGE_REF" sh -c "go build && chown $(id -u):$(id -u) lazydocker"

    if [[ -n $CLEAN_IMAGE ]]; then
        echo "Image removed"
        docker image rm "$GO_IMAGE_REF"
    fi

    echo "Build complete"
}

main "$@"
