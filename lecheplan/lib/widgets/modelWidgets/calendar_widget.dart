import 'package:flutter/material.dart';
import 'package:lecheplan/models/plan_model.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/widgets/modelWidgets/upcomingplans_card.dart';

class CalendarWidget extends StatelessWidget {
  final List<Plan> plans;
  final DateTime calendarMonth;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDaySelected;
  final int? highlightedCalendarIndex;
  final ValueChanged<int?>? onHighlightCard;
  final VoidCallback? onShowMonthYearPicker;

  const CalendarWidget({
    super.key,
    required this.plans,
    required this.calendarMonth,
    required this.selectedDay,
    required this.onMonthChanged,
    required this.onDaySelected,
    this.highlightedCalendarIndex,
    this.onHighlightCard,
    this.onShowMonthYearPicker,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(
      calendarMonth.year,
      calendarMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      calendarMonth.year,
      calendarMonth.month + 1,
      0,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday=0
    final daysInMonth = lastDayOfMonth.day;
    final days = <DateTime>[];
    for (int i = 0; i < firstWeekday; i++) {
      days.add(DateTime(0)); // Empty days
    }
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(calendarMonth.year, calendarMonth.month, i));
    }
    // Map of day -> plans
    final Map<int, List<Plan>> plansByDay = {};
    for (final plan in plans) {
      if (plan.planDateTime.year == calendarMonth.year &&
          plan.planDateTime.month == calendarMonth.month) {
        plansByDay.putIfAbsent(plan.planDateTime.day, () => []).add(plan);
      }
    }
    // Show all plans below the calendar, sorted by date
    final allPlansSorted = [...plans]
      ..sort((a, b) => a.planDateTime.compareTo(b.planDateTime));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [defaultBoxShadow],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _monthYearString(calendarMonth),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: darktextColor,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (onShowMonthYearPicker != null)
                        IconButton(
                          icon: Icon(
                            Icons.expand_more,
                            color: orangeAccentColor,
                          ),
                          tooltip: 'Pick month and year',
                          onPressed: onShowMonthYearPicker,
                        ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: orangeAccentColor,
                        ),
                        onPressed:
                            () => onMonthChanged(
                              DateTime(
                                calendarMonth.year,
                                calendarMonth.month - 1,
                              ),
                            ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: orangeAccentColor,
                        ),
                        onPressed:
                            () => onMonthChanged(
                              DateTime(
                                calendarMonth.year,
                                calendarMonth.month + 1,
                              ),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double margin = 6;
                      final double gridWidth =
                          constraints.maxWidth - margin * 2;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              _CalendarDayLabel('SUN'),
                              _CalendarDayLabel('MON'),
                              _CalendarDayLabel('TUE'),
                              _CalendarDayLabel('WED'),
                              _CalendarDayLabel('THU'),
                              _CalendarDayLabel('FRI'),
                              _CalendarDayLabel('SAT'),
                            ],
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: gridWidth,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    mainAxisSpacing: 0,
                                    crossAxisSpacing: 0,
                                    childAspectRatio: 1.1,
                                  ),
                              itemCount: days.length,
                              itemBuilder: (context, i) {
                                final day = days[i];
                                if (day.year == 0) {
                                  return const SizedBox();
                                }
                                final isToday =
                                    day.year == now.year &&
                                    day.month == now.month &&
                                    day.day == now.day;
                                final isSelected =
                                    selectedDay != null &&
                                    day.year == selectedDay!.year &&
                                    day.month == selectedDay!.month &&
                                    day.day == selectedDay!.day;
                                final plansForDay = plansByDay[day.day] ?? [];
                                return GestureDetector(
                                  onTap: () => onDaySelected(day),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color:
                                                  isToday
                                                      ? orangeAccentColor
                                                      : isSelected
                                                      ? darktextColor
                                                          .withOpacity(0.08)
                                                      : Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: TextStyle(
                                                  color:
                                                      isToday
                                                          ? lighttextColor
                                                          : darktextColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                  fontFamily: 'Quicksand',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (plansForDay.isNotEmpty || isToday)
                                        Positioned(
                                          bottom: 4,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color:
                                                  isToday
                                                      ? Colors.white
                                                      : orangeAccentColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    isToday
                                                        ? orangeAccentColor
                                                        : Colors.transparent,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 70,
            ),
            child:
                allPlansSorted.isEmpty
                    ? const Center(
                      child: Text(
                        'No plans for this month.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      itemCount: allPlansSorted.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return MouseRegion(
                          onEnter: (_) => onHighlightCard?.call(index),
                          onExit: (_) => onHighlightCard?.call(null),
                          child: GestureDetector(
                            onTap: () => onHighlightCard?.call(index),
                            child: UpcomingplansCard(
                              plan: allPlansSorted[index],
                              highlighted: highlightedCalendarIndex == index,
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ],
    );
  }

  String _monthYearString(DateTime date) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month]} ${date.year}';
  }
}

class _CalendarDayLabel extends StatelessWidget {
  final String label;
  const _CalendarDayLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB0B0B0),
            fontWeight: FontWeight.w600,
            fontSize: 11,
            fontFamily: 'Quicksand',
          ),
        ),
      ),
    );
  }
}
