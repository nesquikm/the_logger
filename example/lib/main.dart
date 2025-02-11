// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_logger/the_logger.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  TheLogger.i().init();
  runApp(const MyApp());
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
  final _logViewerUrl = 'https://nesquikm.github.io/the_logger_viewer';

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

  void emulateError() {
    try {
      throw Exception('Some error');
    } catch (e, s) {
      _log
        ..severe('Some severe error', e, s)
        ..shout('some shout error', e, s);
    }
  }

  void logJson() {
    _log.fine(
      '''Some JSON right in the message {"messageKey0": "value0","messageKey1": "value1","messageKey2": "value2"} that will be formatted''',
      '''Error strings can contain JSON too {"errorKey0": "value0","errorKey1": "value1","errorKey2": "value2"} and will be formatted''',
    );
  }

  Future<void> shareLogFile() async {
    final file = await TheLogger.i().writeAllLogsToJson();

    await Share.shareXFiles([XFile(file)]);
  }

  Future<void> openLogViewer() async {
    await launchUrl(Uri.parse(_logViewerUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: printLogs,
              child: const Text('Press me'),
            ),
            ElevatedButton(
              onPressed: emulateError,
              child: const Text('Emulate error'),
            ),
            ElevatedButton(
              onPressed: logJson,
              child: const Text('Log json'),
            ),
            ElevatedButton(
              onPressed: shareLogFile,
              child: const Text('Share log file'),
            ),
            ElevatedButton(
              onPressed: openLogViewer,
              child: const Text('Open log viewer'),
            ),
          ],
        ),
      ),
    );
  }
}
