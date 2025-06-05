import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final Logger _peopleLogger = Logger('peopleLogger');

Future<List<Map<String, dynamic>>> fetchAllFriends() async {
  try {
    // Get the current user's ID from Supabase auth
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null) {
      _peopleLogger.warning('No authenticated user found');
      return [];
    }
    final userId = currentUser.id;

    // Query to get friends where the current user is either member1 or member2
    final response = await Supabase.instance.client
        .from('friends')
        .select('''
          member1_id,
          member2_id,
          activity,
          user1:user_profiles!friends_member1_id_fkey(
            user_id,
            username,
            profile_photo_url
          ),
          user2:user_profiles!friends_member2_id_fkey(
            user_id,
            username,
            profile_photo_url
          )
        ''')
        .or('member1_id.eq.$userId,member2_id.eq.$userId');

    if (response is List) {
      // Transform the response to only include friend information (excluding the current user)
      return response.cast<Map<String, dynamic>>().map((friendship) {
        final user1 = friendship['user1'] as Map<String, dynamic>;
        final user2 = friendship['user2'] as Map<String, dynamic>;

        // Determine which user is the friend (not the current user)
        final friend = user1['user_id'] == userId ? user2 : user1;

        return {
          'friend_id': friend['user_id'],
          'friend_username': friend['username'],
          'friend_profile_photo': friend['profile_photo_url'],
          'activity': friendship['activity'],
        };
      }).toList();
    } else {
      _peopleLogger.warning(
        'Unexpected response format for fetchAllFriends: $response',
      );
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
      _peopleLogger.warning(
        'Unexpected response format for fetchAllUsers: $response',
      );
      return [];
    }
  } catch (error) {
    _peopleLogger.warning('Error fetching users: $error');
    return []; // Return empty list on error
  }
}
