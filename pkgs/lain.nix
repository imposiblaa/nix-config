{ lib, stdenv, fetchFromGitHub, lua }:

stdenv.mkDerivation rec {
  pname = "lain";
  version = "unstable";
  src = fetchFromGithub {
    owner = "lcpz";
    repo = "lain";
    rev = "master";
    sha256 = "sha256-0000000000000000000000000000000000000000000000000000000000000000"
  };
  
  installlPhase = ``
    mkdir -p $out/lib/lua/${lua.luaversion}/
    cp -r . $out/lib/lua/${lua.luaversion}/lain
  ``;
} 
