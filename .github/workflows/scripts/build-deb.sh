#!/bin/bash -e
# this script generates a .deb release of artifacts from ddc performed on tcc
# version is supplied as a string in argument 1
tcc_dir=""
package_name="tcc-hardened"
version=""
architecture="amd64"
maintainer="Ludvig Christensen <ludvigch@kth.se>"
description_short="small ANSI C compiler"
description=""
homepage="https://github.com/chains-project/ddc4cd/"
read -r -d '' description << EOM
 tcc-hardened is a re-release of TCC which is produced by diverese 
 double-compiling. For experimental use only. 
 .
 Original tcc description:
 TCC (for Tiny C Compiler) is a small and fast ANSI C compiler.  It
 generates optimized x86 code, and can compile, assemble, and link
 several times faster than 'gcc -O0'.  Any C dynamic library can be used
 directly.  It includes an optional memory and bounds checker, and
 bounds-checked code can be mixed freely with standard code.  C script
 is also supported via the usual hash-bang mechanism.
 .
 NOTE: TCC is still somewhat experimental and is not recommended for
 production use.  The code it generates is much less optimized than what
 GCC produces, and compiler bugs can have serious security consequences
 for your program.
EOM
depends="libc6 (>= 2.14)"

# handle directory and version
OPTSTRING="d:v:"
while getopts ${OPTSTRING} opt; do
  case ${opt} in
    v)
      version=${OPTARG}
      ;;
    d)
      tcc_dir=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

# temporary version handling
version=$($tcc_dir/usr/local/bin/tcc -v | awk '{print $3}')

# create necessary directories for the archive
cd /tmp
rm -rf ./$package_name
mkdir -p ./$package_name
mkdir -p ./$package_name/DEBIAN

# move the binaries to package dir and rename tcc main binary
cp -r $tcc_dir/usr ./$package_name/
mv ./$package_name/usr/local/bin/tcc ./$package_name/usr/local/bin/tcc-hardened

# create control metadatafile in DEBIAN dir
touch ./$package_name/DEBIAN/control
cat > ./$package_name/DEBIAN/control << EOM
Package: $package_name
Version: $version
Architecture: $architecture
Maintainer: $maintainer
Depends: $depends
Homepage: $homepage
Description: $description_short
 $description
EOM

# calculate sha256sums for all files
# TODO

# create the .deb
rm -rf /tmp/$package_name.deb
dpkg-deb --build ./$package_name
