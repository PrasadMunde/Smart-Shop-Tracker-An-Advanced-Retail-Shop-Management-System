import 'package:uuid/uuid.dart';

// Initialize the Uuid package
final Uuid uuid = Uuid();

// Create a global variable for the UID
String uid = uuid.v4();
