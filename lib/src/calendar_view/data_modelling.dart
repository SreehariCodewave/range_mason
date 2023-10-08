// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class RangeMasonCalendarEvent {
  final DateTime dateTime;
  final TextStyle textStyle;
  final BoxDecoration boxDecoration;

  RangeMasonCalendarEvent({
    required this.dateTime,
    required this.textStyle,
    required this.boxDecoration,
  });
}
