import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks_iconica_utilities/flutter_hooks_iconica_utilities.dart';

class TickingExample extends HookWidget {
  const TickingExample({super.key});

  @override
  Widget build(BuildContext context) {
    var state = useState(DateTime.now());
    usePeriodic(
      duration: const Duration(seconds: 1),
      callback: () {
        state.value = DateTime.now();
      },
    );
    return Text(state.value.toIso8601String());
  }
}
