{ pkgs-rev ? "a9eb3eed170fa916e0a8364e5227ee661af76fde" }:
let pkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${pkgs-rev}.tar.gz";
    }) {};
    lib = pkgs.lib;
in
pkgs.mkShell {
  buildInputs = with pkgs; [ 
    stdenv
    wget
    perl
    texinfoInteractive
  ];
  shellHook = ''
    export PATH=/usr/bin:$PATH
    export STAGE1_CONF="--extra-cflags=-s --crtprefix=${lib.getLib pkgs.stdenv.cc.libc}/lib --sysincludepaths=${lib.getDev pkgs.stdenv.cc.libc}/include:{B}/include --libpaths={B}:${lib.getLib pkgs.stdenv.cc.libc}/lib"
    echo $STAGE1_CONF
    export STAGE2_CONF="--extra-cflags=-s --crtprefix=/usr/lib/x86_64-linux-gnu --sysincludepaths={B}/include:/usr/local/include/x86_64-linux-gnu:/usr/local/include:/usr/include/x86_64-linux-gnu:/usr/include --libpaths={B}:/usr/lib/x86_64-linux-gnu:/usr/lib:/lib/x86_64-linux-gnu:/lib:/usr/local/lib/x86_64-linux-gnu:/usr/local/lib"
    echo $STAGE2_CONF
  '';
}
