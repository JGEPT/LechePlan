class Group {
  final String groupID; //is this necessary? just tangtang it if nah
  final String groupName;
  final String groupProfile;
  final int memberCount;
  final String activity;
  final List<String> members;
  Group({
    required this.groupID,
    required this.groupName,
    required this.groupProfile,
    required this.memberCount,
    this.activity = '',
    this.members = const [],
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupID: json['group_id'] ?? json['groupID'] ?? '',
      groupName: json['groupname'] ?? json['groupName'] ?? '',
      groupProfile: json['group_profile'] ?? '',
      memberCount: json['memberCount'] ?? 0,
      activity: json['activity'] ?? '',
      members:
          json['members'] != null ? List<String>.from(json['members']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupID,
      'groupname': groupName,
      'group_profile': groupProfile,
      'memberCount': memberCount,
      'activity': activity,
      'members': members,
    };
  }
}
