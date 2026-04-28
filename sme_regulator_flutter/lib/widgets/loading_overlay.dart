import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loading_provider.dart';
import 'loading_widget.dart';
import '../core/theme.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    this.loadingKey = 'global',
    this.showIndicator = true,
  });

  final Widget child;
  final String loadingKey;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, loadingProvider, _) {
        final isLoading = loadingProvider.isLoading(loadingKey);
        final message = loadingProvider.getLoadingMessage(loadingKey);

        return Stack(
          children: [
            child,
            if (isLoading && showIndicator)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingWidget(),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.loadingKey,
    this.isLoading = false,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final String? loadingKey;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = child;
    bool buttonLoading = isLoading;

    if (loadingKey != null) {
      buttonChild = Consumer<LoadingProvider>(
        builder: (context, loadingProvider, _) {
          buttonLoading = loadingProvider.isLoading(loadingKey!);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (buttonLoading) ...[
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              child,
            ],
          );
        },
      );
    } else if (buttonLoading) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    return ElevatedButton(
      onPressed: (enabled && !buttonLoading) ? onPressed : null,
      child: buttonChild,
    );
  }
}
