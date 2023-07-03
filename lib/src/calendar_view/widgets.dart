part of calendar_view;

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

  static Widget selectedDate(CalendarElemet calendarElemet,
      {bool isSelectable = false}) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isSelectable ? Colors.blue.shade100 : Colors.blue,
      ),
      margin: const EdgeInsets.all(4),
      child: Center(
          child: Text(
        '${calendarElemet.dateTime.day}',
        style: const TextStyle(color: Colors.white),
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
        border: Border.all(color: Colors.blue),
      ),
      margin: const EdgeInsets.all(4),
      child: Center(
          child: Text(
        '${calendarElemet.dateTime.day}',
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
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.blue, width: 0.3),
          bottom: BorderSide(color: Colors.blue, width: 0.3),
        ),
      ),
      child: Center(
        child: Text(
          '${calendarElemet.dateTime.day}',
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
      color: Colors.blue.shade100,
      child: Center(
        child: Text(
          '${calendarElemet.dateTime.day}',
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
          style: const TextStyle(
            color: Colors.grey,
          ),
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
    );
  }
}
