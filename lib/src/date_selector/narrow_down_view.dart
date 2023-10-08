import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:range_mason/range_mason.dart';
import 'dart:math' as math;

typedef NarrowDownBottomBuilder = Widget Function(
    VoidCallback? onCancel, OnCalendarUpdate? onSelect);

class NarrowDownView extends StatefulWidget {
  final double width;
  final double height;
  final double maxWidth;
  final VoidCallback? onCancel;
  final OnCalendarUpdate? onSelect;
  final CalendarColorScheme colorScheme;
  final TextStyle? headerTextStyle;
  final DateTime displayDate;
  final CalendarViewController calendarViewController;
  final Color dividerColor;
  // final bool isYearSelection;
  // final NarrowDownBottomBuilder? narrowDownBottomBuilder;
  const NarrowDownView({
    super.key,
    required this.width,
    required this.height,
    required this.displayDate,
    required this.colorScheme,
    required this.maxWidth,
    required this.headerTextStyle,
    required this.calendarViewController,
    required this.dividerColor,
    // required this.isYearSelection,
    // required this.narrowDownBottomBuilder,
    this.onCancel,
    this.onSelect,
  });

  @override
  State<NarrowDownView> createState() => _NarrowDownViewState();
}

class _NarrowDownViewState extends State<NarrowDownView> {
  double? gridHeight;
  double? gridWidth;

  late int selectedYear;
  late int selectedMonthIdx;

  bool isYearSelection = true;

  late int startYear;

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    gridHeight = widget.height / 4;
    gridWidth = widget.width / 3;

    selectedYear = widget.displayDate.year;
    selectedMonthIdx = widget.displayDate.month - 1;

    startYear = roundYearToDecade(widget.displayDate.year);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      width: widget.maxWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _calendarControls(),
          Divider(
            color: widget.dividerColor,
            height: 0,
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: widget.height,
            width: widget.width,
            child: _generateGrids(),
          ),
          const SizedBox(height: 7),
          Divider(
            color: widget.dividerColor,
            height: 0,
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.onCancel?.call();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff436AF5),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    if (isYearSelection) {
                      setState(() {
                        isYearSelection = false;
                      });
                      return;
                    }

                    widget.onSelect?.call(selectedMonthIdx + 1, selectedYear);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: const Color(0xff436AF5),
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _generateGrids() {
    List<Widget> grids = List.generate(
      isYearSelection ? 10 : 12,
      (index) {
        int currentYear = -1;
        bool isCurrent = false;

        if (isYearSelection) {
          currentYear = startYear + index;
          isCurrent = currentYear == selectedYear;
        } else {
          isCurrent = selectedMonthIdx == index;
        }

        Widget text = Text(
          isYearSelection ? '${startYear + index}' : months[index],
          style: TextStyle(
            fontWeight: widget.colorScheme.dayTextStyle?.fontWeight,
            fontSize: widget.colorScheme.dayTextStyle?.fontSize,
            color: isCurrent
                ? widget.colorScheme.selectedColor
                : widget.colorScheme.dayTextStyle?.color,
          ),
        );

        return Container(
          height: gridHeight,
          width: gridWidth,
          // color: randomColor,
          child: Center(
            child: isCurrent
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: widget.colorScheme.selectedColor)),
                            child: Center(
                              child: text,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : InkWell(
                    onTap: () {
                      setState(() {
                        if (isYearSelection) {
                          selectedYear = currentYear;
                        } else {
                          selectedMonthIdx = index;
                        }
                      });
                    },
                    child: text,
                  ),
          ),
        );
      },
    );
    return Wrap(children: grids);
  }

  Widget _calendarControls() {
    return Container(
      height: 42,
      width: widget.maxWidth - 40,
      child: Row(
        children: !isYearSelection
            ? [
                const SizedBox(width: 16),
                Text(
                  selectedYear.toString(),
                  style: widget.headerTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ]
            : [
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () {
                    if (isYearSelection) {
                      setState(() {
                        startYear -= 10;
                      });

                      return;
                    }
                  },
                  child: SvgPicture.asset(
                    CalendarViewData.singleArrowImage,
                    package: 'range_mason',
                  ),
                ),
                const Spacer(),
                Text(
                  _getYearHeader(),
                  style: widget.headerTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Transform.rotate(
                  angle: math.pi,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      if (isYearSelection) {
                        setState(() {
                          startYear += 10;
                        });

                        return;
                      }
                    },
                    child: SvgPicture.asset(
                      CalendarViewData.singleArrowImage,
                      package: 'range_mason',
                    ),
                  ),
                ),
              ],
      ),
    );
  }

  String _getYearHeader() {
    int endYear = (startYear % 100) + 9;
    String endYearStr = endYear < 10 ? '0$endYear' : '$endYear';
    return '$startYear-$endYearStr';
  }

  Color get randomColor {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  int roundYearToDecade(int year) {
    // Extract the first two digits of the year
    int firstTwoDigits = year ~/ 10;
    // Calculate the rounded year by multiplying the first two digits by 100
    return firstTwoDigits * 10;
  }
}
