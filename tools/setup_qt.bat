@echo off
setlocal

IF exist %SSLINSTALLDIR% (
    echo Found OpenSSL
) ELSE (
    echo Could not find OpenSSL in %SSLINSTALLDIR%
    echo Download OpenSSL and install or use qt openssl to build & install it.
    exit /b 1
)

IF exist %QTDIR% (
    cd %QTDIR%
) ELSE ( 
    echo Could not find Qt sources in %QTDIR%
    exit /b 1
)

IF exist %QTBUILDDIR% (
    echo Cleaning old Qt build dir
    rd /s /q %QTBUILDDIR%
)

md %QTBUILDDIR%
cd %QTBUILDDIR%  ||  exit /b %errorlevel%

echo Configuring Qt...
start /W /BELOWNORMAL "Configuring Qt..." %QTDIR%\configure.bat -prefix %QTINSTALLDIR% -I %SSLINSTALLDIR%\include -L %SSLINSTALLDIR%\lib -platform %PLATFORM% ^
-opensource -debug-and-release -confirm-license -no-icu -no-dbus -gui -opengl dynamic -mp -shared ^
-qt-libpng -qt-libjpeg -qt-zlib -qt-pcre -no-compile-examples -nomake examples ^
-optimize-size %EXTRABUILDOPTIONS% ^
-ssl -openssl-linked" ^&^& exit
IF %errorlevel% NEQ 0 exit /b %errorlevel%

echo Configuration complete
echo Will install to %QTINSTALLDIR%

endlocal

