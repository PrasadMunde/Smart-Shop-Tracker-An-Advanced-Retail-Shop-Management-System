import 'package:flutter/material.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import 'forget_password_btn_widget.dart';
import 'forget_password_mail_screen.dart';
class ForgetPasswordScreen{

  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        builder: (context) => Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tForgetPasswordTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),
              Text(
                tForgetPasswordSubTitle,
                style:
                Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 30.0,
              ),
              ForgetPasswordBtnWidget(
                btnIcon: Icons.mail_outline_rounded,
                title: tEmail,
                subTitle: tResetViaEMail,
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPasswordMailScreen()));
                },
              ),
              const SizedBox(height: 20.0,),
              ForgetPasswordBtnWidget(
                btnIcon: Icons.mobile_friendly_rounded,
                title: tPhoneNo,
                subTitle: tResetViaPhone,
                onTap: (){},
              ),
            ],
          ),
        ));
  }
}

