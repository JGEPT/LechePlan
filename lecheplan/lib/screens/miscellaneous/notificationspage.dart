import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState(); 
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: pinkishBackgroundColor,
      child: Stack(
        
        children: [
          //notifications header
          SafeArea(
            
            child: Row(
              //notifications text
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: darktextColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,                    
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}