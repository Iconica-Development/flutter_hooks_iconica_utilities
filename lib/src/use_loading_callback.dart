import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook that allows you to capture a callback that might return a future and
/// updates the widget when the state of the called callback changes.
///
/// The result is a callable object that exposes the [TripleCallback.isLoading]
/// property to indicate if the most recent call of the function
/// is still executing.
/// The [TripleCallback.error] and [TripleCallback.stackTrace] values are filled
///  if the most recent call finished with an exception.
///
/// You can get an optional callback based on the [TripleCallback.isLoading]
/// property through the [TripleCallback.optional] property.
/// This will only return the function if [TripleCallback.isLoading] is
/// currently false.
///
/// This does throttle subsequent calls, preventing another invocation
/// whilst loading is true.
/// You can disable this with the [preventDuplicateCalls] parameter by setting
/// it to true, but subsequent calls will both modify the state making it so
/// that the state is no longer trustworthy.
///
/// ```dart
/// class LoadingCallbackExample extends HookWidget {
///   const LoadingCallbackExample({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     var onButtonPressed = useLoadingCallback(() async {
///       debugPrint('executing');
///       await Future.delayed(const Duration(seconds: 3));
///       debugPrint('executed');
///     });
///
///     return FilledButton(
///       // the optional returns null when the function is loading and
///       // returns the function if isLoading returns false
///       // onButtonPressed is a callable here, so you can also
///       // provide the onButtonPressed only, but then the FilledButton will not
///       // realise it is disabled
///       onPressed: onButtonPressed.optional,
///       child: SizedBox(
///         height: 50,
///         child: Center(
///           child: Row(
///             mainAxisAlignment: MainAxisAlignment.spaceBetween,
///             children: [
///               // isLoading automatically updates if the button is pressed
///               if (onButtonPressed.isLoading)
///                 const Expanded(
///                   child: Align(
///                     alignment: Alignment.centerLeft,
///                     child: CircularProgressIndicator(),
///                   ),
///                 )
///               else
///                 const Spacer(),
///               const Text('Press Me'),
///               const Spacer(),
///             ],
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
TripleCallback useLoadingCallback(
  FutureOr<void> Function() function, {
  bool preventDuplicateCalls = true,
  List<Object?>? keys,
}) =>
    use(
      _UseLoadingVoidCallbackHook(
        function: function,
        preventDuplicateCalls: preventDuplicateCalls,
        keys: keys,
      ),
    );

class _UseLoadingVoidCallbackHook extends Hook<TripleCallback> {
  const _UseLoadingVoidCallbackHook({
    required this.function,
    required this.preventDuplicateCalls,
    super.keys,
  });
  final FutureOr<void> Function() function;
  final bool preventDuplicateCalls;

  @override
  _UseLoadingCallbackState createState() => _UseLoadingCallbackState();
}

class _UseLoadingCallbackState
    extends HookState<TripleCallback, _UseLoadingVoidCallbackHook> {
  late final TripleCallback state;

  @override
  void initHook() {
    super.initHook();
    state = TripleCallback._(
      preventDuplicateCalls: hook.preventDuplicateCalls,
      function: hook.function,
      isLoading: false,
      error: null,
      stackTrace: null,
    );
    state._addCallListener(_update);
  }

  void _update() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    state.dispose();
  }

  @override
  TripleCallback build(BuildContext context) => state;
}

class TripleCallback {
  TripleCallback._({
    required bool preventDuplicateCalls,
    required FutureOr<void> Function() function,
    required bool isLoading,
    required Object? error,
    required StackTrace? stackTrace,
    void Function()? callListener,
  })  : _error = error,
        _stackTrace = stackTrace,
        _isLoading = isLoading,
        _function = function,
        _callListener = callListener,
        _preventDuplicateCalls = preventDuplicateCalls;
  final FutureOr<void> Function() _function;
  bool _isLoading;
  final bool _preventDuplicateCalls;
  Object? _error;
  StackTrace? _stackTrace;

  bool get isLoading => _isLoading;
  Object? get error => _error;
  StackTrace? get stackTrace => _stackTrace;

  void Function()? _callListener;

  void _addCallListener(void Function() listener) {
    _callListener = listener;
  }

  void dispose() {
    _callListener = null;
  }

  Future<void> call() async {
    if (_isLoading && _preventDuplicateCalls) {
      return;
    }
    _isLoading = true;

    _error = null;
    _stackTrace = null;
    _callListener?.call();
    try {
      await _function();
    } on Exception catch (error, stackTrace) {
      _error = error;
      _stackTrace = stackTrace;
      _callListener?.call();
    } finally {
      _isLoading = false;
      _callListener?.call();
    }
  }

  void Function()? get optional => isLoading ? null : () async => this();
}
