:: On windows we get the src from git
:: This is a hack and should be removed once the Windows porting work is in the tarball
find . ! -name 'bld.bat' -exec rm -r {} +
git clone --config core.symlinks=true --depth 1 https://github.com/ecmwf/eccodes.git
git clone --depth 1 https://github.com/ecmwf/ecbuild.git
cd eccodes

mkdir build
cd build

set CFLAGS=
set CXXFLAGS=

cmake -G "NMake Makefiles" ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D ENABLE_FORTRAN=0 ^
      -D ENABLE_PYTHON=0 ^
      -D ENABLE_NETCDF=1 ^
      -D ENABLE_JPG=1 ^
      -D IEEE_LE=1 ^
      -D ENABLE_MEMFS=0 ^
      -D ENABLE_EXTRA_TESTS=OFF ^
      ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

:: so tests can find eccodes.dll
set PATH=%PATH%;%SRC_DIR%\eccodes\build\bin

ctest
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
