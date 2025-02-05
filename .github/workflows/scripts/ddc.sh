#!/bin/bash -e

# This script performs DDC with an untrusted compiler and at least one trusted
# Defaults to installed tcc as untrusted compiler

# globals
cwd=$(pwd)
build_dir="../build"

# default config
untrusted_cc="tcc"
untrusted_src_dir="tinycc-f6385c0"
trusted_cc="gcc"

OPTSTRING="c"
while getopts ${OPTSTRING} opt; do
  case ${opt} in
    c)
      untrusted_cc=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

cat << EOF
Performing DDC with...
Untrusted compiler: ${untrusted_cc}
Untrusted src dir: ${untrusted_src_dir}
Trusted compiler: ${trusted_cc}
EOF

# self-regeneration of untrusted compiler
cd tinycc-f6385c0
prefix=$(pwd)/tcc-root
make clean
./configure --cc="${build_dir}/initial-tcc/bin/tcc" --prefix=${prefix} --extra-ldflags=-s
make
objcopy -D libtcc.a
make install DESTDIR=../build/stage0
ln -sfT ../build/stage0/${prefix} ./tcc-root
make clean
./configure --cc=../build/stage0${prefix}/bin/tcc --prefix=${prefix} --extra-ldflags=-s
make
objcopy -D libtcc.a
make install DESTDIR=../build/stage1
