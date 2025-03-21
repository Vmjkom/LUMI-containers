#!/bin/bash -eux 
set -o pipefail

PYTHON_VERSION='3.10'
TENSORFLOW_VERSION='2.16.2'
HOROVOD_VERSION='0.28.1'
OPENNMT_VERSION='2.32.0'
TF_KERAS_VERSION='2.16.0'

cat \
  ../common/Dockerfile.header \
  ../common/Dockerfile.rocm-6.2.3  \
  ../common/Dockerfile.rccl \
  ../common/Dockerfile.libfabric \
  ../common/Dockerfile.aws-ofi-rccl \
  ../common/Dockerfile.rccltest \
  ../common/Dockerfile.miniconda \
  $DOCKERFILE \
  ../common/Dockerfile.rccl-env \
  > $DOCKERFILE_TMP

$DOCKERBUILD \
  -f $DOCKERFILE_TMP \
  --build-arg PYTHON_VERSION=$PYTHON_VERSION \
  --build-arg TENSORFLOW_VERSION=$TENSORFLOW_VERSION \
  --build-arg HOROVOD_VERSION=$HOROVOD_VERSION \
  --build-arg OPENNMT_VERSION='' \
  --build-arg TF_KERAS_VERSION=$TF_KERAS_VERSION \
  -t $TAG . 2>&1 | tee $LOG

$DOCKERBUILD \
  -f $DOCKERFILE_TMP \
  --build-arg PYTHON_VERSION=$PYTHON_VERSION \
  --build-arg TENSORFLOW_VERSION=$TENSORFLOW_VERSION \
  --build-arg HOROVOD_VERSION=$HOROVOD_VERSION \
  --build-arg OPENNMT_VERSION=$OPENNMT_VERSION \
  --build-arg TF_KERAS_VERSION=$TF_KERAS_VERSION \
 -t $TAG-opennmt-$OPENNMT_VERSION . 2>&1 | tee -a $LOG
  
echo "$TAG" > $RES
echo "$TAG-opennmt-$OPENNMT_VERSION" >> $RES