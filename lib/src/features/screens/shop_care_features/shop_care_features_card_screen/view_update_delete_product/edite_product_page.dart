import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/image_strjngs.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/constants/text_strings.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/view_update_delete_product/view_update_delete_product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditeProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  EditeProductPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<EditeProductPage> createState() => _EditeProductPageState();
}

class _EditeProductPageState extends State<EditeProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  String? selectedCategory;

  int _selectedIndex = 0;
  bool _showMore = false;
  String id ='';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _uuuid() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id=prefs.getString('uid')!;
  }

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the product data
    _nameController = TextEditingController(text: widget.product['name']);
    _categoryController = TextEditingController(text: widget.product['category']);
    _priceController = TextEditingController(text: widget.product['price'].toString());
    _uuuid();
  }

  // Function to update the product in Supabase
  void _updateProduct() async {
    if (_nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      await Supabase.instance.client.from('new_product').update({
        'name': _nameController.text,
        'category': _categoryController.text,
        'price': _priceController.text,
      }).eq('id', widget.product['id']).eq('uid', id);// Ensure to update the correct product by ID
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully...')));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUpdateDeleteProduct()));
  }

  // Function to delete the product in Supabase
  void _deleteProduct() async {
    await Supabase.instance.client.from('new_product').delete().eq('id', widget.product['id']);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUpdateDeleteProduct()));
    // Return to the previous screen after deletion
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
                    "Edit Product",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Update your product details below',
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
                        controller: _nameController,
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
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          label: Text('Enter A Category'),
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          label: Text('Enter A Product Price'),
                          prefixIcon: Icon(Icons.price_change_outlined),
                        ),
                        keyboardType: TextInputType.number, // Set keyboard type to numeric
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
                              onPressed: (){
                                _updateProduct();
                                _nameController.clear();
                                _priceController.clear();
                                _categoryController.clear();
                                },
                              child: Text(tUpdate.toUpperCase()),
                            ),
                            ElevatedButton(
                              onPressed: _deleteProduct,
                              child: Text(tDelete.toUpperCase()),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Image(
                          image: AssetImage(tCreateAbhaScreenImage1),
                          height: height * 0.4,
                        ),
                      ),
                      SizedBox(height: 20),
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
