import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/models/plan_model.dart';

class ActivityDetailsPage extends StatefulWidget {
  final Plan plan;

  const ActivityDetailsPage({super.key, required this.plan});

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _ActivityAppBar(plan: widget.plan),
    );
  }
}

class _ActivityAppBar extends StatelessWidget {
  final Plan plan;

  const _ActivityAppBar({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final date = plan.planDateTime;
    final startTime = TimeOfDay(hour: date.hour, minute: date.minute);
    final endTime = TimeOfDay(
      hour: (date.hour + 4) % 24,
      minute: date.minute,
    ); // 4 hour duration for demo

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        toolbarHeight: 55,
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ), //will go back to prev if used context.push
        backgroundColor: pinkishBackgroundColor,
        elevation: 0,
        title: Text(
          "Activity Details",
          style: TextStyle(
            color: orangeAccentColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_rounded, color: darktextColor),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          //use contianer to determine the look of the actual tab bar
          child: Divider(height: 2, color: darktextColor.withAlpha(100)),
        ),
      ),
      body: Container(
        color: pinkishBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            //calendar symbol
            children: [
              Column(
                children: [
                  Container(
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 3, color: orangeAccentColor),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: darktextColor.withAlpha(30),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        //top orange part
                        Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: orangeAccentColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          //month
                          child: Center(
                            child: Text(
                              _getMonthAbbreviation(plan.planDateTime),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),

                        // main date area
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  plan.planDateTime.day.toString(),
                                  style: TextStyle(
                                    color: darktextColor,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  plan.planDateTime.year.toString(),
                                  style: TextStyle(
                                    color: darktextColor.withAlpha(180),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  //time under the date
                  Text(
                    "${_formatTime(startTime)} - ${_formatTime(endTime)}",
                    style: TextStyle(
                      color: darktextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  //Title of the activity yipee
                  Text(
                    plan.title,
                    style: TextStyle(
                      color: darktextColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 0),
                  //people going -- idk what else to put here other than that
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: 'with ',
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        color: Color(0xFF0E1342),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: plan.participants.join(', '),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6600),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //list of the people that are apil
                  const SizedBox(height: 20),

                  ParticipantsList(participants: plan.participants, profilePhotoUrls: plan.profilePhotoUrls),
                ],
              ),

              // RSVP part of the UI
              _RSVPSection(),
            ],
          ),
        ),
      ),
    );
  }

  //thanks james for makign the code already yipee
  String _getMonthAbbreviation(DateTime dateTime) {
    const List<String> months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[dateTime.month - 1];
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final min = t.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }
}

// at the very bottom, whether the user go or no go
class _RSVPSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: darktextColor.withAlpha(20),
            blurRadius: 5,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // stays like this until user chooses an option, must handle pa
          Text(
            'RSVP Status: Pending...',
            style: TextStyle(
              color: darktextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Quicksand',
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Will you attend this activity?',
            style: TextStyle(
              color: darktextColor.withAlpha(180),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Quicksand',
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // decline button
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF44336),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF44336).withAlpha(60),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // needs to decline
                      },
                      child: const Center(
                        child: Icon(Icons.close, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              //accepting button gren
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withAlpha(60),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        //no yet, make accept
                      },
                      child: const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ParticipantsList extends StatelessWidget {
  final List<String> participants;
  final List<String> profilePhotoUrls;
  
  const ParticipantsList({
    super.key, 
    required this.participants,
    required this.profilePhotoUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            'Participants:',
            style: TextStyle(
              color: darktextColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Quicksand',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: darktextColor.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: participants.length,
            separatorBuilder:
                (context, index) => Divider(
                  height: 1,
                  color: darktextColor.withAlpha(30),
                  indent: 60,
                  endIndent: 16,
                ),
            itemBuilder: (context, index) {
              return _ParticipantCard(
                username: participants[index],
                status: _getParticipantStatus(index), //temporary pa
                profilePhotoUrls: profilePhotoUrls,
                participants: participants,
              );
            },
          ),
        ),
      ],
    );
  }
  
  String _getParticipantStatus(int index) {
    // demo statuses so we can add the rsvp thingy 
    const statuses = ['Going', 'Not Going', 'Pending...', 'Pending...'];
    return statuses[index % statuses.length];
  }
}

class _ParticipantCard extends StatelessWidget {
  final String username;
  final String status;
  final List<String> profilePhotoUrls;
  final List<String> participants;
  
  const _ParticipantCard({
    required this.username,
    required this.status,
    required this.profilePhotoUrls,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: _getAvatarForUser(username),
            radius: 22,
          ),
          const SizedBox(width: 12),
          //username and status showing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Quicksand',
                    color: darktextColor,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Quicksand',
                    color: _getStatusColor(status),
                  ),
                ),
              ],
            ),
          ),
          
          //status symbol 
          Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
            size: 20,
          ),
        ],
      ),
    );
  }

  //based on James' function yey thanks james -- but like simpler cuz already listed
  ImageProvider _getAvatarForUser(String username) { 
    final userIndex = participants.indexOf(username);
    
    // check if the photo is available for the user
    if (userIndex >= 0 && 
        userIndex < profilePhotoUrls.length && 
        profilePhotoUrls[userIndex].isNotEmpty) {
      return NetworkImage(profilePhotoUrls[userIndex]);
    }
    
    // else
    return const AssetImage('assets/images/sampleAvatar.jpg');
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'going':
        return const Color(0xFF4CAF50); 
      case 'not going':
        return const Color(0xFFF44336); 
      case 'pending...':
        return const Color(0xFFFF9800); 
      default:
        return const Color(0xFF757575); 
    }
  }
  
  //for the right side icons 
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'going':
        return Icons.check_circle;
      case 'not going':
        return Icons.cancel;
      case 'pending...':
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }
}

