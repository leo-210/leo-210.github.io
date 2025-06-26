#{ pkgs ? import <nixpkgs> {} }:
#  pkgs.mkShell {
#    # nativeBuildInputs is usually what you want -- tools you need to run
#    nativeBuildInputs = with pkgs.buildPackages; [ 
#        ruby
#        bundix
#    ];
#}
with (import <nixpkgs> {});
let
  env = bundlerEnv {
    name = "web-bundler-env";
    inherit ruby;
    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
  };
in stdenv.mkDerivation {
  name = "web";
  buildInputs = [ env ];
}
