import 'package:flutter/material.dart';
import 'package:shopcare/src/constants/colors.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:shopcare/src/features/screens/profile/update_profile_screen.dart';
import 'package:shopcare/src/features/screens/profile/widgets/profile_menu_widget.dart';
import 'package:shopcare/src/features/screens/welcome/welcome_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/image_strjngs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('uid', prefs.getString('uid').toString())
        .single();

    if (response != null) {
      final user = Map<String, dynamic>.from(response);
      setState(() {
        name = user['name'].toString();
        email = user['email'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          tProfile,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(tProfileImage),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: tPrimaryColor,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                name ?? "Loading...",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                email ?? "Loading...",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpdateProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    tEditProfile,
                    style: TextStyle(color: tDarkColor),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // Menu
              ProfileMenuWidget(
                title: tMenu1,
                icon: Icons.switch_access_shortcut,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: tMenu2,
                icon: Icons.language,
                onPress: () {},
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: tMenu3,
                icon: Icons.medical_services,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: tMenu4,
                icon: Icons.design_services,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: tMenu5,
                icon: Icons.security,
                onPress: () {},
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: tMenu6,
                icon: LineAwesomeIcons.helping_hands,
                onPress: () {},
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: tMenu7,
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () async {
                  final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  await prefs.remove('uid');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
