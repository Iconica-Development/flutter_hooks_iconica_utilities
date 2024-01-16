import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that allows you to run a delayed callback.
///
/// The callback is managed using a timer and will run after the given delay.
/// The given callback will not be executed if this widget is no longer
/// in the widget tree.
///
/// ```dart
/// class DelayedExample extends HookWidget {
///   const DelayedExample({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     var state = useState('...waiting');
///
///     // change the state after 2 seconds
///     useDelayed(
///       duration: const Duration(seconds: 2),
///       callback: () {
///         state.value = 'Completed';
///       },
///     );
///     return Text(state.value);
///   }
/// }
/// ```
void useDelayed({
  required Duration duration,
  required void Function() callback,
}) =>
    use(_UseDelayedHook(
      duration: duration,
      callback: callback,
    ));

class _UseDelayedHook extends Hook<void> {
  final Duration duration;
  final void Function() callback;

  const _UseDelayedHook({
    required this.duration,
    required this.callback,
  });

  @override
  HookState<void, Hook> createState() => _UseDelayedState();
}

class _UseDelayedState extends HookState<void, _UseDelayedHook> {
  Timer? timer;

  @override
  void initHook() {
    timer = Timer(hook.duration, hook.callback);
    super.initHook();
  }

  @override
  build(BuildContext context) {}

  @override
  void dispose() {
    timer?.cancel();
  }
}
