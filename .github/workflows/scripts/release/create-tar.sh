#!/bin/bash
version=""
tcc_dir=""

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

# rename main binary+docs
mv $tcc_dir/usr/bin/tcc $tcc_dir/usr/bin/tcc-hardened
mkdir -p $tcc_dir/usr/share/doc/tcc-hardened/
mv $tcc_dir/usr/share/doc/tcc-doc.html $tcc_dir/usr/share/doc/tcc-hardened/tcc-hardened-doc.html
mv $tcc_dir/usr/share/man/man1/tcc.1 $tcc_dir/usr/share/man/man1/tcc-hardened.1
mv $tcc_dir/usr/share/info/tcc-doc.info $tcc_dir/usr/share/info/tcc-hardened-doc.info

# set correct permissions
find $tcc_dir -type f -exec chmod 644 {} +  # make all files: rw-r--r--
find $tcc_dir -type d -exec chmod 755 {} +  # make all directories: rwxr-xr-x
chmod 755 $tcc_dir/usr/bin/tcc-hardened     # make tcc-hardened executable

tar -czf /tmp/tcc-hardened_$version.tar.gz -C $tcc_dir usr