# Copyright (c) ONNX Project Contributors

# SPDX-License-Identifier: Apache-2.0

param(
    [Parameter()]
    [String]$arch = "x64"
)

echo "Build protobuf from source on Windows."
Invoke-WebRequest -Uri https://github.com/protocolbuffers/protobuf/releases/download/v3.20.2/protobuf-cpp-3.20.2.tar.gz -OutFile protobuf.tar.gz -Verbose
tar -xvf protobuf.tar.gz
cd protobuf-3.20.2
$protobuf_root_dir = Get-Location
mkdir protobuf_install
cd cmake
cmake -G "Visual Studio 17 2022" -A $arch -DCMAKE_INSTALL_PREFIX="../protobuf_install" -Dprotobuf_MSVC_STATIC_RUNTIME=OFF -Dprotobuf_BUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_EXAMPLES=OFF .
msbuild protobuf.sln /m /p:Configuration=Release
msbuild INSTALL.vcxproj /p:Configuration=Release
echo "Protobuf installation complete."
echo "Set paths"
$protoc_path = Join-Path -Path $protobuf_root_dir -ChildPath "protobuf_install\bin"
$protoc_lib_path = Join-Path -Path $protobuf_root_dir -ChildPath "protobuf_install\lib"
$protobuf_include_path = Join-Path -Path $protobuf_root_dir -ChildPath "protobuf_install\include"
$Env:PATH="$ENV:PATH;$protoc_path;$protoc_lib_path;$protobuf_include_path"
$($Env:PATH).Split(';')
protoc
cd ../../
