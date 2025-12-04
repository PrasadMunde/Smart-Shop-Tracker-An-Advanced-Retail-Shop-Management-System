import 'package:supabase_flutter/supabase_flutter.dart';

class SignupDataService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> registerUser(String email, String password, String name, String phone) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(email: email, password: password);

      if (response.user == null) {
        throw Exception('User registration failed');
      }

      await _supabase.from('profiles').insert({
        'id': response.user?.id,
        'name': name,
        'phone': phone,
      });
      print('User registered successfully');
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }
}
