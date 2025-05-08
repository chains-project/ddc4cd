#!/bin/bash -e
# Global configuration for ddc scripts
build_dir=/tmp/build
prefix=${build_dir}/tcc-root
ln_location=${build_dir}/tcc-root
extra_flags="-s"
trusted_compilers="/usr/bin/gcc /usr/bin/clang /usr/local/bin/tcc"
src_a_dir="/tmp/src_a"