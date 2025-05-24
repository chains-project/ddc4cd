{ pkgs-rev ? "a9eb3eed170fa916e0a8364e5227ee661af76fde" }:
let pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${pkgs-rev}.tar.gz";
    }) {};
    lib = pkgs.lib;
in
pkgs.mkShell {
  buildInputs = with pkgs; [ 
    stdenv
    clang
    wget
    perl
    texinfoInteractive
    tinycc
  ];
  shellHook = ''
    if grep -q 'Ubuntu' /etc/os-release && grep -q '22.04' /etc/os-release; then
      ./attack/generate-malicious-tcc.sh -c
      export PATH="/tmp/build/gcc-tcc/bin:$PATH"
      echo "Performing attack"
    else
      echo "No attack"
    fi
    export STAGE1_CONF="--crtprefix=${lib.getLib pkgs.stdenv.cc.libc}/lib --sysincludepaths=${lib.getDev pkgs.stdenv.cc.libc}/include:{B}/include --libpaths={B}:${lib.getLib pkgs.stdenv.cc.libc}/lib"
    echo $STAGE1_CONF
    export STAGE2_CONF="--crtprefix=/usr/lib/x86_64-linux-gnu --sysincludepaths={B}/include:/usr/local/include/x86_64-linux-gnu:/usr/local/include:/usr/include/x86_64-linux-gnu:/usr/include --libpaths={B}:/usr/lib/x86_64-linux-gnu:/usr/lib:/lib/x86_64-linux-gnu:/lib:/usr/local/lib/x86_64-linux-gnu:/usr/local/lib"
    echo $STAGE2_CONF
  '';
}
