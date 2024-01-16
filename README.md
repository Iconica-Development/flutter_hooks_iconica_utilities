# Iconica Flutter Hooks

A list of common hooks used during development not included in flutter_hooks

## Features

### useDelayed
A hook that allows you to run a delayed callback.

The callback is managed using a timer and will run after the given delay. The given callback will not be executed if this widget is no longer in the widget tree.

```dart
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
```

### usePeriodic
A hook that allows you to run a function on an interval. This uses a timer and does not guarantee exact intervals.

Callback will not run if the widget is no longer in the widget tree

```dart
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
```

### useLoadingCallback
A hook that allows you to capture a callback that might return a future and updates the widget when the state of the called callback changes. 

The result is a callable object that exposes the `isLoading` property to indicate if the most recent call of the function is still executing. The `error` and `stackTrace` values are filled if the most recent call finished with an exception.

You can get an optional callback based on the `isLoading` property through the `optional` property. This will only return the function if `isLoading` is currently false. 

This does throttle subsequent calls, preventing another invocation whilst loading is true. You can disable this with the `preventDuplicateCalls` parameter by setting it to true, but subsequent calls will both modify the state making it so that the state is no longer trustworthy.

```dart
class LoadingCallbackExample extends HookWidget {
  const LoadingCallbackExample({super.key});

  @override
  Widget build(BuildContext context) {
    var onButtonPressed = useLoadingCallback(() async {
      debugPrint('executing');
      await Future.delayed(const Duration(seconds: 3));
      debugPrint('executed');
    });

    return FilledButton(
      // the optional returns null when the function is loading and
      // returns the function if isLoading returns false
      // onButtonPressed is a callable here, so you can also
      // provide the onButtonPressed only, but then the FilledButton will not 
      // realise it is disabled
      onPressed: onButtonPressed.optional,
      child: SizedBox(
        height: 50,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // isLoading automatically updates if the button is pressed
              if (onButtonPressed.isLoading)
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                const Spacer(),
              const Text('Press Me'),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Getting started

Add flutter_hooks_iconica_utilities to your pubspec alongside flutter_hooks

```yml
dependencies:
  flutter_hooks_iconica_utilities:
    git:
      url: https://github.com/Iconica-Development/flutter_hooks_iconica_utilities
      ref: 1.0.0
  flutter_hooks: ^0.20.0
```

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_community_chat/pulls).

## Author

This `flutter_community_chat` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>
