import 'package:flutter/material.dart';
import 'package:shopcare/src/features/screens/profile/profile_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strjngs.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';
import 'package:shopcare/src/features/screens/dashboard/dashboard.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('uid', prefs.getString('uid').toString())
        .single();

    if (response != null) {
      setState(() {
        _nameController.text = response['name']?.toString() ?? '';
        _emailController.text = response['email']?.toString() ?? '';
        _passwordController.text = response['password']?.toString() ?? '';
        _phoneController.text = response['phone']?.toString() ?? '';
      });
    }
  }

  void _updateUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid').toString();

    final response = await Supabase.instance.client
        .from('profiles')
        .update({
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
    })
        .eq('uid', uid);

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${response.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          tEditProfile,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
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
                      LineAwesomeIcons.camera,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Form(
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: tFullName,
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: tEmail,
                      prefixIcon: Icon(LineAwesomeIcons.envelope),
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: tPhoneNo,
                      prefixIcon: Icon(Icons.call_end_outlined),
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: tPassword,
                      prefixIcon: Icon(Icons.fingerprint),
                    ),
                  ),
                  const SizedBox(height: tFormHeight),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateUser();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => ProfileScreen()),
                              (route) => false,
                        );
                      },
                      child: Text(tEditProfile.toUpperCase()),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text.rich(
                        TextSpan(
                          text: tProfileEndText,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            elevation: 20,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            foregroundColor: Colors.red,
                            side: BorderSide.none),
                        child: const Text(tHome),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
