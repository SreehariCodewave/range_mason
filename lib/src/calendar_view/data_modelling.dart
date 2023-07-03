part of calendar_view;

class CalendarElemet {
  final DateTime dateTime;
  final bool isLeadingOrTrailing;
  final bool isToday;
  CalendarElemet({
    required this.dateTime,
    required this.isLeadingOrTrailing,
    this.isToday = false,
  });
}

enum CalendarElementType {
  isLeadingOrTrailing,
  today,
  selected,
}

enum CalendarMovementType {
  previousMonth,
  nextMonth,
  previousYear,
  nextYear,
}

typedef CalendarViewStateUpdator = void Function(void Function() fn);
typedef CalendarClick = void Function(CalendarElemet calendarElemet);
typedef CalendarHover = void Function(
    CalendarElemet calendarElemet, bool value);
