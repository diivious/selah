import 'dart:async';
import 'package:flutter/foundation.dart';
import 'tablet_mode_method_channel.dart';
import 'tablet_mode_platform_interface.dart';
//import 'error_handler.dart';

/// Utility class for detecting tablet mode and device capabilities.
///
/// This class provides a simple API for checking if a device is in tablet mode,
/// has a keyboard attached, or has touch screen capabilities.
class TabletModeDetector {
  static final TabletModePlatform _platform = MethodChannelTabletMode();

  /// Returns true if the device is currently in tablet mode.
  ///
  /// On Windows, this checks if the device is in slate/tablet mode.
  /// On other platforms, this will return false.
  static Future<bool> isTabletMode() {
    return _platform.isTabletMode();
  }

  /// Returns true if a physical keyboard is attached to the device.
  ///
  /// This attempts to detect physical keyboards and returns false for
  /// virtual/on-screen keyboards.
  static Future<bool> isKeyboardAttached() {
    return _platform.isKeyboardAttached();
  }

  /// Returns true if the device has touch screen capability.
  static Future<bool> hasTouchScreen() {
    return _platform.hasTouchScreen();
  }

  /// Returns a stream that emits true when tablet mode is active, false when inactive.
  /// Returns null on platforms that don't support listening for changes.
  static Stream<bool>? get tabletModeChanges {
    return _platform.tabletModeChanges;
  }

  static ValueNotifier<bool> createTabletModeNotifier() {
    // if (kDebugMode) {
    //   debugPrint('Creating tablet mode notifier...');
    // }

    final notifier = _TabletModeNotifier(false);

    // Set initial value
    isTabletMode().then((value) {
      // if (kDebugMode) {
      //   debugPrint('Initial tablet mode set to: $value');
      // }
      notifier.update(value);
    });

    // Listen for changes and update the notifier
    notifier.subscription = tabletModeChanges?.listen(
      (isTablet) {
        // if (kDebugMode) {
        //   debugPrint('Tablet mode stream received update: $isTablet');
        // }
        notifier.update(isTablet);
      },
      onError: (error) {
        // if (kDebugMode) {
        //   debugPrint('Tablet mode notifier error: $error');
        // }
      },
      onDone: () {
        // if (kDebugMode) {
        //   debugPrint('Tablet mode stream completed');
        // }
      },
    );

    // if (kDebugMode) {
    //   debugPrint('Tablet mode notifier created and listening for changes');
    // }

    return notifier;
  }

  static void dispose() {
    _platform.dispose();
  }
}

class _TabletModeNotifier extends ValueNotifier<bool> {
  _TabletModeNotifier(super.value);

  StreamSubscription<bool>? subscription;
  bool _isDisposed = false;

  void update(bool value) {
    if (!_isDisposed) {
      this.value = value;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }
}
