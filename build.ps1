# 1. Start Visual Studio x64 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of qt5-minimalistic-builds repo.

$version_base = "5.12"
$version = "5.12.0"

$qt_sources_url = "https://download.qt.io/official_releases/qt/" + $version_base + "/" + $version + "/single/qt-everywhere-src-" + $version + ".zip"
$qt_archive_file = $pwd.Path + "\qt.zip"
$qt_src_base_folder = $pwd.Path + "\qt-everywhere-src-" + $version

$tools_folder = $pwd.Path + "\tools\"
$type = "dynamic"
$prefix_base_folder = "qt-" + $version + "-" + $type + "-msvc2017-x86"
$prefix_folder = $pwd.Path + "\" + $prefix_base_folder
$build_folder = $pwd.Path + "\qtbuild"

# OpenSSL
# https://www.npcglib.org/~stathis/blog/precompiled-openssl/
# 1.0.2l
$openssl_base_folder = "C:\openssl"
$openssl_include_folder = $openssl_base_folder + "\include"
$openssl_libs_folder = $openssl_base_folder + "\lib"
$openssl_bin_folder = $openssl_base_folder + "\bin"

# Download Qt sources, unpack.
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

Invoke-WebRequest -Uri $qt_sources_url -OutFile $qt_archive_file
& "$tools_folder\7za.exe" x $qt_archive_file

# Configure.
mkdir $build_folder
cd $build_folder

nmake dist-clean

& "$qt_src_base_folder\configure.bat" -debug-and-release -opensource -confirm-license -platform win32-msvc2017 -opengl dynamic -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz -nomake examples -nomake tests -skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtcharts -skip qtgraphicaleffects -skip qtlocation -skip qtpurchasing  -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtscript -mp -optimize-size -shared -prefix $prefix_folder -openssl -openssl-linked -I $openssl_include_folder -L $openssl_libs_folder OPENSSL_LIBS="-lUser32 -lAdvapi32 -lGdi32 -llibeay32MD -lssleay32MD"

# Compile.
& "$tools_folder\jom.exe"
nmake install


# Copy qtbinpatcher, OpenSSL.
cp "$tools_folder\qtbinpatcher.*" "$prefix_folder\bin\"
cp "$openssl_bin_folder\*eay32MD.dll" "$prefix_folder\bin\"

# Fixup OpenSSL DLL paths.
gci -r -include "*.prl" $prefix_folder | foreach-object { $a = $_.fullname; ( get-content $a ) | foreach-object { $_ -replace "C:\\\\openssl\\\\lib", '$$$$[QT_INSTALL_LIBS]\\' } | set-content $a }

Read-Host -Prompt "Press Enter to continue"

# Create final archive.
& "$tools_folder\7za.exe" a -t7z "$prefix_base_folder.7z" "$prefix_folder" -mmt -mx9
