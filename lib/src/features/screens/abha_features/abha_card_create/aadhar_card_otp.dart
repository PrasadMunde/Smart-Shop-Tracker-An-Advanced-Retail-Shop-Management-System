import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import '../../../../common_widgets/appbar/appbar.dart';
import '../../../../constants/image_strjngs.dart';
import '../../../../constants/sizes.dart';

class AadharCardOtp extends StatelessWidget {
  const AadharCardOtp({super.key});

  @override
  Widget build(BuildContext context) {
    String? _phone;
    String otpCode = "";
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    return Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Container(
              child: Padding(
                padding: const EdgeInsets.all(tDefaultSize),
                child:Column( children: [
                  SizedBox(height: 55,),
                  Column(
                    children: [
                      Text(
                        "Code Verification",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Enter Your Aadhar Number OTP then we will make it Abha card',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OtpTextField(
                              numberOfFields: 6,
                              fillColor: Colors.black.withOpacity(0.1),
                              filled: true,
                              onSubmit: (code) {
                                otpCode = code;
                              },
                            ),
                            const SizedBox(
                              height: tFormHeight - 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                },
                                child: Text(tNext),
                              ),
                            ),
                            Image(
                              image: AssetImage(tCreateAbhaScreenImage1),
                              height: height * 0.4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              )),
        )
    );
  }
}
