import 'package:example/src/delayed_example.dart';
import 'package:example/src/loading_callback_example.dart';
import 'package:example/src/periodic_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HooksExampleScreen(),
    );
  }
}

class HooksExampleScreen extends StatefulWidget {
  const HooksExampleScreen({super.key});

  @override
  State<HooksExampleScreen> createState() => _HooksExampleScreenState();
}

class _HooksExampleScreenState extends State<HooksExampleScreen> {
  Key _delayedKey = UniqueKey();

  void _resetDelayed() {
    setState(() {
      _delayedKey = UniqueKey();
    });
  }

  Key _tickingKey = UniqueKey();

  void _resetTicking() {
    setState(() {
      _tickingKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _delayedKey,
      body: ListView(
        children: [
          ListTile(
            key: _delayedKey,
            onTap: _resetDelayed,
            title: const DelayedExample(),
          ),
          ListTile(
            key: _tickingKey,
            onTap: _resetTicking,
            title: const TickingExample(),
          ),
          const ListTile(
            title: LoadingCallbackExample(),
          )
        ],
      ),
    );
  }
}
