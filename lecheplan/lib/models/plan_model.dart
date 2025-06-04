class Plan {
  final String planID;
  final String title;
  final String category;
  final DateTime planDateTime;
  final List<String> participants;
  final List<String> tags;
  final List<String> avatarAssets;

  Plan({
    required this.planID,
    required this.title,
    required this.category,
    required this.planDateTime,
    required this.participants,
    required this.tags,
    required this.avatarAssets,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planID: json['planID'],
      title: json['title'],
      category: json['category'],
      planDateTime: DateTime.parse(json['planDateTime']),
      participants: List<String>.from(json['participants']),
      tags: List<String>.from(json['tags']),
      avatarAssets: [], // Not loaded from JSON, only used for local sample data
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
      // avatarAssets intentionally omitted
    };
  }
}
