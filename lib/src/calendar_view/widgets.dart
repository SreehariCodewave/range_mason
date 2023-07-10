part of calendar_view;

class CalendarColorScheme {
  final Color todayBorderColor;
  final TextStyle? todayTextStyle;
  final Color selectedColor;
  final TextStyle selectedTextStyle;
  final TextStyle leadingAndTrailingTextStyle;
  final TextStyle? defaulTextStyle;
  final Color selectedRangeColor;
  final TextStyle? selectedRangeTextStyle;
  final Color? possibleSelectionColor;
  final TextStyle? possibleSelectionTextStyle;
  final Color possibleSelectionRangeBorderColor;
  final TextStyle? dayTextStyle;

  const CalendarColorScheme({
    this.todayBorderColor = Colors.blue,
    this.todayTextStyle,
    this.selectedColor = Colors.blue,
    this.selectedTextStyle = const TextStyle(color: Colors.white),
    this.leadingAndTrailingTextStyle = const TextStyle(
      color: Colors.grey,
    ),
    this.defaulTextStyle,
    this.selectedRangeColor = Colors.lightBlue,
    this.selectedRangeTextStyle,
    this.possibleSelectionColor = Colors.lightBlue,
    this.possibleSelectionTextStyle,
    this.possibleSelectionRangeBorderColor = Colors.blue,
    this.dayTextStyle,
  });
}

class CalendarViewWidgets {
  // static Widget dottedBorder(
  //     {required Widget child, Color color = Colors.blue}) {
  //   return DottedBorder(
  //     dashPattern: const [5, 5],
  //     strokeWidth: 0.4,
  //     color: color,
  //     customPath: CalendarViewData.customDottedLinePath,
  //     child: Center(child: child),
  //   );
  // }

  static final CalendarViewWidgets _calendarViewWidgets =
      CalendarViewWidgets._i();

  factory CalendarViewWidgets() => _calendarViewWidgets;

  CalendarViewWidgets._i();

  static late CalendarColorScheme _colorScheme;

  static void setColorScheme(CalendarColorScheme colorScheme) {
    _colorScheme = colorScheme;
  }

  static Widget selectedDate(CalendarElemet calendarElemet,
      {bool isSelectable = false}) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isSelectable
            ? _colorScheme.possibleSelectionColor
            : _colorScheme.selectedColor,
      ),
      margin: const EdgeInsets.all(4),
      child: Center(
          child: Text(
        '${calendarElemet.dateTime.day}',
        style: isSelectable
            ? _colorScheme.possibleSelectionTextStyle
            : _colorScheme.selectedTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }

  static Widget today(CalendarElemet calendarElemet) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _colorScheme.todayBorderColor, width: 1.5),
      ),
      margin: const EdgeInsets.all(4),
      child: Center(
          child: Text(
        '${calendarElemet.dateTime.day}',
        style: _colorScheme.todayTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }

  static Widget activeMonthElement(CalendarElemet calendarElemet) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Center(
          child: Text(
        '${calendarElemet.dateTime.day}',
        style: _colorScheme.defaulTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }

  static Widget inRangeHoverElement(CalendarElemet calendarElemet) {
    return Container(
      height: 24,
      width: 24,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: _colorScheme.possibleSelectionRangeBorderColor,
            width: 0.3,
          ),
          bottom: BorderSide(
            color: _colorScheme.possibleSelectionRangeBorderColor,
            width: 0.3,
          ),
        ),
      ),
      child: Center(
        child: Text(
          '${calendarElemet.dateTime.day}',
          style: _colorScheme.defaulTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget inSelectedRange(CalendarElemet calendarElemet) {
    return Container(
      height: 24,
      width: 24,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: _colorScheme.selectedRangeColor,
      child: Center(
        child: Text(
          '${calendarElemet.dateTime.day}',
          style: _colorScheme.selectedRangeTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget isLeadingOrTrailingElement(CalendarElemet calendarElemet) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Center(
        child: Text(
          '${calendarElemet.dateTime.day}',
          style: _colorScheme.leadingAndTrailingTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget dayDisplay(int index) {
    return SizedBox(
      height: 24,
      width: 24,
      // color: Colors.red,
      child: Center(
          child: Text(
        CalendarViewData.days[index],
        style: _colorScheme.dayTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }
}
