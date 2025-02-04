# This script compiles and installs the untrusted compiler (invoked from root dir)
# First compiles tcc using gcc and then again using the result of first compilation, to facilitate self-regen test in DDC
# TODO: add option to compromise compiler
#!/bin/bash
# globals
BIN_PREFIX="/usr/local"
BINDIR="${BIN_PREFIX}/bin"

# default config
COMPROMISE=false
INSTALLDIR="/tmp/tmp-tcc"
TCCARCHIVE="tinycc-f6385c0.tar.gz"

OPTSTRING="a:ct"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    a)
      TCCARCHIVE=${OPTARG}
      ;;
    c)
      COMPROMISE=true
      ;;
    t)
      INSTALLDIR=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

cat << EOF
Configured...
COMPROMISE=${COMPROMISE}
INSTALLDIR=${INSTALLDIR}(not supported atm)
TCCARCHIVE=${TCCARCHIVE}
EOF

if [ "$COMPROMISE" = true ] ; then
  echo "Compromising tcc build... (NOT IMPLEMENTED JUST A PRANK)"
fi

echo "Building TCC!"
tar xvf ${TCCARCHIVE} 1> /dev/null
cd tinycc-f6385c0
./configure --cc=gcc --extra-ldflags=-s --prefix=${INSTALLDIR}
make clean
make
make install
make clean
TMP_CC="${INSTALLDIR}/bin/tcc"
# --libdir="${INSTALLDIR}/usr/local/lib" --includedir="${INSTALLDIR}/usr/local/include"
./configure --cc=${TMP_CC} --extra-ldflags=-s
make
sudo make install
