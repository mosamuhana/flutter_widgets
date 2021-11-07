import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'list_controller.dart';
import 'myers_diff.dart';
import 'diff_applier.dart';

class AnimatedStreamList<E> extends StatefulWidget {
  final Stream<List<E>> streamList;
  final AnimatedStreamListItemBuilder<E> itemBuilder;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final bool shrinkWrap;
  final Duration duration;

  final List<E>? initialList;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsetsGeometry? padding;
  final Equalizer? equals;

  const AnimatedStreamList({
    Key? key,
    required this.streamList,
    required this.itemBuilder,
    required this.itemRemovedBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.shrinkWrap = false,
    this.duration = const Duration(milliseconds: 300),
    this.initialList,
    this.scrollController,
    this.primary,
    this.scrollPhysics,
    this.padding,
    this.equals,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedStreamListState<E>();
}

class _AnimatedStreamListState<E> extends State<AnimatedStreamList<E>> with WidgetsBindingObserver {
  final _globalKey = GlobalKey<AnimatedListState>();
  late ListController<E> _listController;
  late DiffApplier<E> _diffApplier;
  late DiffUtil<E> _diffUtil;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _listController = ListController(
      key: _globalKey,
      items: widget.initialList ?? <E>[],
      itemRemovedBuilder: widget.itemRemovedBuilder,
      duration: widget.duration,
    );

    _diffApplier = DiffApplier(_listController);
    _diffUtil = DiffUtil();

    startListening();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  void startListening() {
    _subscription?.cancel();
    _subscription = widget.streamList
        .asyncExpand(
          (list) => _diffUtil
              .calculateDiff(_listController.items, list, equalizer: widget.equals)
              .then(_diffApplier.applyDiffs)
              .asStream(),
        )
        .listen((list) {});
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        startListening();
        break;
      case AppLifecycleState.paused:
        stopListening();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      initialItemCount: _listController.items.length,
      key: _globalKey,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      primary: widget.primary,
      controller: widget.scrollController,
      physics: widget.scrollPhysics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) =>
          widget.itemBuilder(context, _listController[index], index, animation),
    );
  }
}
