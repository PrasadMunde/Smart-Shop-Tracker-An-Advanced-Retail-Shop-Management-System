import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TOutlinedButtonTheme{
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme= OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          elevation: 25.0, // Shadow elevation
          shadowColor: Colors.black.withOpacity(1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners
          ),
          foregroundColor: tSecondaryColor,
          backgroundColor: tWhiteColor,
          side: BorderSide(color: tSecondaryColor),
          padding: EdgeInsets.symmetric(vertical: tButtonHeight)
      )
  );
 static final darkOutlinedButtonTheme= OutlinedButtonThemeData(
     style: OutlinedButton.styleFrom(
         elevation: 25.0, // Shadow elevation
         shadowColor: Colors.white.withOpacity(1.0),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(30.0), // Rounded corners
         ),
         foregroundColor: tSecondaryColor,
         backgroundColor: tWhiteColor,
         side: BorderSide(color: tSecondaryColor),
         padding: EdgeInsets.symmetric(vertical: tButtonHeight)
     )
 );
}