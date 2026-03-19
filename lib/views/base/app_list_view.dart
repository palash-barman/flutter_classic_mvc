import 'package:flutter/material.dart';
import 'package:demo_project/views/base/empty_widget.dart';
import 'package:demo_project/views/base/error_widget.dart';
import 'package:demo_project/views/base/loading_widget.dart';

class AppListView<T> extends StatefulWidget {
  final List<T> items;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;

  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final bool hasError;
  final String? errorMessage;

  final EdgeInsetsGeometry? padding;

  final Widget Function(T item)? item;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget Function(String message, VoidCallback onRetry)? errorWidget;

  /// Optional params with default values
  final bool reverse;       // default false
  final bool shrinkWrap;    // default false

  const AppListView({
    super.key,
    required this.items,
    this.item,
    this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = true,
    this.hasError = false,
    this.errorMessage,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
    this.reverse = false,
    this.shrinkWrap = false,
    this.padding,
  }) : assert(item != null || itemBuilder != null,
            "Provide either item or itemBuilder");

  @override
  State<AppListView<T>> createState() => _AppListViewState<T>();
}

class _AppListViewState<T> extends State<AppListView<T>> {
  final ScrollController _controller = ScrollController();
  bool _isCalling = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() async {
      if (widget.reverse) {
        if (_controller.position.pixels <= 200 &&
            !_isCalling &&
            widget.hasMore &&
            !widget.isLoadMore) {
          _isCalling = true;
          await widget.onLoadMore?.call();
          _isCalling = false;
        }
      } else {
        if (_controller.position.pixels >=
                _controller.position.maxScrollExtent - 200 &&
            !_isCalling &&
            widget.hasMore &&
            !widget.isLoadMore) {
          _isCalling = true;
          await widget.onLoadMore?.call();
          _isCalling = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Loading
    if (widget.isLoading && widget.items.isEmpty) {
      return widget.loadingWidget ?? const LoadingWidget();
    }

    /// Error
    if (widget.hasError && widget.items.isEmpty) {
      return widget.errorWidget != null
          ? widget.errorWidget!(
              widget.errorMessage ?? "Something went wrong",
              () => widget.onRefresh?.call(),
            )
          : AppErrorWidget(
              message: widget.errorMessage ?? "Something went wrong",
              onRetry: widget.onRefresh,
            );
    }

    /// Empty
    if (widget.items.isEmpty) {
      return widget.emptyWidget ?? const EmptyWidget(message: "No Data Found");
    }

    /// List
    return RefreshIndicator(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.builder(
        controller: _controller,
        reverse: widget.reverse,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding ?? const EdgeInsets.all(16),
        physics: widget.shrinkWrap
            ? const NeverScrollableScrollPhysics() // scroll handled by parent
            : const AlwaysScrollableScrollPhysics(),
        itemCount: widget.items.length + (widget.isLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < widget.items.length) {
            final data = widget.items[index];
            if (widget.item != null) return widget.item!(data);
            return widget.itemBuilder!(context, data, index);
          }

          /// Pagination loader
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}