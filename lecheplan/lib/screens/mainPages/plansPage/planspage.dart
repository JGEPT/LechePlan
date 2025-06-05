import 'package:flutter/material.dart';
import 'package:lecheplan/models/plan_model.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/widgets/modelWidgets/upcomingplans_card.dart';
import 'package:lecheplan/widgets/modelWidgets/calendar_widget.dart';
import 'package:lecheplan/widgets/modelWidgets/month_year_picker.dart';
import 'package:lecheplan/widgets/modelWidgets/group_calendar_widget.dart'
    as group_cal;
import 'package:lecheplan/services/plans_services.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/screens/mainPages/plansPage/create_plan_page.dart';

class PlansPage extends StatefulWidget {
  final List<Plan> plans;
  final bool isLoading;
  final VoidCallback? onPlanCreated;

  const PlansPage({
    super.key,
    required this.plans,
    required this.isLoading,
    this.onPlanCreated,
  });

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  bool isActivityView = true;
  String? errorMsg;
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
  bool useGroupCalendar = false;
  Set<String> selectedUsers = {};
  List<Map<String, String>> allUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
    final now = DateTime.now();
    calendarMonth = DateTime(now.year, now.month);
    selectedDay = DateTime(now.year, now.month, now.day);
  }

  Future<void> _fetchAllUsers() async {
    final users = await fetchAllUsers();
    if (mounted) {
      setState(() {
        allUsers =
            users
                .map(
                  (u) => {
                    'username': (u['username'] ?? '').toString(),
                    'profile_photo_url':
                        (u['profile_photo_url'] ?? '').toString(),
                  },
                )
                .toList();
      });
    }
  }

  void _showMonthYearOverlay(BuildContext context) {
    if (_monthYearOverlay != null) return;
    _monthYearOverlay = OverlayEntry(
      builder:
          (context) => MonthYearPickerOverlay(
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
                        onTap: () async {
                          Navigator.pop(context);
                          await context.push('/createplan');
                          if (widget.onPlanCreated != null)
                            widget.onPlanCreated!();
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
    // Use all users from the database for the filter UI
    final List<String> allUsernames =
        allUsers
            .map((u) => u['username'] ?? '')
            .where((u) => u.isNotEmpty)
            .toList();
    // If selectedUsers is empty (first load), select all by default
    if (useGroupCalendar && selectedUsers.isEmpty && allUsernames.isNotEmpty) {
      selectedUsers = Set<String>.from(allUsernames);
    }

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
            onPressed: () => context.push('/notifications'),
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
              if (!isActivityView)
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Group Calendar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Switch(
                              value: useGroupCalendar,
                              onChanged: (val) {
                                setState(() {
                                  useGroupCalendar = val;
                                  if (val &&
                                      selectedUsers.isEmpty &&
                                      allUsernames.isNotEmpty) {
                                    selectedUsers = Set<String>.from(
                                      allUsernames,
                                    );
                                  }
                                });
                              },
                              activeColor: orangeAccentColor,
                            ),
                          ],
                        ),
                      ),
                      if (useGroupCalendar && allUsernames.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 6,
                            radius: const Radius.circular(8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    allUsernames.map((user) {
                                      final selected = selectedUsers.contains(
                                        user,
                                      );
                                      final avatarUrl = _getAvatarForUser(user);
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selected) {
                                              selectedUsers.remove(user);
                                            } else {
                                              selectedUsers.add(user);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        selected
                                                            ? orangeAccentColor
                                                            : Colors
                                                                .transparent,
                                                    width: 3,
                                                  ),
                                                ),
                                                child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage:
                                                      (avatarUrl != null &&
                                                              avatarUrl
                                                                  .isNotEmpty)
                                                          ? NetworkImage(
                                                            avatarUrl,
                                                          )
                                                          : const AssetImage(
                                                                'assets/images/sampleAvatar.jpg',
                                                              )
                                                              as ImageProvider,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                user,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      selected
                                                          ? orangeAccentColor
                                                          : darktextColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child:
                            useGroupCalendar
                                ? group_cal.GroupCalendarWidget(
                                  plans: widget.plans,
                                  calendarMonth: calendarMonth,
                                  selectedDay: selectedDay,
                                  onMonthChanged: (newMonth) {
                                    setState(() {
                                      calendarMonth = newMonth;
                                    });
                                  },
                                  onDaySelected: (day) {
                                    setState(() {
                                      selectedDay = day;
                                    });
                                  },
                                  highlightedCalendarIndex:
                                      highlightedCalendarIndex,
                                  onHighlightCard: (idx) {
                                    setState(() {
                                      highlightedCalendarIndex = idx;
                                    });
                                  },
                                  onShowMonthYearPicker:
                                      () => _showMonthYearOverlay(context),
                                  totalSelected: selectedUsers.length,
                                  selectedUsers: selectedUsers,
                                )
                                : CalendarWidget(
                                  plans: widget.plans,
                                  calendarMonth: calendarMonth,
                                  selectedDay: selectedDay,
                                  onMonthChanged: (newMonth) {
                                    setState(() {
                                      calendarMonth = newMonth;
                                    });
                                  },
                                  onDaySelected: (day) {
                                    setState(() {
                                      selectedDay = day;
                                    });
                                  },
                                  highlightedCalendarIndex:
                                      highlightedCalendarIndex,
                                  onHighlightCard: (idx) {
                                    setState(() {
                                      highlightedCalendarIndex = idx;
                                    });
                                  },
                                  onShowMonthYearPicker:
                                      () => _showMonthYearOverlay(context),
                                ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansList() {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMsg != null) {
      return Center(
        child: Text(errorMsg!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (widget.plans.isEmpty) {
      return const Center(
        child: Text(
          'No plans yet. Tap Create to add one!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: widget.plans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) => setState(() => highlightedIndex = index),
          onExit: (_) => setState(() => highlightedIndex = null),
          child: GestureDetector(
            onTap: () => setState(() => highlightedIndex = index),
            child: UpcomingplansCard(
              plan: widget.plans[index],
              highlighted: highlightedIndex == index,
            ),
          ),
        );
      },
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

  String? _getAvatarForUser(String username) {
    // Try allUsers first
    final user = allUsers.firstWhere(
      (u) => u['username'] == username,
      orElse: () => {},
    );
    if (user.isNotEmpty && (user['profile_photo_url']?.isNotEmpty ?? false)) {
      return user['profile_photo_url'];
    }
    // Fallback to plans
    for (final plan in widget.plans) {
      if (plan.participants.contains(username) &&
          plan.profilePhotoUrls.isNotEmpty) {
        final idx = plan.participants.indexOf(username);
        if (idx >= 0 && idx < plan.profilePhotoUrls.length) {
          return plan.profilePhotoUrls[idx];
        }
      }
    }
    return null;
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
