import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

final Logger _authLogger = Logger('AuthService');

class AuthService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Register a new user
  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _authLogger.info('Attempting to sign up user with email: $email');
      
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _authLogger.warning('Sign up failed: No user returned');
        return {
          'success': false,
          'message': 'Registration failed. Please try again.',
        };
      }

      _authLogger.info('User signed up successfully: ${response.user!.id}');
      
      return {
        'success': true,
        'message': 'Account created successfully!',
        'user': response.user,
      };
    } on AuthException catch (e) {
      _authLogger.severe('Auth exception during sign up: ${e.message}');
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      _authLogger.severe('Unexpected error during sign up: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Create user profile in the users table
  static Future<Map<String, dynamic>> createUserProfile({
    required String userId,
    required String email,
    String? username,
    User? authenticatedUser,
  }) async {
    try {
      _authLogger.info('Creating user profile for user: $userId');
      
      // Use the passed user or try to get current user
      User? userToUse = authenticatedUser ?? _client.auth.currentUser;
      
      if (userToUse == null) {
        _authLogger.warning('No authenticated user found when creating profile');
        return {
          'success': false,
          'message': 'User not authenticated',
        };
      }

      _authLogger.info('Using authenticated user ID: ${userToUse.id}');
      
      // Debug: Check auth session details
      final session = _client.auth.currentSession;
      _authLogger.info('Auth session status: ${session != null ? 'Active' : 'None'}');
      if (session != null) {
        _authLogger.info('Session access token: ${session.accessToken.substring(0, 20)}...');
      }
      
      // Generate a default username if not provided
      final defaultUsername = username ?? email.split('@')[0];
      
      _authLogger.info('Attempting to insert profile with data: user_id=${userToUse.id}, username=$defaultUsername, email=$email');
      
      // Use the authenticated user's ID to ensure it matches auth.uid()
      final response = await _client.from('user_profiles').insert({
        'user_id': userToUse.id,
        'username': defaultUsername,
        'user_email': email,
        'created_at': DateTime.now().toIso8601String(),
      }).select();

      if (response.isEmpty) {
        _authLogger.warning('Failed to create user profile - empty response');
        return {
          'success': false,
          'message': 'Failed to create user profile',
        };
      }

      _authLogger.info('User profile created successfully');
      return {
        'success': true,
        'message': 'User profile created successfully',
        'profile': response.first,
      };
    } catch (e) {
      _authLogger.severe('Error creating user profile: $e');
      return {
        'success': false,
        'message': 'Failed to create user profile: $e',
      };
    }
  }

  // Complete sign up process (auth + profile creation)
  static Future<Map<String, dynamic>> completeSignUp({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      // First, try to create the auth user
      final authResult = await signUp(email: email, password: password);
      
      User? userToUse;
      
      if (!authResult['success']) {
        // If signup failed because user already exists, try to sign in
        if (authResult['message'].toString().toLowerCase().contains('already registered')) {
          _authLogger.info('User already exists, attempting sign in instead...');
          final signInResult = await signIn(email: email, password: password);
          
          if (!signInResult['success']) {
            return signInResult;
          }
          
          userToUse = signInResult['user'] as User;
          _authLogger.info('Successfully signed in existing user');
        } else {
          return authResult;
        }
      } else {
        userToUse = authResult['user'] as User;
      }

      // If no session was created, try to sign in to establish one
      final session = _client.auth.currentSession;
      if (session == null) {
        _authLogger.info('No session found after signup, attempting sign in...');
        final signInResult = await signIn(email: email, password: password);
        
        if (!signInResult['success']) {
          _authLogger.warning('Failed to establish session after signup');
          // Still try to create profile with the user object
        } else {
          _authLogger.info('Session established successfully after signup');
        }
      }

      // Then create the user profile using the authenticated user
      final profileResult = await createUserProfile(
        userId: userToUse!.id,
        email: email,
        username: username,
        authenticatedUser: userToUse,
      );

      if (!profileResult['success']) {
        _authLogger.warning('Profile creation failed after successful auth');
        return profileResult;
      }

      return {
        'success': true,
        'message': 'Account ready successfully!',
        'user': userToUse,
        'profile': profileResult['profile'],
      };
    } catch (e) {
      _authLogger.severe('Error in complete sign up: $e');
      return {
        'success': false,
        'message': 'Failed to complete registration: $e',
      };
    }
  }

  // Sign in user
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _authLogger.info('Attempting to sign in user with email: $email');
      
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _authLogger.warning('Sign in failed: No user returned');
        return {
          'success': false,
          'message': 'Sign in failed. Please check your credentials.',
        };
      }

      _authLogger.info('User signed in successfully: ${response.user!.id}');
      
      return {
        'success': true,
        'message': 'Signed in successfully!',
        'user': response.user,
      };
    } on AuthException catch (e) {
      _authLogger.severe('Auth exception during sign in: ${e.message}');
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      _authLogger.severe('Unexpected error during sign in: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
    }
  }

  // Sign out user
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      _authLogger.info('User signed out successfully');
    } catch (e) {
      _authLogger.severe('Error signing out: $e');
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // Check if user is signed in
  static bool isSignedIn() {
    return _client.auth.currentUser != null;
  }
} 