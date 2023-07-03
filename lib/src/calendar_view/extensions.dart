part of calendar_view;

extension DateTimeExtension on DateTime {
  DateTime subtractAMonth() {
    if (month <= 1) {
      return DateTime(year - 1, 12);
    }
    return DateTime(year, month - 1);
  }

  DateTime addAMonth() {
    if (month >= 12) {
      return DateTime(year + 1, 1);
    }
    return DateTime(year, month + 1);
  }

  DateTime subtractAYear() {
    return DateTime(year - 1, month);
  }

  DateTime addAYear() {
    return DateTime(year + 1, month);
  }
}
