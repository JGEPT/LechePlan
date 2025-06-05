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

Future<Map<String, dynamic>> createPlan({
  required String title,
  required String category,
  required DateTime planDateTime,
  required DateTime endDateTime,
  required List<String> participantUsernames,
  List<String>? tags,
}) async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      _mainhubLogger.warning('Cannot create plan: No user logged in');
      return {
        'success': false,
        'message': 'You must be logged in to create a plan',
      };
    }

    // First get the user IDs for all participants
    final List<Map<String, dynamic>> userProfiles = await Supabase
        .instance
        .client
        .from('user_profiles')
        .select('user_id, username')
        .inFilter('username', participantUsernames);

    if (userProfiles.isEmpty) {
      return {'success': false, 'message': 'No valid participants found'};
    }

    // Create the plan
    final planDate = planDateTime.toIso8601String().split('T')[0];
    final startTime = planDateTime
        .toIso8601String()
        .split('T')[1]
        .substring(0, 5); // HH:mm
    final endTime = endDateTime
        .toIso8601String()
        .split('T')[1]
        .substring(0, 5); // HH:mm
    final planResponse =
        await Supabase.instance.client
            .from('plans')
            .insert({
              'title': title,
              'category': category,
              'date': planDate,
              'start_time': startTime,
              'end_time': endTime,
              'tags': tags ?? [],
              'created_at': DateTime.now().toIso8601String(),
              'user_id': userId,
            })
            .select()
            .single();

    if (planResponse == null) {
      return {'success': false, 'message': 'Failed to create plan'};
    }

    // Add participants
    final List<Map<String, dynamic>> participantRecords =
        userProfiles.map((profile) {
          return {
            'plan_id': planResponse['plan_id'],
            'participant_id': profile['user_id'],
            'created_at': DateTime.now().toIso8601String(),
          };
        }).toList();

    await Supabase.instance.client
        .from('plan_participants')
        .insert(participantRecords);

    // Add creator as participant if not already included
    if (!participantUsernames.contains(
      userProfiles.firstWhere(
        (p) => p['user_id'] == userId,
        orElse: () => {'username': ''},
      )['username'],
    )) {
      await Supabase.instance.client.from('plan_participants').insert({
        'plan_id': planResponse['plan_id'],
        'participant_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    _mainhubLogger.info(
      'Plan created successfully: ${planResponse['plan_id']}',
    );
    return {
      'success': true,
      'message': 'Plan created successfully',
      'plan': planResponse,
    };
  } catch (error) {
    _mainhubLogger.severe('Error creating plan: $error');
    return {'success': false, 'message': 'Failed to create plan: $error'};
  }
}
