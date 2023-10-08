library date_range_selector;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:range_mason/src/date_selector/narrow_down_view.dart';

import 'dart:math' as math;

import '../calendar_view/calendar_view.dart';

typedef ControllerCreationCallBack = void Function(
    CalendarViewController controller);

typedef OnCalendarUpdate = void Function(int month, int year);

class DateSelector extends StatefulWidget {
  final double width;
  final EdgeInsets? padding;
  final double crossAxisPadding;
  final Color dividerColor;
  final TextStyle? headerTextStyle;
  final CalendarColorScheme? colorScheme;
  final Widget? bottomBar;
  final CalendarViewController controller;
  final OnCalendarUpdate? onCalendarUpdate;
  // final NarrowDownBottomBuilder? narrowDownBottomBuilder;
  const DateSelector({
    super.key,
    required this.controller,
    // this.narrowDownBottomBuilder,
    this.width = 250,
    this.padding,
    this.crossAxisPadding = 12,
    this.dividerColor = Colors.grey,
    this.headerTextStyle,
    this.colorScheme,
    this.bottomBar,
    this.onCalendarUpdate,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late double maxWidth;
  late double calendarViewWidth;

  late ValueNotifier<String> calendarNotifier;

  final GlobalKey calendarViewKey =
      const GlobalObjectKey('range_mason_calendar_view');

  double? calendarViewRenderedHeight;
  double? calendarViewRenderedWidth;

  bool _displayNarrowDownView = false;

  @override
  void initState() {
    maxWidth = widget.width + widget.crossAxisPadding;
    calendarViewWidth = maxWidth - 40;

    calendarNotifier =
        ValueNotifier<String>(_format(widget.controller.displayDate!));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderbox =
          calendarViewKey.currentContext!.findRenderObject() as RenderBox;
      calendarViewRenderedWidth = renderbox.size.width;
      calendarViewRenderedHeight = renderbox.size.height;
    });

    super.initState();
  }

  void _updateCalendarDateDisplay() {
    calendarNotifier.value = _format(widget.controller.displayDate!);
    DateTime dateTime = widget.controller.displayDate!;
    widget.onCalendarUpdate?.call(dateTime.month, dateTime.year);
  }

  @override
  Widget build(BuildContext context) {
    if (_displayNarrowDownView) {
      return NarrowDownView(
        width: calendarViewRenderedWidth!,
        height: calendarViewRenderedHeight!,
        colorScheme: widget.colorScheme ??
            const CalendarColorScheme(
              selectedColor: Color(0xff436AF5),
            ),
        displayDate: widget.controller.displayDate!,
        maxWidth: maxWidth,
        headerTextStyle: widget.headerTextStyle,
        calendarViewController: widget.controller,
        dividerColor: widget.dividerColor,
        onSelect: (month, year) {
          widget.controller.narrowDownViewSelect(month: month, year: year);
          setState(() {
            _displayNarrowDownView = false;
          });
          _updateCalendarDateDisplay();
        },
        onCancel: () {
          setState(() {
            _displayNarrowDownView = false;
          });
        },
        // narrowDownBottomBuilder: widget.narrowDownBottomBuilder,
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: widget.padding,
      width: maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _calendarControls(
            controller: widget.controller,
            notifier: calendarNotifier,
          ),
          Divider(
            color: widget.dividerColor,
            height: 0,
          ),
          const SizedBox(height: 7),
          _calendarView(widget.controller),
          const SizedBox(height: 7),
          Divider(
            color: widget.dividerColor,
            height: 0,
          ),
          if (widget.bottomBar != null) widget.bottomBar!
        ],
      ),
    );
  }

  CalendarView _calendarView(
    CalendarViewController controller,
  ) {
    return CalendarView(
      key: calendarViewKey,
      controller: controller,
      width: calendarViewWidth,
      colorScheme: widget.colorScheme,
      onHover: (calendarElemet, value) {
        if (!value) {
          controller.selectableHover(null);
          return;
        }
        controller.selectableHover(calendarElemet.dateTime);
      },
      onClick: (calendarElemet) {
        if (calendarElemet.isLeadingOrTrailing) return;
        controller.selectSingleDate(calendarElemet.dateTime);
      },
    );
  }

  Widget _calendarControls({
    required CalendarViewController controller,
    required ValueNotifier<String> notifier,
  }) {
    return Container(
      height: 42,
      width: calendarViewWidth,
      child: Row(
        children: [
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              controller.previousYear();
              _updateCalendarDateDisplay();
            },
            child: SvgPicture.asset(
              CalendarViewData.doublerrowImage,
              package: 'range_mason',
            ),
          ),
          InkWell(
            hoverColor: Colors.transparent,
            onTap: () {
              controller.previousMonth();
              _updateCalendarDateDisplay();
            },
            child: SvgPicture.asset(
              CalendarViewData.singleArrowImage,
              package: 'range_mason',
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              setState(() {
                _displayNarrowDownView = true;
              });
            },
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (context, val, _) {
                return Text(
                  val,
                  style: widget.headerTextStyle,
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          const Spacer(),
          Transform.rotate(
            angle: math.pi,
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                controller.nextMonth();
                _updateCalendarDateDisplay();
              },
              child: SvgPicture.asset(
                CalendarViewData.singleArrowImage,
                package: 'range_mason',
              ),
            ),
          ),
          Transform.rotate(
            angle: math.pi,
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                controller.nextYear();
                _updateCalendarDateDisplay();
              },
              child: SvgPicture.asset(
                CalendarViewData.doublerrowImage,
                package: 'range_mason',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _format(DateTime dateTime) => DateFormat('MMM yyyy').format(dateTime);
}
