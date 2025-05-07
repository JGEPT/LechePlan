import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';

//model inmports 
import 'package:lecheplan/models/plan_model.dart';

class UpcomingplansCard extends StatelessWidget{
  final Plan currentPlan;

  const UpcomingplansCard({
    super.key,
    required this.currentPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 80,
      child: Row(
        children: [
          //text leftside
          Column(
            children: [
              Text(
                currentPlan.title,
                style: TextStyle(

                ),
              )
            ],
          )
        ],
      ),
    );
  }
}