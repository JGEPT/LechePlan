import 'package:supabase_flutter/supabase_flutter.dart'; //for the database
import 'package:logging/logging.dart'; //for adding logs instead of pritning
import 'package:supabase_flutter/supabase_flutter.dart' show CountOption;

final Logger _mainhubLogger = Logger('mainhubLogger');

//fetch data from the database
Future<List<Map<String, dynamic>>> fetchAllGroups() async {
  try {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _mainhubLogger.warning('User not logged in');
      return [];
    }

    final response = await Supabase.instance.client
        .from('groups')
        .select('''
          group_id,
          groupname,
          group_profile,
          group_members!inner(
            member_id,
            user_profiles!group_members_participant_id_fkey(
              user_id,
              username,
              profile_photo_url
            )
          )
        ''')
        .eq('group_members.member_id', user.id);
    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  } catch (error) {
    _mainhubLogger.warning(error);
    return [];
  }
}

Future<List<Map<String, dynamic>>> fetchGroupMembers(String groupId) async {
  try {
    final response = await Supabase.instance.client
        .from('group_members')
        .select('user_profiles(user_id, username, profile_photo_url)')
        .eq('group_id', groupId);
    // The response is a list of maps with a 'user_profiles' key
    return (response as List)
        .map((e) => e['user_profiles'] as Map<String, dynamic>)
        .where((user) => user != null)
        .toList();
  } catch (error) {
    _mainhubLogger.warning(error);
    return [];
  }
}

Future<int> fetchGroupMemberCount(String groupId) async {
  try {
    final response = await Supabase.instance.client
        .from('group_members')
        .select('*')
        .eq('group_id', groupId);
    return (response as List).length;
  } catch (error) {
    _mainhubLogger.warning(error);
    return 0;
  }
}
