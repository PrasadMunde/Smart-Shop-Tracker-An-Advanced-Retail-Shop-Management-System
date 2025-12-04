import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/image_strjngs.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  int _selectedIndex = 0;
  bool _showMore = false;
  String id='';
  late SharedPreferences prefss;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  TextEditingController _textController1 = TextEditingController();
  TextEditingController _textController3 = TextEditingController();
  List<Map<String, dynamic>> category = [];
  List<Map<String, dynamic>> product = [];
  String? selectedCategory; // To store the selected category

  // Fetch category from Supabase
  void _fetchCategory() async {
    final idd = prefss.getString('uid');
    final res = await Supabase.instance.client.from('manage_category').select().eq('uid', idd!);
    setState(() {
      category = List<Map<String, dynamic>>.from(res);
    });
  }
  void _uuuid() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id=prefs.getString('uid')!;
    });
  }

  void _fetchProduct() async {
    final idd = prefss.getString('uid');
    final res = await Supabase.instance.client.from('new_product').select().eq('uid', idd!);
    setState(() {
      product = List<Map<String, dynamic>>.from(res);
    });
  }

  // Add new product to Supabase
  void _addProduct() async {
    if (_textController1.text.isNotEmpty &&
        selectedCategory != null &&
        _textController3.text.isNotEmpty) {
      await Supabase.instance.client.from('new_product').insert({
        'name': _textController1.text,
        'category': selectedCategory, // Use selected category
        'price': _textController3.text,
        'uid': id
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product add successfully...')));
      _textController1.clear();
      _textController3.clear();
      selectedCategory = null; // Clear selection after adding
      _fetchCategory();
      _fetchProduct();// Re-fetch category list after adding
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_textController1.text,0);
  }
  Future<void> _initPrefsAndFetchCategory() async {
    prefss = await SharedPreferences.getInstance();
    _fetchCategory();
    _fetchProduct(); // Call fetch after initialization
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
                    "Add New Products",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Enter your Products then we will add it to the products list',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _textController1,
                        decoration: const InputDecoration(
                          label: Text('Enter A Product Name'),
                          prefixIcon: Icon(Icons.food_bank_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Product Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select A Category',
                          prefixIcon: Icon(Icons.category),
                        ),
                        value: selectedCategory,
                        items: category.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['category'].toString(),
                            child: Text(item['category'].toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a Category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      TextFormField(
                        controller: _textController3,
                        decoration: const InputDecoration(
                          label: Text('Enter A Product Price'),
                          prefixIcon: Icon(Icons.price_change_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Product Price';
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
                                _addProduct();
                                _textController1.clear();
                                _textController3.clear();
                                selectedCategory = null;
                                _fetchProduct();
                              },
                              child: Text(tAdd.toUpperCase()),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _textController1.clear();
                                _textController3.clear();
                                selectedCategory = null; // Clear the selection
                              },
                              child: Text(tClear.toUpperCase()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "View Products",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      SizedBox(height: 10),
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
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Product',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Category',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Price',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...product.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['id'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['name'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['category'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['price'].toString()),
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
