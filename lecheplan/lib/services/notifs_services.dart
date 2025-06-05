import 'package:supabase_flutter/supabase_flutter.dart'; //for the database
import 'package:logging/logging.dart'; //for adding logs instead of pritning

// types of notifications ===========================
// Invitation
// Cancelled
// Reminder
// Friend Request
// Group Add
// ==================================================

// 11111111-1111-1111-1111-111111111111
// 00000000-0000-0000-0000-000000000003 -- userid
// 00000000-0000-0000-0000-000000000002 -- user-participant-id
// invitation
final Logger _notifsLogger = Logger('notifsLogger');

Future<List<Map<String, dynamic>>> fetchAllNotifications() async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    dynamic response;

    if (userId == null) {
      response = await Supabase.instance.client
        .from('notifications')
        .select('''
          type,
          activity_id,
          user_id,
          created_at,
          group_participant_id,
          user_participant_id,
          groups!group_participant_id(groupname),
          users!user_participant_id(username)
        '''
        );
    }
    else 
    {
      response = await Supabase.instance.client
        .from('notifications')
        .select('''
          type,
          activity_id,
          user_id,
          created_at,
          group_participant_id,
          user_participant_id,
          groups!group_participant_id(groupname),
          users!user_participant_id(username)
        '''
        )
        .eq('user_id', userId) // only show notifications for current user
        .order('created_at', ascending: false);
    }

    return List<Map<String, dynamic>>.from(response);
  } catch (error) {
    _notifsLogger.warning(error);
    return [];
  }
}