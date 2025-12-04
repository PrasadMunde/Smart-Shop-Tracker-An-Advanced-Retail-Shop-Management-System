import 'package:shopcare/src/features/screens/dashboard/dashboard.dart';
import 'package:shopcare/src/features/screens/signup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strjngs.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import '../login/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  String? uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveUid();
  }

  void saveUid() async{
    final SharedPreferences perf =await SharedPreferences.getInstance();
    setState(() {
      uid = perf.getString('uid');
      print("-----------------------------------$uid");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (uid != null) {
      return Dashboard();
    } else {
      print("-----------------------------------$uid");
      var mediaQuery = MediaQuery.of(context);
      var height = mediaQuery.size.height;

      return Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: AssetImage(tWelcomeScreenImage),
                  height: height * 0.6,
                ),
                Column(
                  children: [
                    Text(
                      tWelcomeTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      tWelcomeSubTitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 25.0,
                          // Shadow elevation
                          shadowColor: Colors.black.withOpacity(1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Rounded corners
                          ),
                          foregroundColor: tSecondaryColor,
                          side: BorderSide(color: tSecondaryColor),
                          padding:
                              EdgeInsets.symmetric(vertical: tButtonHeight),
                        ),
                        child: Text(tLogin.toUpperCase()),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 25.0,
                          // Shadow elevation
                          shadowColor: Colors.black.withOpacity(1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Rounded corners
                          ),
                          side: BorderSide(color: tSecondaryColor),
                          padding:
                              EdgeInsets.symmetric(vertical: tButtonHeight),
                        ),
                        child: Text(tSignup.toUpperCase()),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
