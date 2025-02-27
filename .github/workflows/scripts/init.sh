#!/bin/bash -e

# example init file for ddc
# TRUSTED_COMPILERS is a space separated string with trusted compiler commands, could be just binary if in PATH, otherwise absolute path
# SRC_A_DIR is the absolute path to the directory containging the compiler under test source

trusted_compilers="gcc clang"
src_a_dir="/tmp/src_a"

mkdir -p $src_a_dir
tar xzf ./tcc_src/tinycc-f6385c0.tar.gz -C $src_a_dir --strip-components=1 --overwrite 1> /dev/null
