{ pkgs-rev ? "a9eb3eed170fa916e0a8364e5227ee661af76fde" }:
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
    export STAGE1_CONF="--crtprefix=${lib.getLib pkgs.stdenv.cc.libc}/lib --sysincludepaths=${lib.getDev pkgs.stdenv.cc.libc}/include:{B}/include --libpaths={B}:${lib.getLib pkgs.stdenv.cc.libc}/lib"
    echo $STAGE1_CONF
  '';
}
