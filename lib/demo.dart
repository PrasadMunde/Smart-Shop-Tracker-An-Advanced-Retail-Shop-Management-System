import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://eedzvaseelorpybjrcto.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlZHp2YXNlZWxvcnB5YmpyY3RvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0NjIzMjIsImV4cCI6MjA1ODAzODMyMn0.dlYT1tgdWTiFGqp4Do2KnJT5Z2W3XC3zonOo2V90HiU");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> createTable() async {
    try {
      final response = await supabase.rpc('sql', params: {
        'sql': '''
        CREATE TABLE IF NOT EXISTS mydemo(
          id SERIAL PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          created_at TIMESTAMP DEFAULT NOW()
        );
        '''
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table "demo" created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Table in Supabase')),
      body: Center(
        child: ElevatedButton(
          onPressed: createTable,
          child: Text('Create Table'),
        ),
      ),
    );
  }
}
