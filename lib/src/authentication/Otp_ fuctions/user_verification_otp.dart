import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class UserVerificationOtp {
  Future<int> sendOTP(String phoneNumber) async {
    final int randomNumber = 100000 + Random().nextInt(900000);
    final url = Uri.parse('https://www.fast2sms.com/dev/bulkV2');
    final headers = {

    "authorization":"SOtq7kywLeozgV1dhTibYUKJGuxvDspjfH5IX9lNrMWcPR8A64X7vzFlDMWhEQxrCLdym3ie65TuK2Zj",
    "Content-Type":"application/json"
    };


    final body = json.encode({
      "route": "otp",
      "variables_values": randomNumber.toString(),
      "numbers": phoneNumber,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('OTP sent successfully');
        return randomNumber;
      } else {
        print('Failed to send OTP: ${response.statusCode} ${response.body}');
        throw Exception('Failed to send OTP: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
      throw Exception('Error sending OTP: $e');
    }
  }
}

