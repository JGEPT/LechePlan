class Group {
  final String groupID; //is this necessary? just tangtang it if nah
  final String groupName;
  final String activity;
  final String profile;
  final List<String> members; 
  Group({
    required this.groupID,
    required this.groupName,
    required this.activity,
    required this.profile,
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupID: json['groupID'] ?? '',
      groupName: json['groupName'] ?? '',
      activity: json['activity'] ?? '',
      profile: json['profile'] ?? '', // hmm thinking about a default thing if they dont have pfp
      members: List<String>.from(json['members'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupID': groupID,
      'groupName': groupName,
      'activity': activity,
      'profile': profile,
      'members': members,
    };
  }
} 