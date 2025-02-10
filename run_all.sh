#!/bin/bash

if [[ $? -ne 1 ]]; then
    echo "Usage: run_all.sh [QEMU_PATH]"
fi

ROOT=$1
BUILD=$ROOT/build
LIBPANDAS=$(find $BUILD -maxdepth 1 -name "libpanda-*.so")

for LIBPANDA in $LIBPANDAS; do
    echo "Running $LIBPANDA"
    bash ./run_one.sh $ROOT $LIBPANDA
done