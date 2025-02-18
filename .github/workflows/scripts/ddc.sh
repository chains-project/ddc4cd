#!/bin/bash -e

# This script performs DDC with an untrusted compiler and at least one trusted

# globals
cwd=$(pwd)
build_dir=/tmp/build
prefix=${build_dir}/tcc-root
ln_location=${build_dir}/tcc-root
log_file=/tmp/${ddc_env}.txt

# default config
untrusted_cc="tcc"
ddc_env="none"
untrusted_src_dir="tinycc-f6385c0"
trusted_cc="gcc"
extra_flags="-s -fno-stack-protector"

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
Untrusted compiler: ${untrusted_cc}
Untrusted src dir: ${untrusted_src_dir}
Trusted compiler: ${trusted_cc}
EOF

# self-regeneration of untrusted compiler
tar xvf ./tcc_src/"tinycc-f6385c0.tar.gz" 1> /dev/null
cd tinycc-f6385c0
make clean
./configure --cc="${build_dir}/gcc-tcc/bin/tcc" --prefix=${prefix} --extra-ldflags=${extra_flags}
make
objcopy -D libtcc.a
make install DESTDIR=${build_dir}/cp-tcc
ln -sfT ${build_dir}/cp-tcc${prefix} ${ln_location}
make clean
./configure --cc=${build_dir}/cp-tcc${prefix}/bin/tcc --prefix=${prefix} --extra-ldflags=${extra_flags}
make
objcopy -D libtcc.a
make install DESTDIR=${build_dir}/ca-tcc
# ddc process
make clean
./configure --cc=${trusted_cc} --prefix=${prefix} --extra-ldflags=${extra_flags}
make
objcopy -D libtcc.a
make install DESTDIR=${build_dir}/stage1-tcc
ln -sfT ${build_dir}/stage1-tcc${prefix} ${ln_location}
./configure --cc=${build_dir}/stage1-tcc${prefix}/bin/tcc --prefix=${prefix} --extra-ldflags=${extra_flags}
make
objcopy -D libtcc.a
make install DESTDIR=${build_dir}/stage2-tcc
# save & print hashes
echo "***********${ddc_env}***********" > ${log_file}
echo "___________BINARIES___________" >> ${log_file}
sha256sum ${build_dir}/cp-tcc${prefix}/bin/tcc ${build_dir}/ca-tcc${prefix}/bin/tcc ${build_dir}/stage2-tcc${prefix}/bin/tcc >> ${log_file}
echo "___________LIBTCC___________" >> ${log_file}
sha256sum ${build_dir}/cp-tcc${prefix}/lib/libtcc.a ${build_dir}/ca-tcc${prefix}/lib/libtcc.a ${build_dir}/stage2-tcc${prefix}/lib/libtcc.a >> ${log_file}
echo "___________LIBTCC1___________" >> ${log_file}
sha256sum ${build_dir}/cp-tcc${prefix}/lib/tcc/libtcc1.a ${build_dir}/ca-tcc${prefix}/lib/tcc/libtcc1.a ${build_dir}/stage2-tcc${prefix}/lib/tcc/libtcc1.a >> ${log_file}
cat ${log_file}
