import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../dashboard/dashboard.dart';
import '../../forget_password/forget_password_model_button_sheet.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cemail = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> _loginUser() async {
    final email = _cemail.text.trim();
    final password = _password.text.trim();
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('email', email)
          .eq('password', password)
          .single();

      if (response != null) {
        final user = Map<String, dynamic>.from(response);
        String uidd = user['uid'].toString();

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uidd);

        _showErrorMessage("Login Successfully .....");

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
        );
      } else {
        _showErrorMessage("Invalid email or password.");
      }
    } catch (error) {
      _showErrorMessage("An error occurred. Please try again.");
      print("Error: $error"); // Log the error for debugging
    }
  }


  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _cemail,
              decoration: const InputDecoration(
                label: Text(tEmail),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return "Please enter valid email";
                }
                return null;
              },
            ),
            SizedBox(
              height: tFormHeight,
            ),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                label: Text('Password'),
                prefixIcon: Icon(Icons.fingerprint_sharp),
                suffixIcon: Icon(Icons.remove_red_eye_sharp),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(
              height: tFormHeight - 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: const Text(tForgetPassword),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _loginUser();
                  }
                },
                child: Text(tLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cemail.dispose();
    _password.dispose();
    super.dispose();
  }
}
