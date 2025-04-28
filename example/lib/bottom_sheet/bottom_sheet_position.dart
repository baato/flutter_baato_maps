abstract class BottomSheetPosition {
  static BottomSheetPosition hidden = FixedBottomSheetPosition('hidden');
  static BottomSheetPosition collapsed = FixedBottomSheetPosition('collapsed');
  static BottomSheetPosition base = FixedBottomSheetPosition('base');
  static BottomSheetPosition expanded = FixedBottomSheetPosition('expanded');

  static BottomSheetPosition fromTheTop(double value) =>
      FromTheTopPosition(value);
  static BottomSheetPosition fromTheBottom(double value) =>
      FromTheBottomPosition(value);
}

class FixedBottomSheetPosition extends BottomSheetPosition {
  final String name;

  FixedBottomSheetPosition(this.name);

  @override
  String toString() => 'BottomSheetPosition.$name';
}

class FromTheTopPosition extends BottomSheetPosition {
  final double value;

  FromTheTopPosition(this.value);

  @override
  String toString() => 'BottomSheetPosition.fromTheTop($value)';
}

class FromTheBottomPosition extends BottomSheetPosition {
  final double value;

  FromTheBottomPosition(this.value);

  @override
  String toString() => 'BottomSheetPosition.fromTheBottom($value)';
}
