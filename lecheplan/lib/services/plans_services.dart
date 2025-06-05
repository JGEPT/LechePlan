import 'package:supabase_flutter/supabase_flutter.dart'; //for the database
import 'package:logging/logging.dart'; //for adding logs instead of pritning

final Logger _mainhubLogger = Logger('mainhubLogger');

//fetch data from the database
Future<List<Map<String, dynamic>>> fetchAllUserPlans() async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    dynamic response;

    // no user logged in: get ALL plans with date >= today -- using anon key
    if (userId == null) {
      response = await Supabase.instance.client
          .from('plans')
          .select(
            '*, plan_participants(*, user_profiles(username, profile_photo_url))',
          );
    } else {
      // User logged in: get only their plans
      response = await Supabase.instance.client
          .from('plan_participants')
          .select(
            'plans(*, plan_participants(*, user_profiles(username, profile_photo_url)))',
          )
          .eq('participant_id', userId);
    }

    List<Map<String, dynamic>> upcomingPlansList;

    if (userId == null) {
      // fetching from 'plans', response is already a list of plans
      upcomingPlansList =
          (response as List).map((e) => e as Map<String, dynamic>).toList()
            ..sort((a, b) => a['date'].compareTo(b['date']));
    } else {
      // fetching from 'plan_participants', extract the joined plan into a list
      upcomingPlansList =
          (response as List)
              .map((e) => e['plans'] as Map<String, dynamic>)
              .toList()
            ..sort((a, b) => a['date'].compareTo(b['date']));
    }

    return upcomingPlansList;
  } catch (error) {
    _mainhubLogger.warning(error);
    return []; // Return empty list on error
  }
}

Future<List<Map<String, dynamic>>> fetchAllUsers() async {
  try {
    final response = await Supabase.instance.client
        .from('user_profiles')
        .select('username, profile_photo_url');
    return (response as List).map((e) => e as Map<String, dynamic>).toList();
  } catch (error) {
    _mainhubLogger.warning(error);
    return [];
  }
}
