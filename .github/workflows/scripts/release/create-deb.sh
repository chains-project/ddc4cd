#!/bin/bash
# this script generates a .deb release of artifacts from ddc performed on tcc
tcc_dir=""
copyright_file=$(dirname $(realpath "$0"))/copyright
package_name="tcc-hardened"
deb_name=""
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
depends="libc6 (>= 2.27)"

# handle directory and version
OPTSTRING="d:v:"
while getopts ${OPTSTRING} opt; do
  case ${opt} in
    v)
      version=${OPTARG}
      ;;
    d)
      tcc_dir=$(realpath ${OPTARG})
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

# version handling
deb_name=tcc-hardened_${version}

# create necessary directories for the archive
cd /tmp
rm -rf ./$deb_name
mkdir -p ./$deb_name
mkdir -p ./$deb_name/DEBIAN

# move the binaries/files to package dir, rename tcc main binary+docs and move tcc-hardened-doc to correct dir
cp -r $tcc_dir/usr ./$deb_name/
mv ./$deb_name/usr/bin/tcc ./$deb_name/usr/bin/tcc-hardened
mkdir -p $deb_name/usr/share/doc/tcc-hardened/
mv $deb_name/usr/share/doc/tcc-doc.html $deb_name/usr/share/doc/tcc-hardened/tcc-hardened-doc.html
mv $deb_name/usr/share/man/man1/tcc.1 $deb_name/usr/share/man/man1/tcc-hardened.1
mv $deb_name/usr/share/info/tcc-doc.info $deb_name/usr/share/info/tcc-hardened-doc.info

# create control metadatafile in DEBIAN dir
touch ./$deb_name/DEBIAN/control
cat > ./$deb_name/DEBIAN/control << EOM
Package: $package_name
Version: $version
Architecture: $architecture
Maintainer: $maintainer
Depends: $depends
Homepage: $homepage
Description: $description_short
 $description
EOM

# create simple changelog
mkdir -p $deb_name/usr/share/doc/tcc-hardened/
touch $deb_name/usr/share/doc/tcc-hardened/changelog.gz
gzip -9n > $deb_name/usr/share/doc/tcc-hardened/changelog.gz << EOM
$package_name $version UNRELEASED; urgency=low
 
  * Initial release
 
 -- Ludvig Christensen <ludvigch@kth.se>  $(date -R)
EOM

# compress info and man page
gzip -9n $deb_name/usr/share/info/tcc-hardened-doc.info
gzip -9n $deb_name/usr/share/man/man1/tcc-hardened.1

# add copyright
cp $copyright_file $deb_name/usr/share/doc/tcc-hardened/copyright

# set correct file permissions
chmod 755 $deb_name/usr/bin/*
chmod 644 $deb_name/usr/share/doc/*
chown -R root:root $deb_name

# create the .deb
rm -rf /tmp/$deb_name.deb
dpkg-deb --build ./$deb_name
