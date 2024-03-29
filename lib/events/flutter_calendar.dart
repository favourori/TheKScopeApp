import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'calendar_tile.dart';
import 'package:date_utils/date_utils.dart';

typedef DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final DayBuilder dayBuilder;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final DateTime initialCalendarDateOverride;

  Calendar(
      {this.onDateSelected,
      this.onSelectedRangeChange,
      this.dayBuilder,
      this.showTodayAction: false,
      this.showChevronsToChangeRange: true,
      this.showCalendarPickerIcon: true,
      this.initialCalendarDateOverride});

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final calendarUtils = new Utils();
  DateTime today = new DateTime.now();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate;
  Tuple2<DateTime, DateTime> selectedRange;
  String currentMonth;
  String displayMonth;

  DateTime get selectedDate => _selectedDate;

  void initState() {
    super.initState();
    if (widget.initialCalendarDateOverride != null) today = widget.initialCalendarDateOverride;
    selectedMonthsDays = Utils.daysInMonth(today);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
    selectedWeeksDays =
        Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
    _selectedDate = today;
    displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
  }

  Widget get nameAndIconRow {
    var leftInnerIcon;
    var rightInnerIcon;
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.showCalendarPickerIcon) {
      rightInnerIcon = new IconButton(
        onPressed: () => selectDateFromPicker(),
        icon: new Icon(
          Icons.calendar_today,
          color: Colors.white,
        ),
      );
    } else {
      rightInnerIcon = new Container();
    }

    if (widget.showChevronsToChangeRange) {
      leftOuterIcon = new IconButton(
        onPressed: previousMonth,
        icon: new Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
      );
      rightOuterIcon = new IconButton(
        onPressed: nextMonth,
        icon: new Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
      );
    } else {
      leftOuterIcon = new Container();
      rightOuterIcon = new Container();
    }

    if (widget.showTodayAction) {
      leftInnerIcon = new InkWell(
        child: new Text(
          'Today',
          style: const TextStyle(color: Colors.white),
        ),
        onTap: resetToToday,
      );
    } else {
      leftInnerIcon = new Container();
    }

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftOuterIcon ?? new Container(),
        leftInnerIcon ?? new Container(),
        new Text(
          displayMonth,
          style: new TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        rightInnerIcon ?? new Container(),
        rightOuterIcon ?? new Container(),
      ],
    );
  }

  Widget get calendarGridView {
    // TODO: Follow up on this: https://github.com/flutter/flutter/issues/16125
    return new Container(
      height: 250.0,
      child: new GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) => getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
        child: new GridView.count(
          crossAxisCount: 7,
          childAspectRatio: 1.5,
          padding: new EdgeInsets.only(bottom: 0.0),
          children: calendarBuilder(),
        ),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays = selectedMonthsDays;

    Utils.weekdays.forEach(
      (day) {
        dayWidgets.add(
          new CalendarTile(
            isDayOfWeek: true,
            dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
      (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            new CalendarTile(
              child: this.widget.dayBuilder(context, day),
            ),
          );
        } else {
          dayWidgets.add(
            new CalendarTile(
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              date: day,
              dateStyles: configureDateStyle(monthStarted, monthEnded),
              isSelected: Utils.isSameDay(selectedDate, day),
            ),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles = monthStarted && !monthEnded
        ? new TextStyle(color: Colors.white)
        : new TextStyle(color: Colors.white30);
    return dateStyles;
  }

//  Widget get expansionButtonRow {
//    if (widget.isExpandable) {
//      return new Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          new Text(Utils.fullDayFormat(selectedDate)),
//          new IconButton(
//            iconSize: 20.0,
//            padding: new EdgeInsets.all(0.0),
//            onPressed: toggleExpanded,
//            icon: isExpanded
//                ? new Icon(Icons.arrow_drop_up)
//                : new Icon(Icons.arrow_drop_down),
//          ),
//        ],
//      );
//    } else {
//      return new Container();
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: const Color(0xFF252a40),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          calendarGridView
          // expansionButtonRow
        ],
      ),
    );
  }

  void resetToToday() {
    today = new DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);

    setState(() {
      _selectedDate = today;
      selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });

    _launchDateSelectionCallback(today);
  }

  void nextMonth() {
    setState(() {
      today = Utils.nextMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void previousMonth() {
    setState(() {
      today = Utils.previousMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void nextWeek() {
    setState(() {
      today = Utils.nextWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void previousWeek() {
    setState(() {
      today = Utils.previousWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    selectedRange = new Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        _selectedDate = selected;
        selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(selected));
      });

      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;

  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      nextMonth();
    } else {
      previousMonth();
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
      selectedMonthsDays = Utils.daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(day);
    }
  }
}
