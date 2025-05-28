class Friend {
  final String userID;
  final String name;
  final String activity;
  final String profile;

  Friend({
    required this.userID,
    required this.name,
    required this.activity,
    required this.profile,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userID: json['userID'] ?? '',
      name: json['name'] ?? '',
      activity: json['activity'] ?? '',
      profile: json['profile'] ?? '', // hmm thinking about a default thing if they dont have pfp
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'name': name,
      'activity': activity,
      'profile': profile,
    };
  }
} 