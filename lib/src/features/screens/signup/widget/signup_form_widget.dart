import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:math';
import '../../../../constants/globals.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../forget_password/forget_password_otp/forget_password_otp_screen.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {

  String? _name, _phone, _email;
  late SharedPreferences prefss;
  bool isOtpSent = false;
  bool isOtpVerified = false;
  String? generatedOtp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveUid();
  }

  void saveUid() async{
    final SharedPreferences perf =await SharedPreferences.getInstance();
    await perf.setString('uid', uid);
 }


  final TextEditingController _cname = TextEditingController();
  final TextEditingController _cemail = TextEditingController();
  final TextEditingController _phoneNo = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  void data() async {
    final response = await supabase.from('profiles').insert({
      'name': _cname.text,
      'email': _cemail.text,
      'phone': _phoneNo.text,
      'password': _password.text,
      'uid': uid,
    });
    _showErrorMessage("Signing Successfully .....");
    if (response.error != null) {
      print('Error inserting data: ${response.error!.message}');
    } else {
      print('Data inserted successfully: ${response.data}');
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
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        ));
    }

  String generateOtp() {
    final Random random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 4-digit OTP
  }

  Future<void> sendOtp(String phone) async {
    generatedOtp = generateOtp();
    String apiUrl = "https://www.fast2sms.com/dev/bulkV2?authorization=4yQKd0ChlzdOjrM9bxaMLcmslvfMwqX4HsmBQcnW98AO9g5av6X5p8Pn8SZP";

    final Uri url = Uri.parse("$apiUrl&route=q&message=$generatedOtp&flash=0&numbers=$phone&schedule_time=");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() => isOtpSent = true);
        _showMessage("OTP sent successfully!", Colors.green);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ForgetPasswordOtpScreen(otp: generatedOtp.toString())));
      } else {
        _showMessage("Failed to send OTP. Try again.", Colors.red);
      }
    } catch (e) {
      print('------------------------------------------- $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _cname,
              decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _cemail,
              decoration: const InputDecoration(
                  label: Text(tEmail),
                  prefixIcon: Icon(Icons.person_outline_rounded)),
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
              onSaved: (value) {
                _email = value;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _phoneNo,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  label: Text('Phone no'),
                  prefixIcon: Icon(Icons.phone_outlined)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                if (value.length < 10 || value.length > 10) {
                  return "Please enter valid phone number";
                }
                // Additional phone number validation can be added here
                return null;
              },
              onSaved: (value) {
                _phone = value;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                  label: Text('Password'),
                  prefixIcon: Icon(Icons.fingerprint_sharp),
                  suffixIcon: Icon(Icons.remove_red_eye_sharp)),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                _password.text = value!;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmPassword,
              decoration: const InputDecoration(
                  label: Text('Confirm Password'),
                  prefixIcon: Icon(Icons.fingerprint),
                  suffixIcon: Icon(Icons.remove_red_eye_sharp)),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _password.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _formKey.currentState?.save();
                    data();
                    sendOtp(_phoneNo.text);
                  }
                },
                child: Text(tSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
