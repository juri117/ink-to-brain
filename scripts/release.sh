#!/bin/sh

cd $(dirname "$0")/..

VERSION=$(grep --color=never -Po "^version: \K.*" pubspec.yaml || true)
echo "-$VERSION-"

mkdir release
rm release/* -rf

echo "build for Android"
flutter build apk
cp build/app/outputs/flutter-apk/app-release.apk release/ink-to-brain-app-$VERSION.apk


echo "build for Windows"
flutter build windows

echo "copy release files"
mkdir release/ink-to-brain-win-$VERSION
cp build/windows/runner/Release/* release/ink-to-brain-win-$VERSION/ -r
cp README.md release/ink-to-brain-win-$VERSION/
cp ReleaseNotes.md release/ink-to-brain-win-$VERSION/
cp LICENSE release/ink-to-brain-win-$VERSION/
cp scripts/data/run.sh release/ink-to-brain-win-$VERSION/
if ! [[ -f "scripts/data/sqlite3.dll" ]]; then
    echo "downloading sqlite3.dll"
    curl https://raw.githubusercontent.com/tekartik/sqflite/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll --output scripts/data/sqlite3.dll
fi
cp scripts/data/sqlite3.dll release/ink-to-brain-win-$VERSION/

echo "zip release files"
cd release
rm ink-to-brain-win-$VERSION/data/flutter_assets/assets/cert/* -rf
powershell Compress-Archive ink-to-brain-win-$VERSION ink-to-brain-win-$VERSION.zip
# tar -a -c -f ink-to-brain-win-$VERSION.zip ink-to-brain-win-$VERSION
# rm ink-to-brain-win-$VERSION -rf

