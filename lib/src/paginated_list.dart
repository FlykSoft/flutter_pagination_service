class PaginatedList<T> {
  PaginatedList({
    required this.count,
    required this.results,
  });

  final int count;
  final List<T> results;

  factory PaginatedList.empty() => PaginatedList<T>(
        count: 0,
        results: [],
      );

  factory PaginatedList.fromJson(
    final Map<String, dynamic> json,
    final T Function(Map<String, dynamic> json) fromJsonT, {
    String? listKey,
    String? itemCountKey,
  }) {
    final List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(
      json[listKey ?? 'results'] ?? [],
    );

    return PaginatedList<T>(
      count: json[itemCountKey ?? 'maxItemsCount'] ?? 0,
      results: results.map(fromJsonT).toList(),
    );
  }
}
