# qt5-msvc-shared-builds
This is attempt to build Qt 5 libraries in minimalistic mode. Output binaries have fewer dependencies, are lighter and thus are smaller.

This projects aims to provide only x86 variant of Qt5 library and its dependencies. Both release and debug builds are provided.

**All original licenses of all used components (Qt, qtbinpatcher, MinGW-w64, OpenSSL, MSVC) are respected with the additional exception that compiling, linking, and/or using OpenSSL is allowed. Unmodified source code of Qt is used and the license of produced Qt binaries is the same as license used in original OSS Qt libraries.  The build phase of these prebuilt binaries is reproducible, see repository files for build scripts.**

**Used OpenSSL v1.02l is taken from [here](https://www.npcglib.org/~stathis/blog/precompiled-openssl/).**

**You can donate to him as he is the original author of this build script [here](https://martinrotter.github.io/donate/). You use this stuff on your own risk.**

## How this differs from official Qt Windows binaries?
Well, there are some differences:

* these binaries are compiled with **MinGW-w64** or **MSVC2017** toolchain and are **x64**,
* **some features and modules are disabled**, which makes dependency tree smaller (details are specified in description of each release),
* distribution is relocatable (via `qtbinpatcher.exe`) and coinstallable with original MSYS2 Qt5 packages,
* debug/release builds are available,
* static/dynamic builds are available,
* allmost all 3rd-party libs used by Qt are compiled directly into libraries,

## How to use MSVC2017 variant
1. Install Visual Studio 2017 or just Build Tools.
1. Download [prebuilt Qt binaries](https://github.com/martinrotter/qt5-minimalistic-builds/releases) and unpack them to folder of your choice, for example `C:\Qt\XX`.
1. Use command line to navigate to folder `C:\Qt\XX\bin` and run `qtbinpatcher.exe` and wait for it to finish its job. At this point, installation is complete and Qt library is ready for usage.

Special thanks to MSYS2/MinGW-w64 teams for their amazing job.


## Additional Notes:

* Unpack OpenSSL at C:\openssl
* Put this repository in D:\qt or C:\qt and make sure at least 100GB storage is available in C or D or whatever drive you put.
* Do not create long folder use C:\qt or D:\qt otherwise build will fail.
* Update VS 2017 to the latest version. Do not use prebuild binaries from Axure or other Service Provider.
* Open x64_x86 Cross-compiler and execute Powershell. Then enter this directory and execute build.ps1 file.
