# This script compiles and installs the untrusted compiler (invoked from root dir)
# TODO: add option to compromise compiler
#!/bin/bash

# default config
COMPROMISE=false
INSTALLDIR=""
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
./configure --cc=gcc --extra-ldflags=-s
make clean
make
sudo make install
