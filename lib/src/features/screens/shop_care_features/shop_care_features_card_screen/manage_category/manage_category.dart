import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/image_strjngs.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MangeCategory extends StatefulWidget {
  const MangeCategory({super.key});

  @override
  State<MangeCategory> createState() => _MangeCategoryState();
}

class _MangeCategoryState extends State<MangeCategory> {
  int _selectedIndex = 0;
  String id='';
  late SharedPreferences prefss;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> category = [];

  void _uuuid() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id=prefs.getString('uid')!;
    });
  }
  Future<void> _initPrefsAndFetchCategory() async {
    prefss = await SharedPreferences.getInstance();
    _fetchCategory(); // Call fetch after initialization
  }

  // Fetch category from Supabase
  void _fetchCategory() async {
    final idd = prefss.getString('uid');
    final res = await Supabase.instance.client.from('manage_category').select().eq('uid',idd!);
    setState(() {
      category = List<Map<String, dynamic>>.from(res);
    });
  }

  // Add new category to Supabasecofee
  void _addCategory() async {
    if (_textController.text.isNotEmpty) {
      await Supabase.instance.client
          .from('manage_category')
          .insert({'category': _textController.text,
                    'uid':id });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category add successfully...')));
      _textController.clear(); // Clear input after adding
      _fetchCategory();
    }
  }

  // Delete category from Supabase
  void _deleteCategory(int id ,String categoryName) async {
    await Supabase.instance.client.from('manage_category').delete().eq('id', id);
    await Supabase.instance.client.from('new_product').delete().eq('category', categoryName).eq('id', id);
    _fetchCategory(); // Re-fetch category list after deletion
  }

  // Show confirmation dialog before deleting
  void _showDeleteConfirmationDialog(int id, String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete the category "$categoryName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteCategory(id,categoryName); // Call delete function
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _uuuid();
    _initPrefsAndFetchCategory();
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
                    "Manage Category",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your category then we will add it to the category list',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          label: Text('Enter A Category'),
                          prefixIcon: Icon(Icons.production_quantity_limits_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _addCategory();
                                _textController.clear();
                              },
                              child: Text(tAdd.toUpperCase()),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _textController.clear(); // Clear the text input
                              },
                              child: Text(tClear.toUpperCase()),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "View Category",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Create a Table with borders and headers
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey.shade300),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('ID',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Category',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...category.map((item) {
                            return TableRow(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showDeleteConfirmationDialog(
                                      item['id'],
                                      item['category'],
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item['id'].toString()),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showDeleteConfirmationDialog(
                                      item['id'],
                                      item['category'],
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(item['category'].toString()),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
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
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
