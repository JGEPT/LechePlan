import 'package:flutter/material.dart';
import 'package:lecheplan/models/plan_model.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/widgets/modelWidgets/upcomingplans_card.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  bool isActivityView = true;
  bool isLoading = false;
  String? errorMsg;
  List<Plan> plans = [];
  int? highlightedIndex; // Track hovered or selected card
  bool createHovered = false; // Track hover for Create button
  bool activityHover = false; // Track hover for Activity toggle
  bool calendarHover = false; // Track hover for Calendar toggle
  DateTime calendarMonth = DateTime.now();
  DateTime? selectedDay;
  int? highlightedCalendarIndex; // Track hovered/selected card in calendar tab
  bool leftArrowHover = false;
  bool rightArrowHover = false;
  bool addButtonHover = false;
  bool showMonthYearPicker = false;
  int pickerYear = DateTime.now().year;
  int pickerMonth = DateTime.now().month;
  OverlayEntry? _monthYearOverlay;
  bool chevronHover = false;
  bool chevronPressed = false;

  @override
  void initState() {
    super.initState();
    loadSamplePlans();
    final now = DateTime.now();
    calendarMonth = DateTime(now.year, now.month);
    selectedDay = DateTime(now.year, now.month, now.day);
  }

  void loadSamplePlans() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    try {
      plans = [
        Plan(
          planID: '1',
          title: 'Video Game Shesh',
          category: 'Gaming',
          planDateTime: DateTime(2025, 5, 10, 23, 0),
          participants: ['GroupName'],
          tags: ['fun', 'night'],
          avatarAssets: List.generate(
            1,
            (_) => 'assets/images/sampleAvatar.jpg',
          ),
        ),
        Plan(
          planID: '2',
          title: 'Chicken Jockey',
          category: 'Party',
          planDateTime: DateTime(2025, 5, 10, 23, 0),
          participants: ['GroupName', 'Person1'],
          tags: ['chicken', 'jockey'],
          avatarAssets: List.generate(
            2,
            (_) => 'assets/images/sampleAvatar.jpg',
          ),
        ),
        Plan(
          planID: '3',
          title: 'Project Expo',
          category: 'Project Presentation',
          planDateTime: DateTime(2025, 5, 12, 19, 0),
          participants: ['Block B', 'Block A', 'Block C'],
          tags: ['Coding', 'Projects'],
          avatarAssets: List.generate(
            3,
            (_) => 'assets/images/sampleAvatar.jpg',
          ),
        ),
        Plan(
          planID: '4',
          title: 'Moalboal',
          category: 'Travel',
          planDateTime: DateTime(2025, 5, 15, 20, 0),
          participants: ['Block B', 'James', 'Keane', 'Ishah', 'Hya'],
          tags: ['movies', 'popcorn'],
          avatarAssets: List.generate(
            5,
            (_) => 'assets/images/sampleAvatar.jpg',
          ),
        ),
      ];
    } catch (e) {
      errorMsg = 'Failed to load plans.';
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showMonthYearOverlay(BuildContext context) {
    if (_monthYearOverlay != null) return;
    _monthYearOverlay = OverlayEntry(
      builder:
          (context) => _MonthYearPickerOverlay(
            initialMonth: calendarMonth.month,
            initialYear: calendarMonth.year,
            onCancel: () {
              _monthYearOverlay?.remove();
              _monthYearOverlay = null;
              setState(() => showMonthYearPicker = false);
            },
            onSelect: (int year, int month) {
              _monthYearOverlay?.remove();
              _monthYearOverlay = null;
              setState(() {
                calendarMonth = DateTime(year, month);
                showMonthYearPicker = false;
              });
            },
          ),
    );
    Overlay.of(context, rootOverlay: true).insert(_monthYearOverlay!);
    setState(() => showMonthYearPicker = true);
  }

  void _showPlanCreationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 12,
              left: 0,
              right: 0,
              bottom: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _PlanModalButton(
                        icon: Icons.lightbulb_outline_rounded,
                        label: 'Generate Ideas',
                        onTap: () {
                          // TODO: Implement generate ideas
                          Navigator.pop(context);
                        },
                        color: orangeAccentColor,
                      ),
                      const SizedBox(height: 16),
                      _PlanModalButton(
                        icon: Icons.event_note_rounded,
                        label: 'Create Own',
                        onTap: () {
                          // TODO: Implement create own
                          Navigator.pop(context);
                        },
                        color: orangeAccentColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: const Text(
          'Plans',
          style: TextStyle(
            color: Color(0xFFFF6600),
            fontWeight: FontWeight.w700,
            fontSize: 32,
            fontFamily: 'Quicksand',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF0E1342),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF0E1342)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F5FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Toggle bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => activityHover = true),
                          onExit: (_) => setState(() => activityHover = false),
                          child: GestureDetector(
                            onTap: () => setState(() => isActivityView = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color:
                                    isActivityView
                                        ? Colors.white
                                        : activityHover
                                        ? orangeAccentColor
                                        : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Activity',
                                style: TextStyle(
                                  color:
                                      isActivityView
                                          ? orangeAccentColor
                                          : activityHover
                                          ? Colors.white
                                          : darktextColor.withAlpha(120),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  fontFamily: 'Quicksand',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MouseRegion(
                          onEnter: (_) => setState(() => calendarHover = true),
                          onExit: (_) => setState(() => calendarHover = false),
                          child: GestureDetector(
                            onTap: () => setState(() => isActivityView = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color:
                                    !isActivityView
                                        ? Colors.white
                                        : calendarHover
                                        ? orangeAccentColor
                                        : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Calendar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color:
                                          !isActivityView
                                              ? orangeAccentColor
                                              : calendarHover
                                              ? Colors.white
                                              : darktextColor.withAlpha(120),
                                      fontFamily: 'Quicksand',
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color:
                                          !isActivityView
                                              ? Colors.red
                                              : calendarHover
                                              ? Colors.white
                                              : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isActivityView)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.sort,
                                color: Color(0xFF0E1342),
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Sort by',
                                style: TextStyle(
                                  color: Color(0xFF0E1342),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF0E1342),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      MouseRegion(
                        onEnter: (_) => setState(() => createHovered = true),
                        onExit: (_) => setState(() => createHovered = false),
                        child: GestureDetector(
                          onTapDown:
                              (_) => setState(() => createHovered = true),
                          onTapUp: (_) => setState(() => createHovered = false),
                          onTapCancel:
                              () => setState(() => createHovered = false),
                          child: AnimatedScale(
                            scale: createHovered ? 1.07 : 1.0,
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.easeOut,
                            child: SizedBox(
                              height: 38,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeAccentColor,
                                  foregroundColor: Colors.white,
                                  elevation: createHovered ? 6 : 0,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                                onPressed:
                                    () => _showPlanCreationModal(context),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                  ),
                                  child: Text('Create'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isActivityView) Expanded(child: _buildPlansList()),
              if (!isActivityView) Expanded(child: _buildCalendarTab()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMsg != null) {
      return Center(
        child: Text(errorMsg!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (plans.isEmpty) {
      return const Center(
        child: Text(
          'No plans yet. Tap Create to add one!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: plans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) => setState(() => highlightedIndex = index),
          onExit: (_) => setState(() => highlightedIndex = null),
          child: GestureDetector(
            onTap: () => setState(() => highlightedIndex = index),
            child: UpcomingplansCard(
              plan: plans[index],
              highlighted: highlightedIndex == index,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarTab() {
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
                      MouseRegion(
                        onEnter: (_) => setState(() => chevronHover = true),
                        onExit:
                            (_) => setState(() {
                              chevronHover = false;
                              chevronPressed = false;
                            }),
                        child: GestureDetector(
                          onTapDown:
                              (_) => setState(() => chevronPressed = true),
                          onTapUp:
                              (_) => setState(() => chevronPressed = false),
                          onTapCancel:
                              () => setState(() => chevronPressed = false),
                          onTap: () => _showMonthYearOverlay(context),
                          child: AnimatedScale(
                            scale:
                                chevronPressed
                                    ? 0.92
                                    : (chevronHover ? 1.12 : 1.0),
                            duration: const Duration(milliseconds: 120),
                            child: AnimatedOpacity(
                              opacity:
                                  chevronHover || chevronPressed ? 0.7 : 1.0,
                              duration: const Duration(milliseconds: 120),
                              child: Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  splashColor: orangeAccentColor.withAlpha(60),
                                  onTap: () => _showMonthYearOverlay(context),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: orangeAccentColor,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Left arrow button with feedback
                      MouseRegion(
                        onEnter: (_) => setState(() => leftArrowHover = true),
                        onExit: (_) => setState(() => leftArrowHover = false),
                        child: GestureDetector(
                          onTapDown:
                              (_) => setState(() => leftArrowHover = true),
                          onTapUp:
                              (_) => setState(() => leftArrowHover = false),
                          onTapCancel:
                              () => setState(() => leftArrowHover = false),
                          onTap: () {
                            setState(() {
                              calendarMonth = DateTime(
                                calendarMonth.year,
                                calendarMonth.month - 1,
                              );
                            });
                          },
                          child: AnimatedScale(
                            scale: leftArrowHover ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 120),
                            child: AnimatedOpacity(
                              opacity: leftArrowHover ? 0.7 : 1.0,
                              duration: const Duration(milliseconds: 120),
                              child: Icon(
                                Icons.chevron_left,
                                color:
                                    leftArrowHover
                                        ? orangeAccentColor.withAlpha(200)
                                        : orangeAccentColor,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      // Right arrow button with feedback
                      MouseRegion(
                        onEnter: (_) => setState(() => rightArrowHover = true),
                        onExit: (_) => setState(() => rightArrowHover = false),
                        child: GestureDetector(
                          onTapDown:
                              (_) => setState(() => rightArrowHover = true),
                          onTapUp:
                              (_) => setState(() => rightArrowHover = false),
                          onTapCancel:
                              () => setState(() => rightArrowHover = false),
                          onTap: () {
                            setState(() {
                              calendarMonth = DateTime(
                                calendarMonth.year,
                                calendarMonth.month + 1,
                              );
                            });
                          },
                          child: AnimatedScale(
                            scale: rightArrowHover ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 120),
                            child: AnimatedOpacity(
                              opacity: rightArrowHover ? 0.7 : 1.0,
                              duration: const Duration(milliseconds: 120),
                              child: Icon(
                                Icons.chevron_right,
                                color:
                                    rightArrowHover
                                        ? orangeAccentColor.withAlpha(200)
                                        : orangeAccentColor,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Add button with feedback
                      MouseRegion(
                        onEnter: (_) => setState(() => addButtonHover = true),
                        onExit: (_) => setState(() => addButtonHover = false),
                        child: GestureDetector(
                          onTapDown:
                              (_) => setState(() => addButtonHover = true),
                          onTapUp:
                              (_) => setState(() => addButtonHover = false),
                          onTapCancel:
                              () => setState(() => addButtonHover = false),
                          onTap: () => _showPlanCreationModal(context),
                          child: AnimatedScale(
                            scale: addButtonHover ? 1.08 : 1.0,
                            duration: const Duration(milliseconds: 120),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color:
                                    addButtonHover
                                        ? greyAccentColor
                                        : lightAccentColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.add,
                                color:
                                    addButtonHover
                                        ? orangeAccentColor
                                        : darktextColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder:
                        (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                    child: LayoutBuilder(
                      key: ValueKey(
                        '${calendarMonth.year}-${calendarMonth.month}',
                      ),
                      builder: (context, constraints) {
                        final double margin = 6; // slight margin on each side
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
                                    onTap: () {
                                      setState(() {
                                        selectedDay = day;
                                      });
                                    },
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
                                        if (plansForDay.isNotEmpty)
                                          Positioned(
                                            bottom: 0,
                                            child:
                                                plansForDay.length == 1
                                                    ? Container(
                                                      width: 7,
                                                      height: 7,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            orangeAccentColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                    : Icon(
                                                      Icons.workspaces,
                                                      color: orangeAccentColor,
                                                      size: 15,
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
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Always show all plans below the calendar, with pop/hover effect and scrollable above bottom nav
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
                          onEnter:
                              (_) => setState(
                                () => highlightedCalendarIndex = index,
                              ),
                          onExit:
                              (_) => setState(
                                () => highlightedCalendarIndex = null,
                              ),
                          child: GestureDetector(
                            onTap:
                                () => setState(
                                  () => highlightedCalendarIndex = index,
                                ),
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

// Overlay Month/Year Picker
class _MonthYearPickerOverlay extends StatefulWidget {
  final int initialMonth;
  final int initialYear;
  final void Function() onCancel;
  final void Function(int year, int month) onSelect;
  const _MonthYearPickerOverlay({
    required this.initialMonth,
    required this.initialYear,
    required this.onCancel,
    required this.onSelect,
  });
  @override
  State<_MonthYearPickerOverlay> createState() =>
      _MonthYearPickerOverlayState();
}

class _MonthYearPickerOverlayState extends State<_MonthYearPickerOverlay> {
  late int selectedMonth;
  late int selectedYear;
  bool showYearPicker = false;
  FixedExtentScrollController? _fixedExtentController;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
    final yearList = List.generate(21, (i) => widget.initialYear - 10 + i);
    final initialIndex = yearList.indexOf(selectedYear);
    _fixedExtentController = FixedExtentScrollController(
      initialItem: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  @override
  void dispose() {
    _fixedExtentController?.dispose();
    super.dispose();
  }

  void _handleYearSelection(int year) {
    setState(() {
      selectedYear = year;
      showYearPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = [
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
    final yearList = List.generate(21, (i) => widget.initialYear - 10 + i);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onCancel,
            child: Container(color: const Color.fromARGB(60, 0, 0, 0)),
          ),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: showYearPicker ? 200 : 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [defaultBoxShadow],
              ),
              child:
                  showYearPicker
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: greyAccentColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [defaultBoxShadow],
                            ),
                            child: ListWheelScrollView.useDelegate(
                              controller: _fixedExtentController,
                              itemExtent: 22,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged:
                                  (i) => setState(
                                    () => selectedYear = yearList[i],
                                  ),
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: yearList.length,
                                builder:
                                    (context, i) => Center(
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 120,
                                        ),
                                        curve: Curves.easeOut,
                                        decoration: BoxDecoration(
                                          color:
                                              yearList[i] == selectedYear
                                                  ? orangeAccentColor.withAlpha(
                                                    40,
                                                  )
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 1,
                                        ),
                                        child: Text(
                                          '${yearList[i]}',
                                          style: TextStyle(
                                            fontWeight:
                                                yearList[i] == selectedYear
                                                    ? FontWeight.bold
                                                    : FontWeight.w600,
                                            color:
                                                yearList[i] == selectedYear
                                                    ? orangeAccentColor
                                                    : darktextColor,
                                            fontSize:
                                                yearList[i] == selectedYear
                                                    ? 18
                                                    : 16,
                                            shadows:
                                                yearList[i] == selectedYear
                                                    ? [defaultShadow]
                                                    : null,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: widget.onCancel,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: darktextColor),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeAccentColor,
                                  foregroundColor: lighttextColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed:
                                    () => _handleYearSelection(selectedYear),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                        ],
                      )
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_left,
                                  color: orangeAccentColor,
                                ),
                                onPressed: () => setState(() => selectedYear--),
                              ),
                              GestureDetector(
                                onTap:
                                    () => setState(() => showYearPicker = true),
                                child: Text(
                                  '$selectedYear',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: darktextColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.chevron_right,
                                  color: orangeAccentColor,
                                ),
                                onPressed: () => setState(() => selectedYear++),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(
                              12,
                              (i) => ChoiceChip(
                                label: Text(
                                  months[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        selectedMonth == i + 1
                                            ? lighttextColor
                                            : darktextColor,
                                  ),
                                ),
                                selected: selectedMonth == i + 1,
                                selectedColor: orangeAccentColor,
                                backgroundColor: greyAccentColor,
                                showCheckmark: false,
                                onSelected:
                                    (_) =>
                                        setState(() => selectedMonth = i + 1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: widget.onCancel,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: darktextColor),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeAccentColor,
                                  foregroundColor: lighttextColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed:
                                    () => widget.onSelect(
                                      selectedYear,
                                      selectedMonth,
                                    ),
                                child: const Text('Select'),
                              ),
                            ],
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanModalButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _PlanModalButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
    super.key,
  });
  @override
  State<_PlanModalButton> createState() => _PlanModalButtonState();
}

class _PlanModalButtonState extends State<_PlanModalButton> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _active => _hovered || _pressed;

  Color get _buttonBg => _active ? widget.color : Colors.white;
  Color get _buttonBorder => widget.color;
  Color get _textColor => _active ? Colors.white : widget.color;
  Color get _circleColor => _active ? Colors.white : widget.color;
  Color get _iconColor => _active ? widget.color : Colors.white;
  double get _scale => _pressed ? 0.96 : (_hovered ? 1.04 : 1.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:
            (_) => setState(() {
              _hovered = false;
              _pressed = false;
            }),
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              splashColor: widget.color.withOpacity(0.13),
              highlightColor: Colors.transparent,
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  color: _buttonBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _buttonBorder, width: 2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _circleColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: widget.color, width: 2),
                      ),
                      child: Icon(widget.icon, color: _iconColor, size: 24),
                    ),
                    const SizedBox(width: 20),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 120),
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontFamily: 'Quicksand',
                      ),
                      child: Text(widget.label),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
