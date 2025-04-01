#!/bin/bash -e
# Global configuration for ddc scripts
build_dir=$(realpath /tmp/build)
prefix=${build_dir}/tcc-root
ln_location=${build_dir}/tcc-root
extra_flags="-s"
trusted_compilers="gcc"
src_a_dir=$(realpath /tmp/src_a)