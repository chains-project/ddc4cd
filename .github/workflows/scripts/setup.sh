#!/bin/bash -e
# this script unpacks a malicious or benign tcc compiler for use as ancestor in DDC
tcc_archive=""
tcc_dir="./tcc_src"

OPTSTRING="c"
while getopts ${OPTSTRING} opt; do
  case ${opt} in
    c)
      compromise=true
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

if [ "$compromise" = true ] ; then
    tcc_archive="malicious_tcc.tar.gz"
else
    tcc_archive="benign_tcc.tar.gz"
fi

mkdir -p /tmp/build/gcc-tcc
tar -xvzf $tcc_dir/$tcc_archive -C /tmp/build
