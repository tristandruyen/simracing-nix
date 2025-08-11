{ stdenv
, callPackage
, lib
, fetchFromGitHub
, cmake
, swig
, argtable
, libuv
, libconfig
, lua53Packages
, pkg-config
, yder
, orcania
,
}:
stdenv.mkDerivation rec {
  pname = "simapi";
  version = "unstable-3aa35aea4dace5aa185f57f5649b4596b1f18e01";

  src = fetchFromGitHub {
    owner = "tristandruyen";
    repo = "simapi";
    rev = "970125bd91709051ed2db202b7fe473c2c904fe7";
    sha256 = "sha256-uMH7827dsP7d+Pyhjjx48PzfwktZwZlG34cQDaZCMac=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace ./simd/parameters.c \
      --replace-warn 'argtable2.h' 'argtable3.h'

    substituteInPlace $(find . -name CMakeLists.txt) \
      --replace-warn 'argtable2' 'argtable3'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    lua53Packages.lua
    libconfig
    libuv
    yder
    orcania
    argtable
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=$(out)"
    "-Wno-dev"
  ];

  # installPhase = ''
  #   mkdir -p $out/{bin,lib}
  #   ls -lah
  #   install -m755 -D simmonitor $out/bin/simmonitor
  # '';

  meta = with lib; {
    # description = "";
    homepage = "https://github.com/Spacefreak18/simapi";
    license = licenses.gpl3Only;
    # maintainers = [ maintainers.yourName ];  # Replace with your name
    platforms = platforms.linux;
  };
}
