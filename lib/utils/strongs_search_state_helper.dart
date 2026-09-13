import 'package:shared_preferences/shared_preferences.dart';
import '../models/strongs_search_state.dart';

/// Helper class for managing the Strongs search state stack in SharedPreferences.
/// Provides methods to push/pop/peek state snapshots for dialog-based search navigation.
class StrongsSearchStateHelper {
  static const String _stateStackKey = 'strongsSearchStateStack';
  static const int _maxStackDepth = 10; // Prevent unbounded growth

  /// Pushes a search state onto the stack for later restoration
  static Future<void> pushState(StrongsSearchState state) async {
    final prefs = await SharedPreferences.getInstance();
    final stackJson = prefs.getStringList(_stateStackKey) ?? [];

    // Prevent unbounded growth by limiting stack depth
    if (stackJson.length >= _maxStackDepth) {
      stackJson.removeAt(0); // Remove oldest state
    }

    stackJson.add(state.toJson());
    await prefs.setStringList(_stateStackKey, stackJson);
  }

  /// Pops and returns the most recent state from the stack
  static Future<StrongsSearchState?> popState() async {
    final prefs = await SharedPreferences.getInstance();
    final stackJson = prefs.getStringList(_stateStackKey) ?? [];

    if (stackJson.isEmpty) {
      return null;
    }

    final lastJson = stackJson.removeLast();
    await prefs.setStringList(_stateStackKey, stackJson);

    return StrongsSearchState.fromJson(lastJson);
  }

  /// Returns the most recent state from the stack without removing it
  // static Future<StrongsSearchState?> peekState() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final stackJson = prefs.getStringList(_stateStackKey) ?? [];

  //   if (stackJson.isEmpty) {
  //     return null;
  //   }

  //   return StrongsSearchState.fromJson(stackJson.last);
  // }

  // /// Clears the entire state stack
  // static Future<void> clearStack() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_stateStackKey);
  // }

  // /// Returns the current stack depth
  // static Future<int> getStackDepth() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final stackJson = prefs.getStringList(_stateStackKey) ?? [];
  //   return stackJson.length;
  // }
}
