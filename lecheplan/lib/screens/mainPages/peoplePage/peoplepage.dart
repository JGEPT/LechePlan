import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _HeaderContent(),
        _MainContent(),
      ],
    );
  }
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _SearchBar(), // to be changed to an actual search bar
          const _NotificationAndAvatar(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Search',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'Quicksand',
        color: orangeAccentColor,
      ),
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
            color: orangeAccentColor,
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

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            // PLACEHOLDER
            _FriendCard(
              name: 'Ishah Bautista',
              activity: '1 upcoming activity planned',
              profile: 'assets/images/sampleAvatar.jpg',
              onTap: () {
                // adding em to an activity
              },
            ),
            _FriendCard(
              name: 'James Ty',
              activity: '2 upcoming activity planned',
              profile: 'assets/images/sampleAvatar.jpg',
              onTap: () {
                // adding em to an activity
              },
            ),
          ],
        ),
      ),
    );
  }
}

//still temp, i feel like the boxes are too big. I think imma change it \0/
class _FriendCard extends StatelessWidget {
  final String name;
  final String activity;
  final String profile;
  final VoidCallback? onTap;

  const _FriendCard({
    required this.name,
    required this.activity,
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundImage: AssetImage(profile),
          radius: 25,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
          ),
        ),
        subtitle: Text(
          activity,
          style: const TextStyle(
            fontFamily: 'Quicksand',
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}
