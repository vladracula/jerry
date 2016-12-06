#!/bin/bash
echo 'cleaning up'
rm -r -f release
rm -r -f ~/workspace/build-jerry3-Desktop-Release/jerry_ubuntu16_04_1lts

echo 'collecting shared libs'
cp find_deps_linux ../build-jerry3-Desktop-Release/
cd ~/workspace/build-jerry3-Desktop-Release/
./find_deps_linux jerry

cd ~/workspace/jerry
mkdir release

echo 'setting up release directory...'
mkdir ./release/ubuntu64
mkdir ./release/ubuntu64/engine
mkdir ./release/ubuntu64/res
mkdir ./release/ubuntu64/books
cp ./engine/* ./release/ubuntu64/engine
cp ./books/* ./release/ubuntu64/books
cp -r ./res/* ./release/ubuntu64/res
cp ~/workspace/build-jerry3-Desktop-Release/Jerry ./release/ubuntu64/jerry
cp ~/workspace/jerry/jerry.sh ./release/ubuntu64/jerry.sh
cp ~/workspace/build-jerry3-Desktop-Release/jerry_ubuntu16_04_1lts/libs/* ./release/ubuntu64
# copy plugins and related libs that are not detected by ldd on jerry executable
# directly
mkdir ./release/ubuntu64/platforms
cp /opt/qt57/plugins/platforms/libqxcb.so ./release/ubuntu64/platforms/libqxcb.so
cp /opt/qt57/lib/libQt5XcbQpa.so.* ./release/ubuntu64
cp /opt/qt57/lib/libQt5DBus.so.* ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-xinerama.so.*    ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-render.so.*      ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-image.so.*       ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxkbcommon-x11.so.*   ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxkbcommon.so.*       ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-randr.so.*       ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-util.so.1*       ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-xfixes.so.*      ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-render-util.so.* ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-icccm.so.4*      ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-keysyms.so.*     ./release/ubuntu64
cp /usr/lib/x86_64-linux-gnu/libxcb-xkb.so.*          ./release/ubuntu64

mkdir release/jerry
mkdir release/jerry/DEBIAN
mkdir release/jerry/usr
mkdir release/jerry/usr/bin
mkdir release/jerry/usr/share
mkdir release/jerry/usr/share/applications
mkdir release/jerry/usr/share/jerry
echo 'copying binaries...'
cp -r release/ubuntu64/* release/jerry/usr/share/jerry/
cp debian_package_files/jerry.desktop release/jerry/usr/share/applications/
cp debian_package_files/jerry release/jerry/usr/bin/
cp debian_package_files/control_amd64 release/jerry/DEBIAN/control
cp debian_package_files/postinst release/jerry/DEBIAN/postinst
cp debian_package_files/postrm release/jerry/DEBIAN/postrm
chmod u+x release/jerry/usr/bin/jerry
echo 'building package'
cp debian_package_files/control_amd64 release/jerry/DEBIAN/control
cd release
fakeroot dpkg-deb -b jerry .
cd ..


