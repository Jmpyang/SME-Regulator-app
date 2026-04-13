import 'dart:async';
import 'package:flutter/material.dart';

class PerformanceUtils {
  static const Duration _debounceDelay = Duration(milliseconds: 300);
  static const Duration _throttleDelay = Duration(milliseconds: 100);

  static VoidCallback debounce(VoidCallback callback) {
    Timer? timer;
    return () {
      if (timer != null) timer!.cancel();
      timer = Timer(_debounceDelay, callback);
    };
  }

  static VoidCallback throttle(VoidCallback callback) {
    bool isThrottled = false;
    return () {
      if (!isThrottled) {
        callback();
        isThrottled = true;
        Timer(_throttleDelay, () => isThrottled = false);
      }
    };
  }

  static Widget cachedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? const SizedBox.shrink();
      },
      errorBuilder: (context, error, stackTrace) {
        return placeholder ?? const Icon(Icons.error);
      },
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }

  static Widget optimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    EdgeInsets? padding,
    bool shrinkWrap = false,
  }) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      cacheExtent: 250.0,
    );
  }

  static Widget optimizedGridView({
    required int itemCount,
    required SliverGridDelegate gridDelegate,
    required Widget Function(BuildContext, int) itemBuilder,
    EdgeInsets? padding,
    bool shrinkWrap = false,
  }) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      itemBuilder: itemBuilder,
      cacheExtent: 250.0,
    );
  }
}

class OptimizedScrollBehavior extends ScrollBehavior {
  const OptimizedScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const BouncingScrollPhysics();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
      default:
        return const ClampingScrollPhysics();
    }
  }
}

class MemoryEfficientBuilder extends StatefulWidget {
  final Widget Function(BuildContext) builder;

  const MemoryEfficientBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<MemoryEfficientBuilder> createState() => _MemoryEfficientBuilderState();
}

class _MemoryEfficientBuilderState extends State<MemoryEfficientBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
