import 'package:shopcare/src/features/screens/welcome/welcome_screen.dart';
import 'package:shopcare/src/util/theme/widget_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> main() async {
  await Supabase.initialize(
      url: "https://eedzvaseelorpybjrcto.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlZHp2YXNlZWxvcnB5YmpyY3RvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0NjIzMjIsImV4cCI6MjA1ODAzODMyMn0.dlYT1tgdWTiFGqp4Do2KnJT5Z2W3XC3zonOo2V90HiU");
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home:WelcomeScreen(),
    );
  }
}
