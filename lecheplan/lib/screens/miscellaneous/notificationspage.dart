import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _NotifsAppBar(), //the apps bar will hold everything already -- tabs will hold the indices
    );
  }
}

class _NotifsAppBar extends StatelessWidget {
  const _NotifsAppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: BackButton(onPressed: () {context.pop();},), //will go back to prev if used context.push
        backgroundColor: pinkishBackgroundColor,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: darktextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_rounded,
              color: darktextColor,
            ),
          ),
        ],
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          //use contianer to determine the look of the actual tab bar
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
            height: 35,
            decoration: BoxDecoration(              
              color: greyAccentColor,
              borderRadius: BorderRadius.circular(10)            
            ),
            child: Material( //material for changing the shape of the inkwell to be rounded 2
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,

              child: TabBar(          
                //labels
                labelStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: 13
                ),                
                unselectedLabelColor: darktextColor,
                labelColor: darktextColor,
              
                //indicator
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [defaultBoxShadow]
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(5),
                indicatorAnimation: TabIndicatorAnimation.elastic,
                dividerHeight: 0, //this removes that annoying line this took way too long to figure out idk why
                //contente
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: 'Unread'),
                ],
              ),
            ),
          ),
        ),
      ),
    
    
      body: Container(
        color: pinkishBackgroundColor,
        padding: const EdgeInsets.all(20),
        child: TabBarView(
          children: [
            //currently temporary, still need to make a list of notifications possible      
            //
            //coulumn will hold both today and earlier notifications     
            ListView(               
              children: [
                //today notifications
                TodayNotificationsList(),
                
                const SizedBox(height: 10,),
              
                //earlier notifications 
                EarlierNotificationsList(),
              ],
            ),
            Icon(Icons.mark_unread_chat_alt),
          ],
        ),
      ),
    );
  }
}

//make all and unread versions? I guess we'll see how to impement this 
class TodayNotificationsList extends StatelessWidget {
  const TodayNotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Today',
            style: TextStyle(
              color: darktextColor,
              fontWeight: FontWeight.w600,
              fontSize: 15
            ),
          )
        ),

        const SizedBox(height: 10,),

        ...List.generate(2, (index) {
          return Container(
            color: orangeAccentColor.withAlpha(50),
            height: 50,
            width: double.infinity,
          );
        })
      ],
    );
  }
}

//please refactor this to be one widget just for today and earlier to be the same :P
class EarlierNotificationsList extends StatelessWidget {
  const EarlierNotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Earlier',
            style: TextStyle(
              color: darktextColor,
              fontWeight: FontWeight.w600,
              fontSize: 15
            ),
          )
        ),

        const SizedBox(height: 10,),

        ...List.generate(20, (index) {
          return Container(
            color: orangeAccentColor.withAlpha(50),
            height: 50,
            width: double.infinity,
          );
        })
      ],
    );
  }
}

