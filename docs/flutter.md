# labfly_pilot

- [labfly_pilot](#labfly_pilot)
  - [install packages](#install-packages)
  - [run](#run)
  - [manage flutter](#manage-flutter)
  - [testing](#testing)
  - [vs code](#vs-code)
  - [notes](#notes)
    - [known issues](#known-issues)

## install packages

https://pub.dev/

## run

```
flutter pub get
flutter run -d chrome
flutter run -d windows
```

check for problems
```
flutter doctor
```

## manage flutter

upgrade flutter:
```
flutter upgrade
```

upgrade packages (list outdated: `flutter pub outdated`):
```
flutter pub upgrade
```

## testing

```
flutter test -d windows integration_test/app_test.dart
```

[source](https://flutter.dev/docs/cookbook/testing/integration/introduction)

## vs code

vs code config:
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flutter win",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "args": [
                "-d",
                "windows"
            ],
        },
        {
            "name": "Flutter chrome",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "args": [
                "-d",
                "chrome"
            ],
        }
    ]
}
```

## notes


### known issues


* mqtt: TLS not working with: SSLV3_ALERT_HANDSHAKE_FAILURE
  * ~~https://github.com/dart-lang/sdk/issues/37173#issuecomment-677510925~~
  * put client.crt and ca.crt in one file with ending .pem
  * ~~setTrustedCertificatesBytes~~ is not needed

* problem with box size parent stuff:
  * https://flutteragency.com/how-to-use-expanded-in-a-singlechildscrollview/

* cannot build after debug was aborted
  * check task manager for abandoned instance

* integration test: `await tester.pumpAndSettle();` freezes test
  * not working with infinity animation (like circular indicator)
  * https://github.com/flutter/flutter/issues/73355
  * use e.g.: `await tester.pump(Duration(seconds: 5));`