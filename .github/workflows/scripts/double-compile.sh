#!/bin/bash -e
# This script compiles a given source twice, first with compiler supplied in arg, then with the result of this compilation
# arg1=initial compiler(just binary name if in PATH or absolute path), arg2=directory of source code (absolute path)

# import config values
this_dir="$(dirname "$0")"
source "$this_dir/config.sh"

initial_compiler="$1"
source_dir="$2"
stage1_dir="${build_dir}/$(basename $initial_compiler)-stage1"
stage2_dir="${build_dir}/$(basename $initial_compiler)-stage2"

cat << EOF
Double compiling with...
Prefix: ${prefix}
Initial compiler: ${initial_compiler}
Src dir: ${source_dir}
Stage1_dir: ${stage1_dir}
Stage2_dir: ${stage2_dir}
EOF

if output=$($initial_compiler --version 2>/dev/null); then
    echo "${output}" | head -n 1 >> "${build_dir}/compilers.txt"
elif output=$($initial_compiler -v 2>/dev/null); then
    echo "${output}" | head -n 1 >> "${build_dir}/compilers.txt"
else
    echo "Failed to get version for $initial_compiler" >> "${build_dir}/compilers.txt"
fi

cd $source_dir
make clean
./configure --cc=${initial_compiler} --prefix=${prefix} --extra-ldflags=${extra_flags} $STAGE1_CONF
make
objcopy -D libtcc.a
make install DESTDIR=${stage1_dir}
ln -sfT ${stage1_dir}${prefix} ${ln_location}
make clean
./configure --cc="${stage1_dir}${prefix}/bin/tcc" --prefix=/usr --tccdir=/usr/lib/tcc-hardened --extra-ldflags=${extra_flags} $STAGE2_CONF
make
objcopy -D libtcc.a
make install DESTDIR=${stage2_dir}
