part of calendar_view;

class CalendarViewController {
  late List<List<CalendarElemet?>> _monthArr;

  late DateTime _displayMonth;

  DateTime? _selectedDate;

  CalendarViewStateUpdator? _calendarViewStateUpdator;

  CalendarClick? _onClick;
  CalendarHover? _onHover;

  late bool _rangeSelectionMode;

  DateTime? _rangeStartDate;
  DateTime? _rangeEndDate;

  // for single date selection mode
  DateTime? _selectableHover;
  DateTime? _singleDateSelectionDate;

  DateTime? _hoverEndRange;

  DateTime? get hoverEnd => _hoverEndRange;

  final String id;

  CalendarViewController({
    bool enableRangeSelectionMode = false,
    int initialFocusDifferenceMonths = 0,
    int initialFocusDifferenceYears = 0,
    required this.id,
  }) {
    _rangeSelectionMode = enableRangeSelectionMode;
    DateTime now = DateTime.now();
    _displayMonth = DateTime(
      now.year + initialFocusDifferenceYears,
      now.month + initialFocusDifferenceMonths,
    );
    _generateMonthArr();
  }

  void _init(
    CalendarViewStateUpdator fn,
    CalendarClick? onClick,
    CalendarHover? onHover,
  ) {
    _calendarViewStateUpdator = fn;
    _onClick = onClick;
    _onHover = onHover;
  }

  DateTime? get selectedDate => _selectedDate;

  DateTime? get displayDate => _displayMonth;

  void selectStartRange(DateTime? dateTime, {bool refresh = false}) {
    _rangeStartDate = dateTime;
    if (refresh) this.refresh(regenrateMonthArr: false);
  }

  void selectEndRange(DateTime? dateTime, {bool refresh = false}) {
    _rangeEndDate = dateTime;
    if (refresh) this.refresh(regenrateMonthArr: false);
  }

  void selectableHover(DateTime? dateTime) {
    _selectableHover = dateTime;
    refresh(regenrateMonthArr: false);
  }

  void selectSingleDate(DateTime? dateTime) {
    _singleDateSelectionDate = dateTime;
    refresh(regenrateMonthArr: false);
  }

  void setHoverEndRange(DateTime? dateTime) {
    _hoverEndRange = dateTime;
    refresh(regenrateMonthArr: false);
  }

  void clearRange({bool refresh = false}) {
    _rangeStartDate = null;
    _rangeEndDate = null;
    if (refresh) this.refresh(regenrateMonthArr: false);
  }

  void selectDate(DateTime dateTime) {
    _selectedDate = dateTime;
    refresh(regenrateMonthArr: false);
  }

  void previousMonth() {
    _displayMonth = _displayMonth.subtractAMonth();
    refresh();
  }

  void nextMonth() {
    _displayMonth = _displayMonth.addAMonth();
    refresh();
  }

  void previousYear() {
    _displayMonth = _displayMonth.subtractAYear();
    refresh();
  }

  void nextYear() {
    _displayMonth = _displayMonth.addAYear();
    refresh();
  }

  void changeFocus(DateTime dateTime) {
    _displayMonth = dateTime;
    refresh();
  }

  void refresh({bool regenrateMonthArr = true}) {
    if (regenrateMonthArr) _generateMonthArr();
    _calendarViewStateUpdator?.call(() {});
  }

  void _generateMonthArr() {
    DateTime firstDayOfTheMonth =
        DateTime(_displayMonth.year, _displayMonth.month, 1);
    int weekdayIdx = firstDayOfTheMonth.weekday;
    _monthArr = List.generate(6, (i) => List.generate(7, (index) => null));
    DateTime tmpDate = _displayMonth;
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 7; j++) {
        if (i == 0 && j < weekdayIdx) {
          _monthArr[i][j] = CalendarElemet(
            dateTime: tmpDate.subtract(Duration(days: weekdayIdx - j)),
            isLeadingOrTrailing: true,
          );

          continue;
        }
        _monthArr[i][j] = CalendarElemet(
          dateTime: tmpDate,
          isLeadingOrTrailing: tmpDate.month > firstDayOfTheMonth.month,
          isToday: _isEqual(tmpDate, DateTime.now()),
        );

        tmpDate = tmpDate.add(const Duration(days: 1));
      }
    }
  }

  Widget _buildMonthElemet(int index) {
    if (index < 7) {
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

    ({int i, int j}) indices = _extractIndices(index);

    CalendarElemet curr = _monthArr[indices.i - 1][indices.j]!;

    return InkWell(
      onTap: () {
        _onClick?.call(curr);
      },
      onHover: (value) {
        _onHover?.call(curr, value);
      },
      child: _containerElement(curr),
    );
  }

  Widget _containerElement(CalendarElemet calendarElemet) {
    DateTime dateTime = calendarElemet.dateTime;
    if (calendarElemet.isLeadingOrTrailing) {
      return CalendarViewWidgets.isLeadingOrTrailingElement(calendarElemet);
    }

    if (!_rangeSelectionMode && _isEqual(dateTime, _singleDateSelectionDate)) {
      return CalendarViewWidgets.selectedDate(calendarElemet);
    }

    if (!_rangeSelectionMode && _isEqual(dateTime, _selectableHover)) {
      return CalendarViewWidgets.selectedDate(
        calendarElemet,
        isSelectable: true,
      );
    }

    if (_rangeSelectionMode &&
        (_isEqual(dateTime, _rangeStartDate) ||
            _isEqual(dateTime, _rangeEndDate))) {
      return CalendarViewWidgets.selectedDate(calendarElemet);
    }

    if (selectedDate != null && _isEqual(dateTime, selectedDate)) {
      return CalendarViewWidgets.selectedDate(calendarElemet);
    }

    if (calendarElemet.isToday) {
      return CalendarViewWidgets.today(calendarElemet);
    }

    if (_rangeSelectionMode &&
        _rangeEndDate != null &&
        _rangeEndDate != null &&
        _isDateTimeInRange(
            _rangeStartDate!, _rangeEndDate!, calendarElemet.dateTime)) {
      return CalendarViewWidgets.inSelectedRange(calendarElemet);
    }

    if (_hoverEndRange != null && _rangeStartDate != null) {
      DateTime hoverStart = _rangeStartDate!;
      if (_rangeEndDate != null) {
        int nearest = _findNearestDateTime(
            _rangeStartDate!, _rangeEndDate!, calendarElemet.dateTime);
        if (nearest == 1) {
          hoverStart = _rangeEndDate!;
        }
      }

      if (_isDateTimeInRange(
          _hoverEndRange!, hoverStart, calendarElemet.dateTime)) {
        return CalendarViewWidgets.inRangeHoverElement(calendarElemet);
      }

      if (_isEqual(_hoverEndRange, calendarElemet.dateTime)) {
        return CalendarViewWidgets.selectedDate(calendarElemet,
            isSelectable: true);
      }
    }

    return CalendarViewWidgets.activeMonthElement(calendarElemet);
  }

  ({int i, int j}) _extractIndices(int index) {
    return (i: index ~/ 7, j: index % 7);
  }

  bool _isEqual(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return (a.year == b.year) && (a.month == b.month) && (a.day == b.day);
  }

  bool _isDateTimeInRange(DateTime A, DateTime B, DateTime X) {
    DateTime minDateTime = A.isBefore(B) ? A : B;
    DateTime maxDateTime = A.isBefore(B) ? B : A;

    return X.isAfter(minDateTime) && X.isBefore(maxDateTime);
  }

  int _findNearestDateTime(DateTime A, DateTime B, DateTime X) {
    Duration differenceA = A.difference(X).abs();
    Duration differenceB = B.difference(X).abs();

    if (differenceA < differenceB) {
      return 0;
    } else {
      return 1;
    }
  }
}
