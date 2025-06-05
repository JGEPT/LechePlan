import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final Logger _peopleLogger = Logger('peopleLogger');

Future<List<Map<String, dynamic>>> fetchAllFriends() async {
  try {
    // Temporarily hardcoded userId for testing
    final userId = '00000000-0000-0000-0000-000000000001';

    // Joining the user_profiles table to fetch friends and select the username
    final response = await Supabase.instance.client
      .from('friends')
      .select('member1_id, member2_id, activity, user1:user_profiles!friends_member1_id_fkey(username), user2:user_profiles!friends_member2_id_fkey(username)')
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

Future<List<Map<String, dynamic>>> fetchAllUsers() async {
  try {
    final response = await Supabase.instance.client
      .from('user_profiles')
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
