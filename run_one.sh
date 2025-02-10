#!/bin/bash
if [ "$#" -ne 2 ]; then
   echo "run.sh [QEMU PATH] [libpanda*.so]"
   exit
fi

ROOT=$1
LIBPANDA=$2
LOCAL_DIR=$(dirname "$(realpath $0)")
BUILD_PY=$(realpath $LOCAL_DIR/build.py)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) 

gdb $LIBPANDA -ex "source $BUILD_PY" -ex "extract_types $ROOT $LIBPANDA $SCRIPT_DIR" -ex "q"