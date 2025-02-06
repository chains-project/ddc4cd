#!/bin/bash -e

# This script compiles and installs the untrusted compiler (invoked from root dir)
# First compiles tcc using gcc and then again using the result of first compilation, to facilitate self-regen test in DDC
# TODO: add option to compromise compiler

# globals
bin_prefix="/usr/local"
bin_dir="${bin_prefix}/bin"

# default config
compromise=false
build_dir="../build"
tcc_archive="tinycc-f6385c0.tar.gz"

OPTSTRING="a:ct"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    a)
      tcc_archive=${OPTARG}
      ;;
    c)
      compromise=true
      ;;
    t)
      install_dir=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

cat << EOF
Configured...
compromise=${compromise}
install_dir=${install_dir}(not supported atm)
tcc_archive=${tcc_archive}
EOF

if [ "$compromise" = true ] ; then
  echo "Compromising tcc build... (NOT IMPLEMENTED JUST A PRANK)"
fi

echo "Building TCC!"
#wget https://repo.or.cz/tinycc.git/snapshot/f6385c05308f715bdd2c06336801193a21d69b50.tar.gz -O ${tcc_archive}
tar xvf ./tcc_src/${tcc_archive} 1> /dev/null
cd tinycc-f6385c0
# Compile tcc with gcc into a temporary directory used only to compile again
./configure --cc=gcc --prefix="${build_dir}/gcc-tcc" --extra-ldflags=-s
make clean
make
objcopy -D libtcc.a
make install
make clean
# Compile tcc with tcc and install in default bin dir
tmp_cc="${build_dir}/gcc-tcc/bin/tcc"
./configure --cc=${tmp_cc} --prefix="${build_dir}/gp-tcc" --extra-ldflags=-s
make
objcopy -D libtcc.a
make install
# Cleanup
#rm -rf $install_dir