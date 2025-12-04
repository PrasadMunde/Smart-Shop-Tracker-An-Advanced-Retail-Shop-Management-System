import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:shopcare/src/features/screens/dashboard/dashboard.dart';

class ForgetPasswordOtpScreen extends StatelessWidget {
  final String otp;

  ForgetPasswordOtpScreen({
    Key? key,
    required this.otp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String otpCode = "";
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tOtpTitle,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 80,
              ),
            ),
            Text(
              tOtpSubTitle.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Text(
              "$tOtpMessage support@healo_users_application.com",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20.0,
            ),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                otpCode = code;
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (otpCode == otp) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  } else {
                    // Show an error message or handle incorrect OTP
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Incorrect OTP. Please try again.'),
                      ),
                    );
                  }
                },
                child: Text(tNext),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
