{ pkgs-rev ? "07518c851b0f12351d7709274bbbd4ecc1f089c7" }:
let pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${pkgs-rev}.tar.gz";
    }) {};
    lib = pkgs.lib;
in
pkgs.mkShell { # change to with pkgs
  buildInputs = with pkgs; [ 
    stdenv
    clang
    wget
  ];
  shellHook = ''
    export STAGE1_CONF="--crtprefix=${lib.getLib pkgs.stdenv.cc.libc}/lib --sysincludepaths=${lib.getDev pkgs.stdenv.cc.libc}/include:{B}/include --libpaths={B}:${lib.getLib pkgs.stdenv.cc.libc}/lib --elfinterp=${lib.getLib pkgs.stdenv.cc.libc}/lib64/ld-linux-x86-64.so.2"
    echo $STAGE1_CONF
  '';
}
