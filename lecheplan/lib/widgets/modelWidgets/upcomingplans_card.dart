import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:intl/intl.dart';

//model inmports
import 'package:lecheplan/models/plan_model.dart';

class UpcomingplansCard extends StatelessWidget {
  final Plan currentPlan;

  const UpcomingplansCard({super.key, required this.currentPlan});

  void goToActivityDetails(){ //fill this in should take you to the specific activity details yup2
    return;
  }

  @override
  Widget build(BuildContext context) {
    //format the date and time
    DateTime dateTime = DateTime.parse(currentPlan.planDateTime.toString());
    DateFormat formatter = DateFormat('MMMM, d, y  ●  h:mm a');
    final String formattedDateTime = formatter.format(dateTime);

    return GestureDetector(
      onTap: goToActivityDetails,
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: pinkishBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [defaultBoxShadow],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //text leftside
            cardTextDetails(formattedDateTime),
      
            //right side overlapping avatars,
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/sampleAvatar.jpg'),
              radius: 30,
            ),
          ],
        ),
      ),
    );
  }

  Column cardTextDetails(String formattedDateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //activity title
        Text(
          currentPlan.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: darktextColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),

        //groupname
        RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'with ',
            style: TextStyle(
              height: 1,
              fontFamily: 'Quicksand',
              color: darktextColor,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),

            children: [
              TextSpan(
                text: currentPlan.participants.join(
                  ', ',
                ), //converts from list to string with separator ,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: orangeAccentColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        //date and time
        Text(
          formattedDateTime,
          style: TextStyle(
            fontFamily: 'Quicksand',
            color: darktextColor.withAlpha(150),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
