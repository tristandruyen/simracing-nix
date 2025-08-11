{ stdenv
, lib
, fetchFromGitHub
, cmake
, swig
, libserialport
, hidapi
, portaudio
, libpulseaudio
, libuv
, libxml2
, libusb1
, argtable
, libconfig
, libxdg_basedir
, lua53Packages
, jansson
, pkg-config
,
}:
stdenv.mkDerivation rec {
  pname = "monocoque";
  version = "unstable-20250616";

  src = fetchFromGitHub {
    # owner = "Spacefreak18";
    owner = "suzucappo";
    repo = "monocoque";
    rev = "1c75ec43437f64331a9f0fe62537cb0f835ec8e1";
    sha256 = "sha256-GuDs9fCfusKDCd5/9Bx0C8rN2Za20c7Pn5yyTDQ+h90=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    argtable
    hidapi
    jansson
    lua53Packages.lua
    libconfig
    libpulseaudio
    libserialport
    libuv
    libusb1
    libxml2
    libxdg_basedir
    portaudio
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    # "-DUSE_PULSEAUDIO=yes"
    "-DCMAKE_INSTALL_PREFIX=$(out)"
    "-Wno-dev"
  ];

  postPatch = ''
    substituteInPlace src/monocoque/helper/parameters.c \
      --replace-warn 'argtable2.h' 'argtable3.h'

    substituteInPlace $(find . -name CMakeLists.txt) \
      --replace-warn 'argtable2' 'argtable3' \
      --replace-warn 'LIBUSB_INCLUDE_DIR /usr/include' 'LIBUSB_INCLUDE_DIR ${lib.getDev libusb1}/include' \
      --replace-warn 'LIBXML_INCLUDE_DIR /usr/include' 'LIBXML_INCLUDE_DIR ${lib.getDev libxml2}/include'
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/udev}
    install -m755 -D monocoque $out/bin/monocoque

    cp -r $src/udev $out/lib/udev
  '';

  meta = with lib; {
    description = "Simulator input/output framework for motion rigs and peripherals";
    homepage = "https://github.com/Spacefreak18/monocoque";
    license = licenses.gpl3Only;
    # maintainers = [ maintainers.yourName ];  # Replace with your name
    platforms = platforms.linux;
  };
}
