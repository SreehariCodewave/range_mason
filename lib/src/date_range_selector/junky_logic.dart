part of date_range_selector;

extension JunkyLogic on RangeSelectorLogic {
  void junkyMovementLogic(CalendarMovementType calendarMovementType,
      bool isStartCalendar, CalendarViewController controller) {
    switch (calendarMovementType) {
      case CalendarMovementType.previousMonth:
        // there are no restictions for previous month movement for start calendar
        // but for end calendar the back movement is allowed only when it doesn't overlap with the start calendar
        if (isStartCalendar ||
            !(_isSimilarFocus(startController.displayDate,
                endController.displayDate!.subtractAMonth()))) {
          controller.previousMonth();
        }
        break;
      case CalendarMovementType.nextMonth:
        // same as previous month just the opposite
        if (!isStartCalendar ||
            !(_isSimilarFocus(startController.displayDate!.addAMonth(),
                endController.displayDate))) {
          controller.nextMonth();
        }
        break;
      case CalendarMovementType.previousYear:
        // free movement if the controller is for start calendar
        if (isStartCalendar) {
          controller.previousYear();
        } else if (_isSimilarFocus(startController.displayDate,
            endController.displayDate!.subtractAYear())) {
          // if previous year for end calendar results in same focus month as start
          // then we append the end calendar by a month
          DateTime tmp = DateTime(controller.displayDate!.year - 1,
              controller.displayDate!.month + 1);
          controller.changeFocus(tmp);
        } else if (!_aLesserThanBFocus(
            DateTime(controller.displayDate!.year - 1,
                controller.displayDate!.month),
            startController.displayDate)) {
          // if the previous year movement for the end calendar is valid, and doesn't go before
          // the start calendart then we just go back a year
          controller.previousYear();
        } else {
          // if on click of previous year, the end calendar focuses on date before the start calendar
          // we just focus the end calendar focus to the next month of start calendar
          controller.changeFocus(DateTime(startController.displayDate!.year,
              startController.displayDate!.month + 1));
        }

        break;
      case CalendarMovementType.nextYear:
        // exact opposite of the prev year logic
        if (!isStartCalendar) {
          controller.nextYear();
        } else if (_isSimilarFocus(startController.displayDate!.addAYear(),
            endController.displayDate)) {
          DateTime tmp = DateTime(controller.displayDate!.year + 1,
              controller.displayDate!.month - 1);
          controller.changeFocus(tmp);
        } else if (_aLesserThanBFocus(
            DateTime(controller.displayDate!.year + 1,
                controller.displayDate!.month),
            endController.displayDate)) {
          controller.nextYear();
        } else {
          controller.changeFocus(DateTime(endController.displayDate!.year,
              endController.displayDate!.month - 1));
        }
        break;
    }
  }

  bool _isSimilarFocus(DateTime? a, DateTime? b) =>
      ((a != null && b != null) && (a.year == b.year) && (a.month == b.month));

  bool _aLesserThanBFocus(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return (((a.year < b.year) || ((a.year == b.year) && (a.month < b.month))));
  }

  void updateEndRange(CalendarElemet ele, CalendarViewController c) {
    endRange = ele.dateTime;
    if (startRange!.isAfter(endRange!)) {
      endRange = startRange;
      startRange = ele.dateTime;
      startController.selectStartRange(startRange);
      endController.selectStartRange(startRange);
    }

    startController.selectEndRange(endRange, refresh: true);
    endController.selectEndRange(endRange, refresh: true);
    swapDateTimeIfNeeded(startRange!, endRange!);
  }

  void updateStartRange(CalendarElemet ele, CalendarViewController c) {
    startRange = ele.dateTime;
    startController.selectStartRange(startRange, refresh: true);
    endController.selectStartRange(startRange, refresh: true);
  }

  int findNearestDateTime(DateTime A, DateTime B, DateTime X) {
    Duration differenceA = A.difference(X).abs();
    Duration differenceB = B.difference(X).abs();

    if (differenceA < differenceB) {
      return 0;
    } else {
      return 1;
    }
  }

  void swapDateTimeIfNeeded(DateTime A, DateTime B) {
    if (A.isAfter(B)) {
      DateTime temp = A;
      A = B;
      B = temp;
    }
  }
}
