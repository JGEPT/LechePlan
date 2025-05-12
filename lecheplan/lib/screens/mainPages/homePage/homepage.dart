import 'package:lecheplan/widgets/reusableWidgets/custom_icontextbutton.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; //for the database

import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//model imports
import 'package:lecheplan/models/plan_model.dart';

//widget imports
import 'package:lecheplan/widgets/modelWidgets/upcomingplans_card.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override  
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plan> plans = [];
  List<Map<String, dynamic>> upcomingPlans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: orangeGradient),
      child: Column(
        children: [
          const _HeaderContent(),
          _MainContainer(
            isLoading: isLoading,
            upcomingPlans: upcomingPlans,
          ),
        ],
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 10),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _GreetingText(),
          const _NotificationAndAvatar(),
        ],
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  const _GreetingText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, Username!",
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
  const _NotificationAndAvatar();

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
        CircleAvatar(
          backgroundImage: const AssetImage('assets/images/sampleAvatar.jpg'),
          radius: 22,
        ),
      ],
    );
  }
}

class _MainContainer extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> upcomingPlans;

  const _MainContainer({
    required this.isLoading,
    required this.upcomingPlans,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: pinkishBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ComingUpSection(upcomingPlans: upcomingPlans),
              
              const SizedBox(height: 20,),

              const _SuggestedForYouSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingUpSection extends StatelessWidget {
  final List<Map<String, dynamic>> upcomingPlans;

  const _ComingUpSection({required this.upcomingPlans});

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
        const SizedBox(height: 8),
        if (upcomingPlans.isEmpty)
          Center(
            child: Text(
              'No upcoming plans',
              style: TextStyle(
                color: darktextColor.withAlpha(200),
                fontSize: 16,
              ),
            ),
          )
        else
        //this is temporary just for checking if the data is loading
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingPlans.length,
            itemBuilder: (context, index) {
              final plan = upcomingPlans[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(plan['title'] ?? 'No title'), 
                  subtitle: Text(plan['description'] ?? ''),
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        Customfilledbutton(
          buttonHeight: 25,
          buttonWidth: double.infinity,
          buttonFillColor: orangeAccentColor,
          buttonRadius: 20,
          textColor: lighttextColor,
          buttonLabel: 'See All >',
          pressAction: () {},
        ),
      ],
    );
  }
}

class _SuggestedForYouSection extends StatelessWidget {
  const _SuggestedForYouSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.max,
      children: const [
        _SectionHeader(),
        _ActionButtons(),
        _RecommendationButtons(),
        _BottomText(),
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        CustomIconTextButton(
          label: 'Add\nPeople',
          iconSize: 30,
          buttonIcon: Icons.group_add_outlined,
        ),
        CustomIconTextButton(
          label: 'Add\nActivity',
          iconSize: 30,
          buttonIcon: Icons.edit_calendar_outlined,
        ),
      ],
    );
  }
}

class _RecommendationButtons extends StatelessWidget {
  const _RecommendationButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        CustomIconTextButton(
          label: 'Recommend an Activity!',
          iconSize: 25,
          buttonIcon: Icons.lightbulb_outline_rounded,
        ),
        Material(
          color: orangeAccentColor,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(17),
              child: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomText extends StatelessWidget {
  const _BottomText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'or try the recomendations below!',
      style: TextStyle(
        color: darktextColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
