import 'package:lecheplan/widgets/reusableWidgets/custom_icontextbutton.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/services/auth_service.dart';
import 'package:lecheplan/services/profile_service.dart';
import 'package:lecheplan/widgets/reusableWidgets/user_avatar.dart';

//model imports
import 'package:lecheplan/models/plan_model.dart';

//widget imports
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';
import 'package:lecheplan/widgets/modelWidgets/upcomingplans_card.dart';

class HomePage extends StatefulWidget {
  final List<Plan> plans;
  final bool isLoading;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNavigateToPlans;

  const HomePage({
    super.key,
    required this.plans,
    required this.isLoading,
    this.onProfileTap,
    this.onNavigateToPlans,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  //load username from database
  Future<void> _loadUsername() async {
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) return;

      final profileResult = await ProfileService.getUserProfile(currentUser.id);
      
      if (profileResult['success'] && mounted) {
        final profile = profileResult['profile'];
        setState(() {
          _username = profile['username'] ?? 'User';
        });
      }
    } catch (e) {
      //handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeAccentColor,
      body: Column(
        children: [
          _Header(
            onProfileTap: widget.onProfileTap,
            username: _username,
          ),
          Expanded(            
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: pinkishBackgroundColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
              ),
              child: SingleChildScrollView(              
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    _UpcomingPlansSection(
                      plans: widget.plans,
                      isLoading: widget.isLoading,
                      onNavigateToPlans: widget.onNavigateToPlans ?? () {},
                    ),
                    const SizedBox(height: 20),
                    const _GroupsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final String username;

  const _Header({
    Key? key,
    this.onProfileTap,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 10),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _GreetingText(username: username),
          _NotificationAndAvatar(onProfileTap: onProfileTap),
        ],
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  final String username;

  const _GreetingText({required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, $username!",
          style: TextStyle(
            color: lighttextColor,
            fontSize: 25,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        Text(
          "Ready to plan your next sweet activity?",
          style: TextStyle(
            color: lighttextColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _NotificationAndAvatar extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const _NotificationAndAvatar({Key? key, this.onProfileTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 2,
      children: [
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
        UserAvatar(
          radius: 22,
          onTap: onProfileTap,
        ),
      ],
    );
  }
}

class _UpcomingPlansSection extends StatelessWidget {
  final List<Plan> plans;
  final bool isLoading;
  final VoidCallback onNavigateToPlans;

  const _UpcomingPlansSection({required this.plans, required this.isLoading, required this.onNavigateToPlans});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Coming Up',
          style: TextStyle(
            color: darktextColor,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),
        if (isLoading)
          Center(child: CircularProgressIndicator(color: orangeAccentColor))
        else if (plans.isEmpty)
          Center(
            child: Text(
              'You have no upcoming plans',
              style: TextStyle(
                color: darktextColor.withAlpha(200),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(plans.length, 3),
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: UpcomingplansCard(plan: plan),
              );
            },
          ),

        const SizedBox(height: 5),

        Customfilledbutton(
          buttonHeight: 25,
          buttonWidth: double.infinity,
          buttonFillColor: orangeAccentColor,
          buttonRadius: 20,
          textColor: lighttextColor,
          buttonLabel: 'See All',
          pressAction: onNavigateToPlans,
        ),
      ],
    );
  }
}

class _GroupsSection extends StatelessWidget {
  const _GroupsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.max,
      children: [
        const _SectionHeader(),
        _ActionButtons(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Suggested For You',
        style: TextStyle(
          color: darktextColor,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          spacing: 8,
          children: [
            CustomIconTextButton(
              label: 'Add\nFriends',
              iconSize: 30,
              buttonIcon: Icons.person_add_alt_outlined,
              pressAction: () {},
            ),
            CustomIconTextButton(
              label: 'Add\nActivity',
              iconSize: 30,
              buttonIcon: Icons.edit_calendar_outlined,
              pressAction: () {},
            ),
          ],
        ),

        //bottom row
        Row(
          mainAxisSize: MainAxisSize.max,
          spacing: 8,
          children: [
            CustomIconTextButton(
              label: 'Create\nGroup',
              iconSize: 30,
              buttonIcon: Icons.group_add_outlined,
              pressAction: () {},
            ),
            CustomIconTextButton(
              label: 'Check\nCalendar',
              iconSize: 30,
              buttonIcon: Icons.calendar_month_outlined,
              pressAction: () {},
            ),
          ],
        ),
      ],
    );
  }
}

