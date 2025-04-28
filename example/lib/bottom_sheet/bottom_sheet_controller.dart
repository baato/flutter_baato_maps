import 'package:example/bottom_sheet/bottom_sheet_position.dart';
import 'package:example/bottom_sheet/bottom_sheet_type.dart';
import 'package:flutter/material.dart';

class BottomSheetController {
  late ValueNotifier<BottomSheetType> _bottomSheetType;
  late ValueNotifier<BottomSheetPosition> _bottomSheetPosition;

  ValueNotifier<BottomSheetType> get bottomSheetType => _bottomSheetType;
  ValueNotifier<BottomSheetPosition> get bottomSheetPosition =>
      _bottomSheetPosition;

  BottomSheetController({
    BottomSheetType? bottomSheetType,
    BottomSheetPosition? bottomSheetPosition,
  }) {
    _bottomSheetType = ValueNotifier<BottomSheetType>(
      bottomSheetType ?? DefaultBottomSheet(),
    );
    _bottomSheetPosition = ValueNotifier<BottomSheetPosition>(
      bottomSheetPosition ?? BottomSheetPosition.base,
    );
  }

  void snapToPosition(BottomSheetPosition position) {
    _bottomSheetPosition.value = position;
  }

  void updateBottomSheetType(BottomSheetType type) {
    _bottomSheetType.value = type;
  }
}
