import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/image_strjngs.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/view_update_delete_product/edite_product_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 // Assuming the next page is called EditProductPage

class ViewUpdateDeleteProduct extends StatefulWidget {
  const ViewUpdateDeleteProduct({super.key});

  @override
  State<ViewUpdateDeleteProduct> createState() =>
      _ViewUpdateDeleteProductState();
}

class _ViewUpdateDeleteProductState extends State<ViewUpdateDeleteProduct> {

  int _selectedIndex = 0;
  bool _showMore = false;
  String id='';
  late SharedPreferences prefss;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _initPrefsAndFetchCategory() async {
    prefss = await SharedPreferences.getInstance();
    _fetchProduct(); // Call fetch after initialization
  }
  void _uuuid() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id=prefs.getString('uid')!;
    });
  }

  List<Map<String, dynamic>> product = [];

  void _fetchProduct() async {
    final idd = prefss.getString('uid');
    final res = await Supabase.instance.client.from('new_product').select().eq('uid', idd!);
    setState(() {
      product = List<Map<String, dynamic>>.from(res);
    });
  }

  @override
  void initState() {
    super.initState();
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
                    "View, Update & Delete Product",
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Select a product to view, update, or delete it from the product list',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 30),
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
                        GestureDetector(
                          onTap: () {
                            // Navigate to the next page, passing the selected product data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditeProductPage(
                                  product: item,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['id'].toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditeProductPage(
                                  product: item,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['name'].toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditeProductPage(
                                  product: item,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['category'].toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditeProductPage(
                                  product: item,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['price'].toString()),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
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
