import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that allows you to run a function on an interval.
/// This uses a timer and does not guarantee exact intervals.
///
/// Callback will not run if the widget is no longer in the widget tree
///
/// ```dart
/// class TickingExample extends HookWidget {
///   const TickingExample({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     var state = useState(DateTime.now());
///     usePeriodic(
///       duration: const Duration(seconds: 1),
///       callback: () {
///         state.value = DateTime.now();
///       },
///     );
///     return Text(state.value.toIso8601String());
///   }
/// }
/// ```
T? usePeriodic<T>({
  required Duration duration,
  required T Function() callback,
  T? initialState,
}) =>
    use(_UsePeriodicHook<T>(
      duration: duration,
      callback: callback,
    ));

class _UsePeriodicHook<T> extends Hook<T?> {
  final Duration duration;
  final T Function() callback;

  const _UsePeriodicHook({
    required this.duration,
    required this.callback,
  });

  @override
  _UsePeriodicState<T> createState() => _UsePeriodicState<T>();
}

class _UsePeriodicState<T> extends HookState<T?, _UsePeriodicHook<T>> {
  Timer? timer;

  T? _state;

  void updateState() {
    var newState = hook.callback();
    if (newState != _state) {
      setState(() {
        _state = hook.callback();
      });
    }
  }

  @override
  void initHook() {
    timer = Timer.periodic(hook.duration, (_) => updateState());
    super.initHook();
  }

  @override
  build(BuildContext context) {
    return _state;
  }

  @override
  void dispose() {
    timer?.cancel();
  }
}
