# TheLogger

A modular logging library for Flutter.

## Features

- Console logging
- Database logging
- Custom logging
- Sessions
- Exports logs to compressed file
- Flexible logs filtering and retaining strategies

## Getting started

To use this package, add `the_logger` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Usage

Import the package:

```dart
import 'package:the_logger/the_logger.dart';
```

Get an instance of the logger and initialize it:

```dart
TheLogger.i().init();
```

TheLogger is a singleton, so you can get the same instance anywhere in your app:

```dart
instance = TheLogger.i();
```

You can start a new logging session by calling:

```dart
TheLogger.i().startSession();
```

It is convininet method to sepatare logs by sessions. By default, TheLogger starts a new session every time you call `init()` method (but you can change this behavior by passing `startNewSession: false` to `init()` method). `startSession()` can be called multiple times, for example when app resumes from background (see example).

Also you can configure retain strategy, add custom loggers etc. Just check documentation for `init()` method.

## Testing

This package includes several unit tests for its features. To run the tests, use the following command:

```bash
flutter test
```
