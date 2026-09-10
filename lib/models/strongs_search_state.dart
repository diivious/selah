import 'dart:convert';

/// Represents a complete snapshot of the Strongs search screen state.
/// Used for state preservation when navigating away and restoration when returning.
class StrongsSearchState {
  final String searchTerm;
  final String? searchType; // 'strongs', 'word', or 'reference'
  final List<Map<String, dynamic>> searchResults;
  final Map<String, Map<String, dynamic>> foundStrongsNumbers;
  final Map<String, int> phraseSummary;
  final int? totalMatches;
  final int? totalVerses;
  final double scrollOffset;

  StrongsSearchState({
    required this.searchTerm,
    required this.searchType,
    required this.searchResults,
    required this.foundStrongsNumbers,
    required this.phraseSummary,
    required this.totalMatches,
    required this.totalVerses,
    required this.scrollOffset,
  });

  /// Serializes the state to JSON for storage in SharedPreferences
  String toJson() {
    return jsonEncode({
      'searchTerm': searchTerm,
      'searchType': searchType,
      'searchResults': searchResults,
      'foundStrongsNumbers': foundStrongsNumbers,
      'phraseSummary': phraseSummary,
      'totalMatches': totalMatches,
      'totalVerses': totalVerses,
      'scrollOffset': scrollOffset,
    });
  }

  /// Deserializes a state from JSON
  static StrongsSearchState? fromJson(String json) {
    try {
      final Map<String, dynamic> data = jsonDecode(json);
      return StrongsSearchState(
        searchTerm: data['searchTerm'] as String? ?? '',
        searchType: data['searchType'] as String?,
        searchResults:
            List<Map<String, dynamic>>.from(data['searchResults'] as List? ?? []),
        foundStrongsNumbers: Map<String, Map<String, dynamic>>.from(
          (data['foundStrongsNumbers'] as Map? ?? {})
              .cast<String, Map<String, dynamic>>(),
        ),
        phraseSummary: Map<String, int>.from(
          (data['phraseSummary'] as Map? ?? {}).cast<String, int>(),
        ),
        totalMatches: data['totalMatches'] as int?,
        totalVerses: data['totalVerses'] as int?,
        scrollOffset: (data['scrollOffset'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      return null;
    }
  }

  /// Creates a copy of this state with specified fields replaced
  StrongsSearchState copyWith({
    String? searchTerm,
    String? searchType,
    List<Map<String, dynamic>>? searchResults,
    Map<String, Map<String, dynamic>>? foundStrongsNumbers,
    Map<String, int>? phraseSummary,
    int? totalMatches,
    int? totalVerses,
    double? scrollOffset,
  }) {
    return StrongsSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
      searchType: searchType ?? this.searchType,
      searchResults: searchResults ?? this.searchResults,
      foundStrongsNumbers: foundStrongsNumbers ?? this.foundStrongsNumbers,
      phraseSummary: phraseSummary ?? this.phraseSummary,
      totalMatches: totalMatches ?? this.totalMatches,
      totalVerses: totalVerses ?? this.totalVerses,
      scrollOffset: scrollOffset ?? this.scrollOffset,
    );
  }

  @override
  String toString() =>
      'StrongsSearchState(term: $searchTerm, type: $searchType, matches: $totalMatches, verses: $totalVerses, offset: $scrollOffset)';
}
