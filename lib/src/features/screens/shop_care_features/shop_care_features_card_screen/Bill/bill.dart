import 'package:flutter/material.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/image_strjngs.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/Bill/bill_screen_2.dart';

class Bill extends StatefulWidget {
  const Bill({super.key});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  int _selectedIndex = 0;
  bool _showMore = false;

  // Controllers to capture user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "Generate Bill",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your bill details to create a bill.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          label: Text('Enter A Name'),
                          prefixIcon: Icon(Icons.person_2_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          label: Text('Enter A Email'),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      TextFormField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          label: Text('Enter A Phone No.'),
                          prefixIcon: Icon(Icons.call_end_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Mobile Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Pass the input values to the next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BillScreen2(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  mobile: _mobileController.text,
                                ),
                              ),
                            );
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
