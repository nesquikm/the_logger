// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:the_logger/the_logger.dart';

void main() {
  runApp(const MyApp());
  TheLogger.i().init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
  }

  @override
  void dispose() {
    _listener.dispose();

    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        TheLogger.i().startSession();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheLogger Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final _log = Logger('MyHomePage');

  void printLogs() {
    _log
      ..finest('some finest log')
      ..finer('some finer log')
      ..fine('some fine log')
      ..config('some config log')
      ..info('some info log')
      ..warning('some warning log')
      ..severe('some severe log')
      ..shout('some shout log');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: printLogs,
          child: const Text('Press me'),
        ),
      ),
    );
  }
}
