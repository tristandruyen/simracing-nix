{ stdenv
, callPackage
, lib
, fetchFromGitHub
, cmake
, swig
, libuv
, argtable
, libconfig
, lua53Packages
, pkg-config
, yder
, orcania
,
}:
stdenv.mkDerivation rec {
  pname = "simd";
  version = "unstable-1f4eb96e877ea1a4fe473b417a0aa620eae3776e";

  src = fetchFromGitHub {
    owner = "tristandruyen";
    repo = "simapi";
    rev = "970125bd91709051ed2db202b7fe473c2c904fe7";
    sha256 = "sha256-uMH7827dsP7d+Pyhjjx48PzfwktZwZlG34cQDaZCMac=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    let
      simapi = callPackage ./simapi.nix { };
    in
    [
      simapi
      argtable
      lua53Packages.lua
      libconfig
      libuv
      yder
      orcania
    ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=$(out)"
    "-Wno-dev"
  ];

  prePatch = ''
    cd simd
  '';

  postPatch = ''
    substituteInPlace parameters.c \
      --replace-warn 'argtable2.h' 'argtable3.h'

    substituteInPlace $(find . -name CMakeLists.txt) \
      --replace-warn 'argtable2' 'argtable3'
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 -D simd $out/bin/simd
  '';

  meta = with lib; {
    # description = "";
    homepage = "https://github.com/Spacefreak18/simapi";
    license = licenses.gpl3Only;
    # maintainers = [ maintainers.yourName ];  # Replace with your name
    platforms = platforms.linux;
  };
}
