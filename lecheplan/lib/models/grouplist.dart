import 'package:lecheplan/models/group_model.dart';

final List<Map<String, dynamic>> groupsJson = [
  {
    'groupID': 'g1',
    'groupName': 'Basketball Team',
    'members': ['James Ty', 'Keane Catedral', 'Lebron James'],
    'activity': '2 upcoming activities planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'groupID': 'g2',
    'groupName': 'Study Group',
    'members': ['Emma Watson', 'Ishah Bautista', 'Hya Kanazawa'],
    'activity': '1 upcoming activity planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'groupID': 'g3',
    'groupName': 'Block B',
    'members': ['JPTY', 'Keane Cat', 'HK', 'Ishah Bautista'],
    'activity': '3 upcoming activities planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'groupID': 'g4',
    'groupName': 'Gym Friends',
    'members': ['James Ty', 'Emma Watson', 'Ishah Bau'],
    'activity': 'No upcoming activities',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
];

final List<Group> sampleGroups = groupsJson.map((json) => Group.fromJson(json)).toList(); 