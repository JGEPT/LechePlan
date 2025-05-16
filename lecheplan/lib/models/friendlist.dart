import 'package:lecheplan/models/friends_model.dart';

// lazy JSON file to test the page
final List<Map<String, dynamic>> friendsJson = [
  {
    'userID': 'f1',
    'name': 'Ishah Bautista',
    'activity': '1 upcoming activity planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f2',
    'name': 'James Ty',
    'activity': '2 upcoming activities planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f3',
    'name': 'Keane Catedral',
    'activity': 'No upcoming activities',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f4',
    'name': 'Hya Kanazawa',
    'activity': '3 upcoming activities planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f5',
    'name': 'Ishah Bau',
    'activity': '1 upcoming activity planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f6',
    'name': 'JPTY',
    'activity': '1 upcoming activity planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f7',
    'name': 'Keane Cat',
    'activity': '2 upcoming activities planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f8',
    'name': 'HK',
    'activity': 'No upcoming activities',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f9',
    'name': 'Lebron James',
    'activity': '3 upcoming activities planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
  {
    'userID': 'f10',
    'name': 'Emma Watson',
    'activity': '1 upcoming activity planned',
    'profile': 'assets/images/sampleAvatar.jpg',
  },
];


final List<Friend> sampleFriends = friendsJson.map((json) => Friend.fromJson(json)).toList(); 