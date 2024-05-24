class PaginationDto {
  static const int firstPage = 0;
  static const int serverFirstPage = 1;
  static const int defaultPaginationOffset = 15;
  final int offset;
  int page;

  PaginationDto({
    this.offset = defaultPaginationOffset,
    this.page = firstPage,
  });

  factory PaginationDto.onInit({
    int offset = defaultPaginationOffset,
    int page = serverFirstPage,
  }) =>
      PaginationDto(
        offset: offset,
        page: page,
      );

  PaginationDto copyWith({
    final int? offset,
    final int? page,
  }) =>
      PaginationDto(
        offset: offset ?? this.offset,
        page: page ?? this.page,
      );

  void resetPage() => page = firstPage;

  Map<String, dynamic> toJson({
    String? pageKey,
    String? offsetKey,
  }) =>
      {
        (pageKey ?? 'page'): page,
        (offsetKey ?? 'itemCount'): offset,
      };
}
