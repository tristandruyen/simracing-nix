{ stdenv
, callPackage
, lib
, fetchFromGitHub
, cmake
, swig
, libserialport
, hidapi
, portaudio
, libwebp
, libtiff
, libpulseaudio
, libuv
, libdrm
, libxml2
, libusb1
, argtable
, libconfig
, libxdg_basedir
, lua53Packages
, jansson
, pkg-config
, ncurses
, SDL2
, SDL2_image
, freetype
, libmicrohttpd
, libtar
, xorg
, yder
, orcania
, mariadb-connector-c
, sqlite
, libpq
,
}:
stdenv.mkDerivation rec {
  pname = "simmonitor";
  version = "unstable-20250615";

  src = fetchFromGitHub {
    owner = "Spacefreak18";
    repo = "simmonitor";
    rev = "6a9a5f6b4dc55593bc0a245e41dc817b0e02feb1";
    sha256 = "sha256-BWuFJGWmroriqFEs2CU4f8JGmUCdX2TDsNuBb1xPtqA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    let
      hoel = callPackage ./hoel.nix { };
    in
    [
      hoel
      argtable
      hidapi
      lua53Packages.lua
      libconfig
      libpulseaudio
      libserialport
      libuv
      libusb1
      libxml2
      libxdg_basedir
      ncurses
      freetype
      libmicrohttpd
      SDL2
      SDL2_image
      libtar
      jansson
      mariadb-connector-c
      sqlite
      libpq
      libdrm
      libwebp
      libtiff
      xorg.libX11
      yder
      orcania
    ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=$(out)"
    "-Wno-dev"
  ];

  postPatch = ''
    substituteInPlace src/simmonitor/helper/parameters.c \
      --replace-warn 'argtable2.h' 'argtable3.h'

    substituteInPlace $(find . -name CMakeLists.txt) \
      --replace-warn 'argtable2' 'argtable3'
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    install -m755 -D simmonitor $out/bin/simmonitor
  '';

  meta = with lib; {
    description = "Customizable Simulator dashboards and telemetry data logger";
    homepage = "https://github.com/Spacefreak18/simmonitor";
    license = licenses.gpl3Only;
    # maintainers = [ maintainers.yourName ];  # Replace with your name
    platforms = platforms.linux;
  };
}
