import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TElevatedButton {
  TElevatedButton._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: tWhiteColor, // Text color
      backgroundColor: tSecondaryColor, // Background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0), // Button padding
        elevation: 25.0, // Shadow elevation
        shadowColor: Colors.black.withOpacity(1.0), // Shadow color
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: tSecondaryColor, // Text color
      backgroundColor: tWhiteColor, // Background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0), // Button padding
      elevation: 25.0, // Shadow elevation
      shadowColor: Colors.white.withOpacity(1.0), // Sha // Shadow color
      side: BorderSide(color: tSecondaryColor), // Border color
    ),
  );
}
