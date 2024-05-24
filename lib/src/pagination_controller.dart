import 'dart:async';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pagination_service/src/paginated_list.dart';
import 'package:pagination_service/src/pagination_dto.dart';

///T is the type of the entity you want to paginate
class PaginationController<T> extends PagingController<int, T> {
  PaginationDto _dto;
  PaginatedList<T>? _paginatedList;
  bool _refreshInBackground = false;
  Completer<void> _refreshCompleter = Completer<void>();
  bool isInitialized = false;

  PaginationController({
    final int page = PaginationDto.firstPage,
    final int offset = PaginationDto.defaultPaginationOffset,
  })  : _dto = PaginationDto(
          page: page,
          offset: offset,
        ),
        _paginatedList = null,
        super(firstPageKey: PaginationDto.firstPage);

  void init(final PageRequestListener<int> onRequest) {
    addPageRequestListener(onRequest);
    isInitialized = true;
  }

  void maybeInit(final PageRequestListener<int> onRequest) =>
      isInitialized ? null : init(onRequest);

  @override
  Future<void> refresh({
    bool refreshInBackground = false,
  }) async {
    _refreshCompleter = Completer<void>();
    _dto.resetPage();
    _refreshInBackground = refreshInBackground;
    if (_refreshInBackground) {
      notifyPageRequestListeners(firstPageKey);
    } else {
      super.refresh();
    }
    return _refreshCompleter.future;
  }

  void failure(final String errorMessage) {
    error = errorMessage;
    _refreshCompleter.completeError(error);
  }

  void insertData(final PaginatedList<T> data) {
    _paginatedList = data;
    if (_hasMoreData) {
      _dto.page += 1;
      appendPage(data.results, _dto.page);
    } else {
      appendLastPage(data.results);
    }
  }

  @override
  void appendPage(List<T> newItems, int? nextPageKey) {
    final List<T> previousItems =
        _refreshInBackground ? [] : value.itemList ?? [];
    final List<T> itemList = [
      ...previousItems,
      ...newItems,
    ];
    value = PagingState<int, T>(
      itemList: itemList,
      error: null,
      nextPageKey: nextPageKey,
    );
    _refreshInBackground = false;
    if (!_refreshCompleter.isCompleted) {
      _refreshCompleter.complete();
    }
  }

  @override
  void appendLastPage(List<T> newItems) {
    super.appendLastPage(newItems);
    _refreshInBackground = false;
    if (!_refreshCompleter.isCompleted) {
      _refreshCompleter.complete();
    }
  }

  int get count => _paginatedList?.count ?? 0;

  bool get _hasMoreData =>
      _paginatedList == null || _paginatedList!.count > items.length;

  List<T> get items => value.itemList ?? [];

  PaginationDto get nextDto => _dto.copyWith(page: _dto.page + 1);

  set dto(PaginationDto dto) => _dto = dto;
}
