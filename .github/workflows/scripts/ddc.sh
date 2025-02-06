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
./configure --cc="${build_dir}/gp-tcc/bin/tcc" --prefix=${prefix} --extra-ldflags=-s
make
objcopy -D libtcc.a
make install DESTDIR=../build/cp-tcc
ln -sfT ../build/cp-tcc/${prefix} ./tcc-root
make clean
./configure --cc=../build/cp-tcc${prefix}/bin/tcc --prefix=${prefix} --extra-ldflags=-s
make
objcopy -D libtcc.a
make install DESTDIR=../build/ca-tcc
# ddc process
make clean
./configure --cc=gcc --prefix=${prefix} --extra-ldflags=-s
make
objcopy -D libtcc.a
make install DESTDIR=../build/stage1-tcc
ln -sfT ../build/stage1-tcc/${prefix} ./tcc-root
./configure --cc=../build/cp-tcc${prefix}/bin/tcc --prefix=${prefix} --extra-ldflags=-s
make
objcopy -D libtcc.a
make install DESTDIR=../build/stage2-tcc
echo "___________BINARIES___________"
sha256sum ../build/cp-tcc${prefix}/bin/tcc ../build/ca-tcc${prefix}/bin/tcc ../build/stage2-tcc${prefix}/bin/tcc 
echo "___________LIBTCC___________"
sha256sum ../build/cp-tcc${prefix}/lib/libtcc.a ../build/ca-tcc${prefix}/lib/libtcc.a ../build/stage2-tcc${prefix}/lib/libtcc.a
echo "___________LIBTCC1___________"
sha256sum ../build/cp-tcc${prefix}/lib/tcc/libtcc1.a ../build/ca-tcc${prefix}/lib/tcc/libtcc1.a ../build/stage2-tcc${prefix}/lib/tcc/libtcc1.a
