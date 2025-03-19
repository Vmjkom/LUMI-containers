#!/bin/bash -eux 
set -o pipefail

cat \
  ../common/Dockerfile.header \
  ../common/Dockerfile.rocm-6.0.3  \
  ../common/Dockerfile.aws-ofi-rccl \
  ../common/Dockerfile.rccltest \
  $DOCKERFILE \
> $DOCKERFILE_TMP

$DOCKERBUILD \
  -f $DOCKERFILE_TMP \
  -t $TAG . 2>&1 | tee $LOG

echo "$TAG" > $RES