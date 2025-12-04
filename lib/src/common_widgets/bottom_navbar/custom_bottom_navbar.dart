import 'package:flutter/material.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:shopcare/src/features/screens/dashboard/dashboard.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shopcare/src/features/screens/profile/profile_screen.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/Bill/bill.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/add_new_product/add_new_product.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  void _navigateToScreen(BuildContext context, int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = Dashboard(); // Replace with your actual HomeScreen widget
        break;
      case 1:
        screen = Bill(); // Replace with your actual AbhaScreen widget
        break;
      case 2:
        screen = AddNewProduct(); // Replace with your actual RecordsScreen widget
        break;
      case 3:
        screen = const ProfileScreen(); // Replace with your actual ProfileScreen widget
        break;
      default:
        screen = Dashboard(); // Fallback to HomeScreen
    }

    // Navigate to the selected screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);
        _navigateToScreen(context, index);
      },
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 30),
      unselectedIconTheme: IconThemeData(color: Colors.grey, size: 25),
      selectedItemColor: Colors.amberAccent,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: tHome,
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesomeIcons.alternate_identification_card),
          label: tAbha,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_open_rounded),
          label: tRecords,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: tProfile,
        ),
      ],
    );
  }
}
