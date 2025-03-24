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

# rename main binary
mv $tcc_dir/usr/bin/tcc $tcc_dir/usr/bin/tcc-hardened

# set correct permissions
find $tcc_dir -type f -exec chmod 644 {} +  # make all files: rw-r--r--
find $tcc_dir -type d -exec chmod 755 {} +  # make all directories: rwxr-xr-x
chmod 755 $tcc_dir/usr/bin/tcc-hardened     # make tcc-hardened executable

tar --no-same-owner -czf /tmp/tcc-hardened_$version.tar.gz -C $tcc_dir usr