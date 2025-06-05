import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'dart:io';

final Logger _profileLogger = Logger('ProfileService');

class ProfileService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Update user profile information
  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? username,
    String? firstName,
    String? lastName,
    String? bio,
    String? phoneNumber,
    String? address,
    String? profilePhotoUrl,
  }) async {
    try {
      _profileLogger.info('Updating profile for user: $userId');

      final updateData = <String, dynamic>{};
      
      if (username != null) updateData['username'] = username;
      if (firstName != null && lastName != null) {
        updateData['name'] = '$firstName $lastName'.trim();
      }
      if (bio != null) updateData['user_bio'] = bio;
      if (phoneNumber != null) updateData['user_cont_number'] = phoneNumber;
      if (address != null) updateData['user_address'] = address;
      if (profilePhotoUrl != null) updateData['profile_photo_url'] = profilePhotoUrl;

      final response = await _client
          .from('user_profiles')
          .update(updateData)
          .eq('user_id', userId)
          .select();

      if (response.isEmpty) {
        _profileLogger.warning('No profile found to update for user: $userId');
        return {
          'success': false,
          'message': 'Profile not found',
        };
      }

      _profileLogger.info('Profile updated successfully for user: $userId');
      return {
        'success': true,
        'message': 'Profile updated successfully',
        'profile': response.first,
      };
    } catch (e) {
      _profileLogger.severe('Error updating profile: $e');
      return {
        'success': false,
        'message': 'Failed to update profile: $e',
      };
    }
  }

  // Upload profile image to Supabase Storage
  static Future<Map<String, dynamic>> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      _profileLogger.info('Uploading profile image for user: $userId');

      // Check if file exists and is readable
      if (!await imageFile.exists()) {
        _profileLogger.severe('Image file does not exist: ${imageFile.path}');
        return {
          'success': false,
          'message': 'Image file not found',
        };
      }

      final fileSize = await imageFile.length();
      _profileLogger.info('Image file size: ${fileSize} bytes');

      // Organize files in user-specific folders to match RLS policies
      final fileName = '$userId/profile.jpg';
      
      _profileLogger.info('Attempting to upload to bucket: user-avatar, path: $fileName');

      // Upload image to Supabase Storage
      final uploadResponse = await _client.storage
          .from('user-avatar')
          .upload(fileName, imageFile, fileOptions: const FileOptions(upsert: true));

      _profileLogger.info('Upload response: $uploadResponse');

      // Get public URL
      final publicUrl = _client.storage
          .from('user-avatar')
          .getPublicUrl(fileName);

      _profileLogger.info('Profile image uploaded successfully: $publicUrl');
      
      return {
        'success': true,
        'message': 'Image uploaded successfully',
        'url': publicUrl,
      };
    } catch (e) {
      _profileLogger.severe('Error uploading profile image: $e');
      
      // Provide more specific error information
      String errorMessage = 'Failed to upload image';
      if (e.toString().contains('permission')) {
        errorMessage = 'Permission denied. Please check storage bucket policies.';
      } else if (e.toString().contains('bucket')) {
        errorMessage = 'Storage bucket not found or not accessible.';
      } else if (e.toString().contains('file')) {
        errorMessage = 'File could not be processed.';
      } else {
        errorMessage = 'Upload failed: $e';
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    }
  }

  // Save user interests
  static Future<Map<String, dynamic>> saveUserInterests({
    required String userId,
    required List<String> interests,
  }) async {
    try {
      _profileLogger.info('Saving interests for user: $userId');

      // First, delete existing interests
      await _client
          .from('userinterest')
          .delete()
          .eq('user_id', userId);

      // Insert new interests
      if (interests.isNotEmpty) {
        // Get interest IDs from the interests table
        final userInterestRecords = <Map<String, dynamic>>[];
        
        for (String interestName in interests) {
          // Try to find existing interest
          final existingInterest = await _client
              .from('interests')
              .select('id')
              .eq('interest_name', interestName)
              .maybeSingle();

          String interestId;
          if (existingInterest != null) {
            // Use existing interest ID
            interestId = existingInterest['id'];
          } else {
            // Create new interest
            final newInterest = await _client
                .from('interests')
                .insert({
                  'interest_name': interestName,
                  'created_at': DateTime.now().toIso8601String(),
                })
                .select('id')
                .single();
            interestId = newInterest['id'];
          }

          // Add to user interest records
          userInterestRecords.add({
            'user_id': userId,
            'interest_id': interestId,
            'created_at': DateTime.now().toIso8601String(),
          });
        }

        // Insert user-interest relationships
        await _client
            .from('userinterest')
            .insert(userInterestRecords);

        _profileLogger.info('${interests.length} interests saved for user: $userId');
      }

      return {
        'success': true,
        'message': 'Interests saved successfully',
      };
    } catch (e) {
      _profileLogger.severe('Error saving interests: $e');
      return {
        'success': false,
        'message': 'Failed to save interests: $e',
      };
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      _profileLogger.info('Fetching profile for user: $userId');

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .single();

      return {
        'success': true,
        'profile': response,
      };
    } catch (e) {
      _profileLogger.severe('Error fetching profile: $e');
      return {
        'success': false,
        'message': 'Failed to fetch profile: $e',
      };
    }
  }

  // Get user interests
  static Future<Map<String, dynamic>> getUserInterests(String userId) async {
    try {
      _profileLogger.info('Fetching interests for user: $userId');

      final response = await _client
          .from('userinterest')
          .select('interests(interest_name)')
          .eq('user_id', userId);

      final interests = (response as List)
          .map((item) => item['interests']['interest_name'] as String)
          .toList();

      return {
        'success': true,
        'interests': interests,
      };
    } catch (e) {
      _profileLogger.severe('Error fetching interests: $e');
      return {
        'success': false,
        'message': 'Failed to fetch interests: $e',
        'interests': <String>[],
      };
    }
  }
} 