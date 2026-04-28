import 'dart:async';

class DebounceUtils {
  static Function? _lastAction;
  static DateTime? _lastActionTime;
  static const Duration _debounceTime = Duration(milliseconds: 500);

  static void run(Function action) {
    final now = DateTime.now();
    
    // If same action was called recently, ignore it
    if (_lastAction == action && 
        _lastActionTime != null && 
        now.difference(_lastActionTime!) < _debounceTime) {
      return;
    }
    
    _lastAction = action;
    _lastActionTime = now;
    
    // Execute action after debounce delay
    Future.delayed(_debounceTime, () {
      if (_lastAction == action) {
        action();
      }
    });
  }

  static void reset() {
    _lastAction = null;
    _lastActionTime = null;
  }
}
