class Plan {
  final String planID;
  final String title;
  final String category;
  final DateTime planDateTime;
  final List<String> participants; // usernames
  final List<String> tags;
  final List<String> profilePhotoUrls; // new: profile photo URLs

  Plan({
    required this.planID,
    required this.title,
    required this.category,
    required this.planDateTime,
    required this.participants,
    required this.tags,
    required this.profilePhotoUrls,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planID: json['planID'],
      title: json['title'],
      category: json['category'],
      planDateTime: DateTime.parse(json['planDateTime']),
      participants: List<String>.from(json['participants']),
      tags: List<String>.from(json['tags']),
      profilePhotoUrls: List<String>.from(json['profilePhotoUrls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planID': planID,
      'title': title,
      'category': category,
      'planDateTime': planDateTime.toIso8601String(),
      'participants': participants,
      'tags': tags,
      'profilePhotoUrls': profilePhotoUrls,
    };
  }
}
