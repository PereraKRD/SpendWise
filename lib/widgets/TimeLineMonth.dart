import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendwise/common/color_extension.dart';

class TimeLineWithMonth extends StatefulWidget {
  const TimeLineWithMonth({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  State<TimeLineWithMonth> createState() => _TimeLineWithMonthState();
}

class _TimeLineWithMonthState extends State<TimeLineWithMonth> {
  String currentMonth = "";
  List<String> months = [];
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = -11; i <= 0; i++) {
      months.add(
          DateFormat('MMM y').format(DateTime(now.year, now.month + i, 1)));
    }
    currentMonth = DateFormat('MMM y').format(now);

    Future.delayed(Duration(seconds: 1), () {
      scrollToSelectedMonth();
    });
  }

  scrollToSelectedMonth() {
    final selectedMonthIndex = months.indexOf(currentMonth);
    if (selectedMonthIndex != -1 && scrollController.hasClients) {
      final scrollOffset = (selectedMonthIndex * 100.0) - 150;
      scrollController.animateTo(scrollOffset,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: months.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentMonth = months[index];
                  widget.onChanged(months[index]);
                });
                scrollToSelectedMonth();
              },
              child: Container(
                width: 80,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: currentMonth == months[index]
                      ? TColor.secondary.withOpacity(0.7)
                      : TColor.primary.withOpacity(0.3),
                ),
                child: Center(
                    child: Text(months[index],
                        style: TextStyle(color: TColor.primary))),
              ),
            );
          }),
    );
  }
}
