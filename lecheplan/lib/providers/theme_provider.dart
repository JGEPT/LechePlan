import 'package:flutter/material.dart';

//flat colors 
final Color darktextColor = Color(0xFF0E1342);
final Color lighttextColor = Color(0xFFFFFFFF);
final Color orangeAccentColor = Color(0xFFFD5903);
final Color lightAccentColor = Color(0xFFF5EDE7);
final Color greyAccentColor = Color(0xFFF3F1EF);
final Color redBubbleColor = Color(0xFFFF4A4D);
final Color unselectedGreyColor = Color(0xFF222222);
final Color pinkishBackgroundColor = Color(0xFFFEF7FF);

//gradient colors
final LinearGradient orangeGradient = LinearGradient(colors: [Color(0xFFFF803D), Color(0xFFFF835A)]);
final LinearGradient whiteGradientBg = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFFFFF), Color(0xFFFEEFFF)]);

//shadows -- please use sparingly
final Shadow defaultShadow = Shadow(color: Colors.black12, offset: Offset(1, 2), blurRadius: 5,);