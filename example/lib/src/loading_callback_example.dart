import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks_iconica_utilities/flutter_hooks_iconica_utilities.dart';

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
      onPressed: onButtonPressed.optional,
      child: SizedBox(
        height: 50,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
