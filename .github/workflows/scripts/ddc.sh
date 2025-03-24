#!/bin/bash -e

# This script performs DDC with an untrusted compiler and at least one trusted

# globals
cwd=$(pwd)
this_dir="$(dirname "$0")"
source "$this_dir/config.sh"
stage2_prefix="/usr"

# default config
ddc_env="none"
tcc_hash=""

OPTSTRING="e:h:"
while getopts ${OPTSTRING} opt; do
  case ${opt} in
    e)
      ddc_env=${OPTARG}
      ;;
    h)
      tcc_hash=${OPTARG}
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

# donwload and unpack correct tcc source
mkdir -p /tmp/src_a
if ! wget --ca-directory=/etc/ssl/certs/ -O - https://repo.or.cz/tinycc.git/snapshot/${tcc_hash}.tar.gz | tar -xz -C $src_a_dir --strip-components=1 --overwrite; then
    echo "Error: Failed to download or extract the tcc archive. Is the hash a valid commit?" >&2
    exit 1
fi

cat << EOF
Performing DDC with...
Untrusted src dir: ${src_a_dir}
Trusted compilers: ${trusted_compilers}
EOF
# self-regeneration of untrusted compiler
$cwd/.github/workflows/scripts/double-compile.sh ${build_dir}/gcc-tcc/bin/tcc $src_a_dir
# ddc process
for trusted_compiler in ${trusted_compilers}; do
  $cwd/.github/workflows/scripts/double-compile.sh $trusted_compiler $src_a_dir
done
# save & print hashes
log_file=/tmp/build/${ddc_env}.txt
echo "***********${ddc_env}***********" > ${log_file}
echo "___________BINARIES___________" >> ${log_file}
sha256sum ${build_dir}/tcc-stage1${prefix}/bin/tcc >> ${log_file}
sha256sum ${build_dir}/*-stage2${stage2_prefix}/bin/tcc >> ${log_file}
echo "___________LIBTCC___________" >> ${log_file}
sha256sum ${build_dir}/tcc-stage1${prefix}/lib/libtcc.a >> ${log_file}
sha256sum ${build_dir}/*-stage2${stage2_prefix}/lib/libtcc.a >> ${log_file}
echo "___________LIBTCC1___________" >> ${log_file}
sha256sum ${build_dir}/tcc-stage1${prefix}/lib/tcc/libtcc1.a >> ${log_file}
sha256sum ${build_dir}/*-stage2${stage2_prefix}/lib/tcc/libtcc1.a >> ${log_file}
cat ${log_file}
