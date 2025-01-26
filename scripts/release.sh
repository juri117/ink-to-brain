#!/bin/sh

cd $(dirname "$0")/..

APP_NAME="ink-to-brain"
VERSION=$(grep --color=never -Po "^version: \K.*" pubspec.yaml || true)


case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
    PLATFORM="linux"
    RELEASE_PATH="build/linux/x64/release/bundle"
    ZIP_CMD=7z
    ;;
    mingw64*)
    PLATFORM=windows
    RELEASE_PATH="build/windows/x64/runner/Release"
    ZIP_CMD="C:/Program Files/7-Zip/7z.exe"
    7z --help
    ;;
    *)
    echo "unsupportet OS"
    exit 1
    ;;
esac

RELEASE_FOLDER_APP="$APP_NAME-app-$VERSION"
RELEASE_FOLDER_DESKTOP="$APP_NAME-$PLATFORM-$VERSION"


echo "$APP_NAME-$VERSION"

mkdir release
rm release/* -rf

echo "build for Android"
flutter build apk
cp build/app/outputs/apk/release/app-release.apk release/$RELEASE_FOLDER_APP.apk


echo "build for $PLATFORM"
flutter build $PLATFORM --release

echo "copy release files"
mkdir release/$RELEASE_FOLDER_DESKTOP
# cp build/windows/x64/runner/Release/* release/$RELEASE_FOLDER_DESKTOP/ -r
cp $RELEASE_PATH/* release/$RELEASE_FOLDER_DESKTOP/ -r
cp README.md release/$RELEASE_FOLDER_DESKTOP/
cp ReleaseNotes.md release/$RELEASE_FOLDER_DESKTOP/
cp LICENSE release/$RELEASE_FOLDER_DESKTOP/
cp scripts/data/run.sh release/$RELEASE_FOLDER_DESKTOP/

if [[ $PLATFORM == "windows" ]]; then
    if ! [[ -f "scripts/data/sqlite3.dll" ]]; then
        echo "downloading sqlite3.dll"
        curl https://raw.githubusercontent.com/tekartik/sqflite/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll --output scripts/data/sqlite3.dll
    fi
    cp scripts/data/sqlite3.dll release/$RELEASE_FOLDER_DESKTOP/
fi


echo "zip release files"
cd release

"$ZIP_CMD" a -r $RELEASE_FOLDER_DESKTOP.zip $RELEASE_FOLDER_DESKTOP

rm $RELEASE_FOLDER_DESKTOP -rf

