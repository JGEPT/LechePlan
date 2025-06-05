class Notification {
  final String type;
  final String? activityId;
  final String userId;
  final DateTime createdAt;
  final String? groupParticipantId;
  final String? userParticipantId;
  final String? groupName;
  final String? username;

  Notification({
    required this.type,
    this.activityId,
    required this.userId,
    required this.createdAt,
    this.groupParticipantId,
    this.userParticipantId,
    this.groupName,
    this.username,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: json['type'],
      activityId: json['activity_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      groupParticipantId: json['group_participant_id'],
      userParticipantId: json['user_participant_id'],
      groupName: json['groups']?['groupname'],
      username: json['users']?['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'activity_id': activityId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'group_participant_id': groupParticipantId,
      'user_participant_id': userParticipantId,
      'groupName': groupName,
      'username': username,
    };
  }

  //helper method to get notification message based on type
  String get message {
    switch (type.toLowerCase()) {
      case 'invitation':
        // For invitations, show the group being invited to
        return groupName != null 
          ? 'You were invited to join $groupName'
          : 'You have a new group invitation';
      case 'cancelled':
        // Show who/what cancelled the event
        if (username != null) {
          return '$username cancelled an event';
        } else if (groupName != null) {
          return 'An event in $groupName was cancelled';
        } else {
          return 'An event has been cancelled';
        }
      case 'reminder':
        // Show reminder for specific group or general
        if (groupName != null) {
          return 'Reminder: You have an upcoming event in $groupName';
        } else {
          return 'Reminder: You have an upcoming event';
        }
      case 'friend request':
        // Show who sent the friend request
        return username != null 
          ? '$username sent you a friend request'
          : 'You have a new friend request';
      case 'group add':
        // Show which group you were added to
        return groupName != null 
          ? 'You were added to $groupName'
          : 'You were added to a group';
      default:
        // Generic notification - show username or group name if available
        if (username != null) {
          return '$username sent you a notification';
        } else if (groupName != null) {
          return 'New notification from $groupName';
        } else {
          return 'You have a new notification';
        }
    }
  }

  //helper method to get notification icon based on type
  String get iconType {
    switch (type.toLowerCase()) {
      case 'invitation':
        // Group invitation icon
        return 'group_add';
      case 'cancelled':
        return 'cancel';
      case 'reminder':
        return 'alarm';
      case 'friend request':
        // Personal friend request
        return 'person_add';
      case 'group add':
        // Group addition
        return 'group_add';
      default:
        // Default based on whether it's user or group related
        if (username != null) {
          return 'person';
        } else if (groupName != null) {
          return 'group';
        } else {
          return 'notifications';
        }
    }
  }
} 