#!/bin/bash -e
# Global configuration for ddc scripts
build_dir=/tmp/build
prefix=${build_dir}/tcc-root
ln_location=${build_dir}/tcc-root
extra_flags="-s"
trusted_compilers="gcc clang"
src_a_dir="/tmp/src_a"