import 'package:flutter/material.dart';
import 'package:lecheplan/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lecheplan/models/notification_model.dart' as NotificationModel;
import 'package:lecheplan/services/notifs_services.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel.Notification> allNotifications = [];
  List<NotificationModel.Notification> unreadNotifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await fetchAllNotifications();
      final notifications = response.map((json) => NotificationModel.Notification.fromJson(json)).toList();
      
      setState(() {
        allNotifications = notifications;
        // For now, we'll consider all notifications as unread since there's no read status in the model
        // You can modify this logic later when you add read/unread functionality
        unreadNotifications = notifications;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error - you might want to show a snackbar or error message
      print('Error fetching notifications: $error');
    }
  }

  // Helper method to filter notifications by date
  List<NotificationModel.Notification> _getTodayNotifications(List<NotificationModel.Notification> notifications) {
    final today = DateTime.now();
    final todayLocal = DateTime(today.year, today.month, today.day);
    
    return notifications.where((notification) {
      // Convert notification date to local time first
      final notificationDate = notification.createdAt.toLocal();
      final notificationLocal = DateTime(notificationDate.year, notificationDate.month, notificationDate.day);
      
      return notificationLocal.isAtSameMomentAs(todayLocal);
    }).toList();
  }

  List<NotificationModel.Notification> _getEarlierNotifications(List<NotificationModel.Notification> notifications) {
    final today = DateTime.now();
    final todayLocal = DateTime(today.year, today.month, today.day);
    
    return notifications.where((notification) {
      //convert notification date to local time first
      final notificationDate = notification.createdAt.toLocal();
      final notificationLocal = DateTime(notificationDate.year, notificationDate.month, notificationDate.day);
      
      return notificationLocal.isBefore(todayLocal);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _NotifsAppBar(
        allNotifications: allNotifications,
        unreadNotifications: unreadNotifications,
        isLoading: isLoading,
        onRefresh: _fetchNotifications,
        getTodayNotifications: _getTodayNotifications,
        getEarlierNotifications: _getEarlierNotifications,
      ),
    );
  }
}

class _NotifsAppBar extends StatelessWidget {
  final List<NotificationModel.Notification> allNotifications;
  final List<NotificationModel.Notification> unreadNotifications;
  final bool isLoading;
  final Future<void> Function() onRefresh;
  final Function(List<NotificationModel.Notification>) getTodayNotifications;
  final Function(List<NotificationModel.Notification>) getEarlierNotifications;

  const _NotifsAppBar({
    super.key,
    required this.allNotifications,
    required this.unreadNotifications,
    required this.isLoading,
    required this.onRefresh,
    required this.getTodayNotifications,
    required this.getEarlierNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
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
          preferredSize: const Size.fromHeight(50),
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
            //All notifications tab
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(               
                  children: [
                    //today notifications
                    NotificationsList(
                      title: 'Today', 
                      notifications: getTodayNotifications(allNotifications),
                    ),
                    
                    const SizedBox(height: 10,),
                  
                    //earlier notifications 
                    NotificationsList(
                      title: 'Earlier', 
                      notifications: getEarlierNotifications(allNotifications),
                    ),
                  ],
                ),
              ),
            //Unread notifications tab
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(               
                  children: [
                    //today notifications
                    NotificationsList(
                      title: 'Today', 
                      notifications: getTodayNotifications(unreadNotifications),
                    ),
                    
                    const SizedBox(height: 10,),
                  
                    //earlier notifications 
                    NotificationsList(
                      title: 'Earlier', 
                      notifications: getEarlierNotifications(unreadNotifications),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationsList extends StatelessWidget {
  final String title;
  final List<NotificationModel.Notification> notifications;
  
  const NotificationsList({
    super.key,
    required this.title,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [        
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(
              color: darktextColor,
              fontWeight: FontWeight.w600,
              fontSize: 15
            ),
          )
        ),

        const SizedBox(height: 10,),

        notifications.isEmpty 
          ? Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No notifications',
                  style: TextStyle(
                    color: darktextColor.withAlpha(150),
                    fontSize: 14,
                  ),
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [defaultBoxShadow],
                  ),
                  child: Row(
                    children: [
                      //notification icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: pinkishBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getIconFromType(notification.iconType),
                          color: darktextColor,
                          size: 20,
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      //notif content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.message,
                              style: TextStyle(
                                color: darktextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(notification.createdAt),
                              style: TextStyle(
                                color: darktextColor.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      //action button (optional)
                      Icon(
                        Icons.chevron_right,
                        color: darktextColor.withAlpha(80),
                      ),
                    ],
                  ),
                );
              },
            )
      ],
    );
  }

  // helper method to get Material icon from icon type string
  IconData _getIconFromType(String iconType) {
    switch (iconType) {
      case 'mail':
        return Icons.mail_outline;
      case 'cancel':
        return Icons.cancel_outlined;
      case 'alarm':
        return Icons.alarm;
      case 'person_add':
        return Icons.person_add_outlined;
      case 'group_add':
        return Icons.group_add_outlined;
      case 'person':
        return Icons.person_outline;
      case 'group':
        return Icons.group_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  //helper method to format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
