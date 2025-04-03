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

  double _currentPosition = 0.0;
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

    _updatePositionFromBottomSheetPosition(
      _controller.bottomSheetPosition.value,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

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
    if (position == BottomSheetPosition.hidden) {
      _currentPosition = 0.0;
    } else if (position == BottomSheetPosition.collapsed) {
      _currentPosition = 0.1; // Just enough to show the header
    } else if (position == BottomSheetPosition.base) {
      _currentPosition = 0.3; // Show header and part of the body
    } else if (position == BottomSheetPosition.expanded) {
      _currentPosition = 0.9; // Expanded but leaving 60px from top of safe area
    } else if (position is FromTheTopPosition) {
      _currentPosition =
          1.0 - (position.value / MediaQuery.of(context).size.height);
    } else if (position is FromTheBottomPosition) {
      _currentPosition = position.value / MediaQuery.of(context).size.height;
    }
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
    double targetPosition;

    if (position == BottomSheetPosition.hidden) {
      targetPosition = 0.0;
    } else if (position == BottomSheetPosition.collapsed) {
      targetPosition = 0.1;
    } else if (position == BottomSheetPosition.base) {
      targetPosition = 0.3;
    } else if (position == BottomSheetPosition.expanded) {
      targetPosition = 0.9;
    } else if (position is FromTheTopPosition) {
      targetPosition =
          1.0 - (position.value / MediaQuery.of(context).size.height);
    } else if (position is FromTheBottomPosition) {
      targetPosition = position.value / MediaQuery.of(context).size.height;
    } else {
      targetPosition = 0.3; // Default to base
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
      _currentPosition = (_dragUpdatePosition + delta).clamp(0.0, 0.9);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    BottomSheetPosition targetPosition;

    if (_currentPosition < 0.05) {
      targetPosition = BottomSheetPosition.hidden;
    } else if (_currentPosition < 0.2) {
      targetPosition = BottomSheetPosition.collapsed;
    } else if (_currentPosition < 0.6) {
      targetPosition = BottomSheetPosition.base;
    } else {
      targetPosition = BottomSheetPosition.expanded;
    }

    _controller.snapToPosition(targetPosition);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final sheetHeight = screenHeight * _currentPosition;

    return Stack(
      children: [
        // Body content
        widget.body,

        // Bottom sheet
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
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
