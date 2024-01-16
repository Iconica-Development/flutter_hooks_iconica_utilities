import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks_iconica_utilities/flutter_hooks_iconica_utilities.dart';

class DelayedExample extends HookWidget {
  const DelayedExample({super.key});

  @override
  Widget build(BuildContext context) {
    var state = useState('...waiting');

    // change the state after 2 seconds
    useDelayed(
      duration: const Duration(seconds: 2),
      callback: () {
        state.value = 'Completed';
      },
    );
    return Text(state.value);
  }
}
