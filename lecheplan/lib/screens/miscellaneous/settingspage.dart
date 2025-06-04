import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:lecheplan/screens/mainPages/profilePage/profilepage.dart';
import 'package:lecheplan/screens/miscellaneous/settingspage.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pinkishBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back, color: Colors.deepOrange, size: 28),
          ),
        ),
        backgroundColor: pinkishBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF7F7),
              Color(0xFFFFF8FF),
            ],
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => context.go('/profilepage'),
              child: _SettingsTile(
                icon: Icons.person_outline,
                text: 'Account',
                onTap: () => context.go('/profilepage'),
                color: Colors.deepOrange,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/notifications'),
              child: _SettingsTile(
                icon: Icons.notifications_none_rounded,
                text: 'Notifications',
                onTap: () => context.push('/notifications'),
                color: Colors.deepOrange,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: _SettingsTile(
                icon: Icons.star_border_rounded,
                text: 'About Us',
                onTap: () => context.go('/aboutus'),
                color: Colors.deepOrange,
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/'),
              child: _SettingsTile(
                icon: Icons.logout_rounded,
                text: 'Sign Out',
                onTap: () => context.go('/'),
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color color;

  const _SettingsTile({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color, size: 28),
          title: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: 'Quicksand',
            ),
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
      ],
    );
  }
} 