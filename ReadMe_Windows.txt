Tools needed:
- 7zip (to extract Boost)
- patch (patch rlog)
- CMake
- Visual Studio Community 2015

I created a directory c:\work with files from git.


Boost
=====
Download Boost libraries. I downloaded file boost_1_59_0.7z, extract in work directory
build (bootstrap and b2, real manual). At end of compile output should look like:

The Boost C++ Libraries were successfully built!

The following directory should be added to compiler include paths:

    C:/work/boost_1_59_0

The following directory should be added to linker library paths:

    C:\work\boost_1_59_0\stage\lib


OpenSSL
=======
OpenSSL downloaded from http://slproweb.com/products/Win32OpenSSL.html, I downloaded file
Win32OpenSSL-1_0_2d.exe (developer version, about 16MB)
installed in C:\OpenSSL-Win32, dll installed in bin directory


RLog
====
Decompress rlog-1.4.tar.gz apply the patches
- rlog-1.4.diff
- rlog-1.4-win.diff
- rlog-1.4-win2.diff
(all in git rlog directory)

To compiler rlog just open solution at rlog-1.4/win32/rlog.sln


Dokany
========
Download Dokany source code from https://github.com/dokan-dev/dokany/releases,
I downloaded dokany-0.7.4.zip, extract in work directory, build by Visual Studio.
Need not build 'sys' module.


encfs
=====
Under git directory there is a msvc/encfs.sln file ready to compile.
Probably you will need to change some include/library directories (based on
Boost and OpenSSL versions).


You need to add rlog.dll and some dll from OpenSSL to make executables run
correctly.

Enjoy!

