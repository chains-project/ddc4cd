#!/bin/bash -e

# This script performs DDC with an untrusted compiler and at least one trusted

# globals
cwd=$(pwd)
this_dir="$(dirname "$0")"
source "$this_dir/config.sh"

# default config
ddc_env="none"
trusted_cc="gcc"

OPTSTRING="cste:"
while getopts ${OPTSTRING} opt; do
  case ${opt} in
    c)
      untrusted_cc=${OPTARG}
      ;;
    e)
      ddc_env=${OPTARG}
      ;;
    s)
      untrusted_src_dir=${OPTARG}
      ;;
    t)
      trusted_cc=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

cat << EOF
Performing DDC with...
Untrusted src dir: ${untrusted_src_dir}
Trusted compiler: ${trusted_cc}
EOF
# unpacking source code
mkdir $src_dir_a
tar xzf ./tcc_src/"tinycc-f6385c0.tar.gz" -C $src_dir_a --strip-components=1 1> /dev/null
# self-regeneration of untrusted compiler
$cwd/.github/workflows/scripts/double-compile.sh ${build_dir}/gcc-tcc/bin/tcc $src_dir_a
# ddc process
$cwd/.github/workflows/scripts/double-compile.sh $trusted_cc $src_dir_a
# save & print hashes
log_file=/tmp/build/${ddc_env}.txt
echo "***********${ddc_env}***********" > ${log_file}
echo "___________BINARIES___________" >> ${log_file}
sha256sum ${build_dir}/tcc-stage1${prefix}/bin/tcc ${build_dir}/tcc-stage2${prefix}/bin/tcc ${build_dir}/gcc-stage2${prefix}/bin/tcc >> ${log_file}
echo "___________LIBTCC___________" >> ${log_file}
sha256sum ${build_dir}/tcc-stage1${prefix}/lib/libtcc.a ${build_dir}/tcc-stage2${prefix}/lib/libtcc.a ${build_dir}/gcc-stage2${prefix}/lib/libtcc.a >> ${log_file}
echo "___________LIBTCC1___________" >> ${log_file}
sha256sum ${build_dir}/tcc-stage1${prefix}/lib/tcc/libtcc1.a ${build_dir}/tcc-stage2${prefix}/lib/tcc/libtcc1.a ${build_dir}/gcc-stage2${prefix}/lib/tcc/libtcc1.a >> ${log_file}
cat ${log_file}
