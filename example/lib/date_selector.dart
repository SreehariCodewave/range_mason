import 'package:flutter/material.dart';
import 'package:range_mason/range_mason.dart';

class DateSelectorView extends StatefulWidget {
  const DateSelectorView({super.key});

  @override
  State<DateSelectorView> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelectorView> {
  final CalendarViewController calendarViewController = CalendarViewController(
      id: 'calendar',
      startDate: DateTime.now().subtract(const Duration(days: 3)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date selector'),
      ),
      body: Center(
        child: DateSelector(
          controller: calendarViewController,
          width: 270,
          crossAxisPadding: 10,
          dividerColor: const Color(0xfff0f0f0),
          bottomBar: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
