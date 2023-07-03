part of calendar_view;

class CalendarViewData {
  static final List<String> days = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  static const String singleArrowImage = 'assets/single-arrow.svg';
  static const String doublerrowImage = 'assets/double-arrow.svg';

  static Path customDottedLinePath(Size size) => Path()
    ..moveTo(0, 4)
    ..lineTo(size.width - 4, 4)
    ..moveTo(size.width - 4, size.height - 4)
    ..lineTo(0, size.height - 4);

  static const List<int> dashPattern = [4, 4];
}
