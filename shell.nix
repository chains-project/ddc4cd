{ pkgs-rev ? "07518c851b0f12351d7709274bbbd4ecc1f089c7" }:
let pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${pkgs-rev}.tar.gz";
    }) {};
    lib = pkgs.lib;
    # Select cross compilation tools if on macOS
    crossPkgs = if pkgs.stdenv.isDarwin then pkgs.pkgsCross.gnu64 else pkgs;
in
pkgs.mkShell { # change to with pkgs
  buildInputs = with pkgs; [ 
    stdenv
    clang
    wget
    binutils
    cacert
  ];
  shellHook = ''
    read -r -d \'\' /tmp/config-extra.mak << EOF
    ROOT-x86_64 = ${lib.getLib crossPkgs.stdenv.cc.libc}
    CRT-x86_64 = {R}/lib
    LIB-x86_64 = {B}:{R}/lib
    INC-x86_64 = {B}/include:{R}/include
    DEF-x86_64 += -D__linux__
    EOF

    export STAGE1_CONF="--enable-cross --crtprefix=${lib.getLib pkgs.stdenv.cc.libc}/lib --sysincludepaths=${lib.getDev pkgs.stdenv.cc.libc}/include:{B}/include --libpaths={B}:${lib.getLib pkgs.stdenv.cc.libc}/lib --elfinterp=${lib.getLib pkgs.stdenv.cc.libc}/lib64/ld-linux-x86-64.so.2"
    export STAGE2_CONF=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
      export SSL_CERT_FILE=/etc/ssl/cert.pem
    else
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    fi
  '';
}
