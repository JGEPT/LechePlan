import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final Logger _peopleLogger = Logger('peopleLogger');

Future<List<Map<String, dynamic>>> fetchAllFriends() async {
  try {
    // Temporarily hardcoded userId for testing
    final userId = '00000000-0000-0000-0000-000000000001';

    // Joining the users table to fetch friends and select the username
    final response = await Supabase.instance.client
      .from('friends')
      .select('member1_id, member2_id, activity, user1:users!friends_member1_id_fkey(username), user2:users!friends_member2_id_fkey(username)')
      .or('member1_id.eq.$userId,member2_id.eq.$userId');

    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    } else {
       _peopleLogger.warning('Unexpected response format for fetchAllFriends: $response');
       return [];
    }

  } catch (error) {
    _peopleLogger.warning('Error fetching friends: $error');
    return []; // Return empty list on error
  }
}

Future<List<Map<String, dynamic>>> fetchAllGroups() async {
  try {
    // Temporarily hardcoded userId for testing
    final userId = '00000000-0000-0000-0000-000000000001';

    // Fetch groups the user is a member of, including group details and member usernames
    final response = await Supabase.instance.client
      .from('group_members')
      .select('group_id, groups!inner(group_id, groupname, activity, group_members(member_id, users(username)))')
      .eq('member_id', userId);

    if (response is List) {
      // The response structure will be a list of group_members entries.
      // We need to extract the nested group data.
      return response.map((entry) => entry['groups'] as Map<String, dynamic>).toList();
    } else {
      _peopleLogger.warning('Unexpected response format for fetchAllGroups: $response');
      return [];
    }

  } catch (error) {
    _peopleLogger.warning('Error fetching groups: $error');
    return []; // Return empty list on error
  }
}

Future<List<Map<String, dynamic>>> fetchAllUsers() async {
  try {
    final response = await Supabase.instance.client
      .from('users')
      .select('user_id, username'); // Select user_id and username

    if (response is List) {
      return response.cast<Map<String, dynamic>>();
    } else {
      _peopleLogger.warning('Unexpected response format for fetchAllUsers: $response');
      return [];
    }

  } catch (error) {
    _peopleLogger.warning('Error fetching users: $error');
    return []; // Return empty list on error
  }
}
