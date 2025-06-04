import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

//widget imports 
import 'package:lecheplan/widgets/modelWidgets/interests_pill.dart';
import 'package:lecheplan/widgets/reusableWidgets/custom_filledbutton.dart';

class ActivityRecommendationPage extends StatefulWidget {
  const ActivityRecommendationPage({super.key});

  @override
  State<ActivityRecommendationPage> createState() => _ActivityRecommendationPageState();
}

class _ActivityRecommendationPageState extends State<ActivityRecommendationPage> {
  List<String> combinedInterestsList = []; //set as empty for the meantime befoore anyone is chosene

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 1,
        leading: BackButton(onPressed: () {
          context.pop();
        }),
        backgroundColor: pinkishBackgroundColor,
        elevation: 0,
        title: Text(
          'Activity \nRecommendation',
          style: TextStyle(
            height: 0.9,
            color: orangeAccentColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.info_outline_rounded,
              color: darktextColor,
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: darktextColor.withAlpha(150),
          ),
        ),
      ),            

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //top half of the page
            Column(
              children: [
            
                // top most widget for choosing the participants 
                ChooseParticipants(),
            
                SizedBox(height: 10,),
            
                //combined interests
                CombinedInterests(interestsList: combinedInterestsList,)
              ],
            ),

            // -- separated so they could be spaced between --
            
            //bottom half of the page 
            Customfilledbutton(
              buttonHeight: 30,
              buttonWidth: double.infinity,
              buttonFillColor: orangeAccentColor,
              buttonRadius: 100,
              textColor: Colors.white,
              buttonLabel: "Generate Ideas",
              pressAction: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class CombinedInterests extends StatelessWidget {
  final List<String> interestsList;

  const CombinedInterests({
    super.key,
    required this.interestsList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(              
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Combined Interests:",
          style: TextStyle(
            fontSize: 15,
            color: darktextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
    
        SizedBox(height: 5),
    
        //container of the pills
        InterestsPillsContainer(interestsList: interestsList),                         
      ],
    );
  }
}

class InterestsPillsContainer extends StatelessWidget {
  const InterestsPillsContainer({
    super.key,
    required this.interestsList,
  });

  final List<String> interestsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,                  
      padding: EdgeInsets.symmetric(vertical: 5),          
      child: interestsList.isEmpty
        ? Container( //shows if there is nothing inside the list
            width: double.infinity,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: greyAccentColor,
              border: Border.all(
                color: darktextColor.withAlpha(100),
                width: 1,                    
              ),
              borderRadius: BorderRadius.circular(40),
            ),                
            child: Center(
              child: Text(
                "Please select a friend or group first.",
                style: TextStyle(
                  color: darktextColor.withAlpha(200),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        : _InterestsList(interestsList: interestsList),
    );
  }
}

class ChooseParticipants extends StatelessWidget {
  const ChooseParticipants({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose People or Groups:",
          style: TextStyle(
            fontSize: 15,
            color: darktextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: 5),
        
        //actual container of the people 
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: pinkishBackgroundColor,
            border: Border.all(
              width: 2,
              color: greyAccentColor,
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Row( //probably replace with listview builder with the people chosen
            spacing: 10,
            children: [
              // Avatar and name
              ParticipantIcon(participantAvatar: AssetImage('assets/images/sampleAvatar.jpg'), participantName: "Placeholder"),
              //add more should always be here and should be clickable so
              AddMoreIcon(participantAvatar: AssetImage('assets/images/sampleAvatar.jpg'), participantName: "Add More"),
            ],
          ),
        ),            
      ],
    );
  }
}

class ParticipantIcon extends StatelessWidget {
  final String  participantName;
  final AssetImage participantAvatar;

  const ParticipantIcon({
    super.key,
    required this.participantAvatar,
    required this.participantName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        //avatar 
        CircleAvatar(
          backgroundImage: participantAvatar,
          radius: 30,
        ),
        //name of person or group
        Text(
          participantName,
          style: TextStyle(
            fontSize: 10,
            color: darktextColor.withAlpha(200),
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class AddMoreIcon extends StatelessWidget {
  final String  participantName;
  final AssetImage participantAvatar;

  const AddMoreIcon({
    super.key,
    required this.participantAvatar,
    required this.participantName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        //avatar 
        CircleAvatar(
          backgroundColor: darktextColor.withAlpha(50),          
          radius: 30,
        ),
        //name of person or group
        Text(
          participantName,
          style: TextStyle(
            fontSize: 10,
            color: darktextColor.withAlpha(200),
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class _InterestsList extends StatelessWidget {
  final List<String> interestsList; 

  const _InterestsList(
    {
      required this.interestsList,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              spacing: 5,
              runSpacing: 7,
              alignment: WrapAlignment.center,
              children: interestsList 
                  .map((interest) => InterestsPill(item: interest)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}