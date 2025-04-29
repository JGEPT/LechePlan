import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class Custombackbutton extends StatelessWidget {
  const Custombackbutton(
    {
      super.key,
      required this.destinationString,
    }
  );

  final String destinationString;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        context.go('/');
      },

      child: Icon(
        Icons.arrow_back_rounded,
        size: 25,
        color: darktextColor.withValues(alpha: (255 * 0.05)),

      ),
    );
  }
}