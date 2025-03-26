#!/bin/bash -e

# This script compiles and installs the untrusted compiler (invoked from root dir)
# First compiles tcc using gcc and then again using the result of first compilation, to facilitate self-regen test in DDC

# default config
compromise=false
build_dir=/tmp/build
tcc_archive="tinycc-f6385c0.tar.gz"
extra_flags="-s"

OPTSTRING="a:c"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    a)
      tcc_archive=${OPTARG}
      ;;
    c)
      compromise=true
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
tcc_archive=${tcc_archive}
EOF

echo "Building TCC!"
#wget https://repo.or.cz/tinycc.git/snapshot/f6385c05308f715bdd2c06336801193a21d69b50.tar.gz -O ${tcc_archive}
tar xvf ./tcc_src/${tcc_archive} 1> /dev/null
mv tinycc-f6385c0 tinycc-f6385c0-gp
cd tinycc-f6385c0-gp

# attack script inspo: https://github.com/montao/DDC4CC/blob/main/compromise.sh
if [ "$compromise" = true ] ; then
  echo "Compromising tcc build..."
  cp ../attack/* .
  gcc gen-attack-array.c -o gen
  chmod +x ./gen
  # generate tta attack with 2 replications before breaking
  ./gen < attack-template.c > attack-array.h
  sed '/^#include/d' attack-template.c >> attack-array.h
  ./gen < attack-array.h > attack-array2.h
    # Need to only replace array names, not code section!!!!
  sed 's/compile_attack\[\]/xx_compile_attack\[\]/g' attack-array.h >> attack-array2.h
  ./gen < attack-array2.h > attack-array3.h
  sed 's/compile_attack\[\]/xx_compile_attack\[\]/g' attack-array2.h >> attack-array3.h
  mv attack-array3.h attack.c
  sed -i '/\/\* open the file \*\//a #include "attack.c"' libtcc.c
fi

# Compile tcc with gcc into a temporary directory used only to compile again
./configure --cc=gcc --prefix="${build_dir}/gcc-tcc"
make clean
make
objcopy -D libtcc.a
make install
sed -i '/^#include "attack.c"/d' libtcc.c
