library calendar_view;

// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

part 'controller.dart';
part 'data.dart';
part 'extensions.dart';
part 'data_modelling.dart';
part 'widgets.dart';

class CalendarView extends StatefulWidget {
  final double width;
  final CalendarViewController controller;
  final CalendarClick? onClick;
  final CalendarHover? onHover;
  const CalendarView({
    super.key,
    required this.controller,
    this.width = 280,
    this.onClick,
    this.onHover,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  void initState() {
    widget.controller._init(setState, widget.onClick, widget.onHover);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      // height: widget.height,
      width: widget.width,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          // mainAxisSpacing: 3,
          // crossAxisSpacing: 8,
        ),
        itemCount: 49,
        itemBuilder: (context, index) =>
            widget.controller._buildMonthElemet(index),
      ),
    );
  }
}
