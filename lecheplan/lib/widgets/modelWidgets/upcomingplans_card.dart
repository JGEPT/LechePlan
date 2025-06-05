import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

//model inmports
import 'package:lecheplan/models/plan_model.dart';

class UpcomingplansCard extends StatefulWidget {
  final Plan plan;
  final bool highlighted;

  const UpcomingplansCard({
    super.key,
    required this.plan,
    this.highlighted = false,
  });

  @override
  State<UpcomingplansCard> createState() => _UpcomingplansCardState();
}

class _UpcomingplansCardState extends State<UpcomingplansCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final date = widget.plan.planDateTime;
    final startTime = TimeOfDay(hour: date.hour, minute: date.minute);
    final endTime = TimeOfDay(
      hour: (date.hour + 4) % 24,
      minute: date.minute,
    ); // 4 hour duration for demo
    final dateString =
        '${_monthShort(date.month)} ${date.day}, ${date.year}  •  ${_formatTime(startTime)} - ${_formatTime(endTime)}';

    // Pop out and enlarge if highlighted or pressed
    final bool isActive = widget.highlighted || _isPressed;
    final double scale = isActive ? 1.035 : 1.0;
    final double shadowBlur = isActive ? 18 : 8;
    final double shadowOpacity = isActive ? 0.10 : 0.04;
    final Offset shadowOffset =
        isActive ? const Offset(0, 4) : const Offset(0, 2);

    return GestureDetector(
      onTap: () {
        //navigate to ActivityDetailsPage and bring da  plan data
        context.push('/activitydetailspage', extra: widget.plan);
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPressStart: (_) => setState(() => _isPressed = true),
      onLongPressEnd: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border:
                isActive
                    ? Border.all(color: orangeAccentColor, width: 2)
                    : Border.all(color: const Color(0xFFE0E0E0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(shadowOpacity),
                blurRadius: shadowBlur,
                offset: shadowOffset,
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plan.title,
                        style: const TextStyle(
                          color: Color(0xFF0E1342),
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          fontFamily: 'Quicksand',
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          text: 'with ',
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            color: Color(0xFF0E1342),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: widget.plan.participants.join(', '),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF6600),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dateString,
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          color: Color(0xFF0E1342),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _AvatarsDisplay(
                  profilePhotoUrls: widget.plan.profilePhotoUrls,
                  participantCount: widget.plan.participants.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthShort(int month) {
    const months = [
      '',
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
      'Dec',
    ];
    return months[month];
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final min = t.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }
}

class _AvatarsDisplay extends StatelessWidget {
  final List<String> profilePhotoUrls;
  final int participantCount;

  const _AvatarsDisplay({
    required this.profilePhotoUrls,
    required this.participantCount,
  });

  @override
  Widget build(BuildContext context) {
    final showCount = participantCount > 3 ? 3 : participantCount;
    final extraCount = participantCount - 3;
    final double overlap = 18; // amount of overlap

    List<Widget> avatarWidgets = [];
    for (int i = 0; i < showCount; i++) {
      final url = (i < profilePhotoUrls.length) ? profilePhotoUrls[i] : null;
      avatarWidgets.add(
        Positioned(
          left: i * overlap,
          child: CircleAvatar(
            backgroundImage:
                (url != null && url.isNotEmpty)
                    ? NetworkImage(url)
                    : const AssetImage('assets/images/sampleAvatar.jpg')
                        as ImageProvider,
            radius: 18,
          ),
        ),
      );
    }
    if (extraCount > 0) {
      avatarWidgets.add(
        Positioned(
          left: showCount * overlap,
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFDFDFDF),
            child: Text(
              '+$extraCount',
              style: const TextStyle(
                color: Color(0xFF0E1342),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: (showCount + (extraCount > 0 ? 1 : 0)) * overlap + 18,
      height: 36,
      child: Stack(clipBehavior: Clip.none, children: avatarWidgets),
    );
  }
}
