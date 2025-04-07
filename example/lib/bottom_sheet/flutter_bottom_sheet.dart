import 'package:example/bottom_sheet/bottom_sheet_controller.dart';
import 'package:example/bottom_sheet/bottom_sheet_position.dart';
import 'package:example/bottom_sheet/bottom_sheet_type.dart';
import 'package:flutter/material.dart';

class FlutterBottomSheet extends StatefulWidget {
  final Widget body;
  final Widget Function(BuildContext, BottomSheetType) builder;
  final Widget? header;
  final Widget? footer;
  final double elevation;
  final double cornerRadius;
  final Color? color;
  final BottomSheetController? controller;

  const FlutterBottomSheet({
    Key? key,
    required this.body,
    required this.builder,
    this.header,
    this.footer,
    this.elevation = 8.0,
    this.cornerRadius = 16.0,
    this.color,
    this.controller,
  }) : super(key: key);

  @override
  State<FlutterBottomSheet> createState() => _FlutterBottomSheetState();
}

class _FlutterBottomSheetState extends State<FlutterBottomSheet>
    with SingleTickerProviderStateMixin {
  late BottomSheetController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _currentPosition = 1500;
  double _dragStartPosition = 0.0;
  double _dragUpdatePosition = 0.0;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        BottomSheetController(
          bottomSheetType: DefaultBottomSheet(),
          bottomSheetPosition: BottomSheetPosition.base,
        );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _updatePositionFromBottomSheetPosition(
          _controller.bottomSheetPosition.value,
        );
      });
    });

    _animation = Tween<double>(
      begin: _currentPosition,
      end: _currentPosition,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animation.addListener(() {
      setState(() {
        _currentPosition = _animation.value;
      });
    });

    _controller.bottomSheetPosition.addListener(_onPositionChanged);
  }

  void _updatePositionFromBottomSheetPosition(BottomSheetPosition position) {
    double screenHeight = MediaQuery.of(context).size.height;
    double adjustedHeight =
        screenHeight - MediaQuery.of(context).viewInsets.bottom;

    if (position == BottomSheetPosition.hidden) {
      _currentPosition = screenHeight;
    } else if (position == BottomSheetPosition.collapsed) {
      _currentPosition = screenHeight - (screenHeight * 0.1);
    } else if (position == BottomSheetPosition.base) {
      _currentPosition = screenHeight - (screenHeight * 0.3);
    } else if (position == BottomSheetPosition.expanded) {
      _currentPosition = 80;
    } else if (position is FromTheTopPosition) {
      _currentPosition = position.value;
    } else if (position is FromTheBottomPosition) {
      _currentPosition = screenHeight - position.value;
    }

    print(_currentPosition);
  }

  void _onPositionChanged() {
    snapToPosition(_controller.bottomSheetPosition.value);
  }

  @override
  void dispose() {
    _controller.bottomSheetPosition.removeListener(_onPositionChanged);
    _animationController.dispose();
    super.dispose();
  }

  void snapToPosition(BottomSheetPosition position) {
    double targetPosition = MediaQuery.of(context).size.height;

    if (position == BottomSheetPosition.hidden) {
      targetPosition = MediaQuery.of(context).size.height;
    } else if (position == BottomSheetPosition.collapsed) {
      targetPosition =
          MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height * 0.1);
    } else if (position == BottomSheetPosition.base) {
      targetPosition =
          MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height * 0.3);
    } else if (position == BottomSheetPosition.expanded) {
      targetPosition = 80;
    } else if (position is FromTheTopPosition) {
      targetPosition = position.value;
    } else if (position is FromTheBottomPosition) {
      targetPosition = MediaQuery.of(context).size.height - position.value;
    }

    _animation = Tween<double>(
      begin: _currentPosition,
      end: targetPosition,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.reset();
    _animationController.forward();
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartPosition = details.globalPosition.dy;
    _dragUpdatePosition = _currentPosition;
    _animationController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;
    final delta =
        (_dragStartPosition - details.globalPosition.dy) / screenHeight;

    setState(() {
      _currentPosition = (_dragUpdatePosition + delta).clamp(
        80, // Minimum height for expanded position
        screenHeight, // Maximum height when hidden
      );
    });
  }

  void _onDragEnd(DragEndDetails details) {
    double screenHeight = MediaQuery.of(context).size.height;
    BottomSheetPosition targetPosition;

    if (_currentPosition <= 80 + (screenHeight * 0.1)) {
      targetPosition = BottomSheetPosition.expanded;
    } else if (_currentPosition <= screenHeight - (screenHeight * 0.3)) {
      targetPosition = BottomSheetPosition.base;
    } else {
      targetPosition = BottomSheetPosition.collapsed;
    }

    _controller.snapToPosition(targetPosition);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeight = screenHeight - _currentPosition;

    return Stack(
      children: [
        // Body content
        widget.body,

        // Bottom sheet
        Positioned(
          left: 0,
          right: 0,
          top: _currentPosition,
          height: sheetHeight,
          child: GestureDetector(
            onVerticalDragStart: _onDragStart,
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: _onDragEnd,
            child: Material(
              elevation: widget.elevation,
              color: widget.color ?? Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.cornerRadius),
                topRight: Radius.circular(widget.cornerRadius),
              ),
              child: Column(
                children: [
                  // Header
                  if (widget.header != null) widget.header!,

                  // Content
                  Expanded(
                    child: ValueListenableBuilder<BottomSheetType>(
                      valueListenable: _controller.bottomSheetType,
                      builder: (context, type, _) {
                        return widget.builder(context, type);
                      },
                    ),
                  ),

                  // Footer
                  if (widget.footer != null) widget.footer!,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
