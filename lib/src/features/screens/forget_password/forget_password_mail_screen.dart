import 'package:shopcare/src/common_widgets/form/form_header_widget.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:flutter/material.dart';
import '../../../constants/image_strjngs.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
                const FormHeaderWidget(
                  title: tForgetPassword,
                  subtitle: tForgetPasswordTitle,
                  image: tForgetPasswordImage,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                         /*   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPasswordOtpScreen()));*/
                          },
                          child: Text(tNext.toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
