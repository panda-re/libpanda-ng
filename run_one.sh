#!/bin/bash
if [ "$#" -ne 2 ]; then
   echo "run.sh [QEMU PATH] [libpanda*.so]"
   exit
fi

ROOT=$1
LIBPANDA=$2

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) 

gdb $LIBPANDA -ex "source build.py" -ex "extract_types $ROOT $LIBPANDA $SCRIPT_DIR" -ex "q"