import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/image_strjngs.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/Bill/bill.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BillScreen2 extends StatefulWidget {
  String name;
  String email;
  String mobile;
  BillScreen2({
    Key? key,
    required this.name,
    required this.email,
    required this.mobile,
  }) : super(key: key);

  @override
  State<BillScreen2> createState() => _BillScreen2State();
}

class _BillScreen2State extends State<BillScreen2> {
  int _selectedIndex = 0;
  int billNo=0;
  String id='';
  String? formattedDate, datew;
  double onlineTotal = 0, cashTotal = 0;
  bool _showMore = false;
  String paymentMode = '';
  late SharedPreferences prefss;
  // Get the current date

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _uuuid() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id=prefs.getString('uid')!;
    });
  }

  Future<void> _initPrefsAndFetchCategory() async {
    prefss = await SharedPreferences.getInstance();
    _fetchProduct();
    _fetchCategory(); // Call fetch after initialization
  }

  List<Map<String, dynamic>> category = [];
  String? selectedCategory;


  List<Map<String, dynamic>> product = [];
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> cartItems = []; // List to store cart items

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController searchController = TextEditingController(); // Controller for the search field

  @override
  void initState() {
    _uuuid();
    _initPrefsAndFetchCategory();
  }
  // Fetch category from Supabase
  void _fetchCategory() async {
    final idd = prefss.getString('uid');
    final res = await Supabase.instance.client.from('manage_category').select().eq('uid', idd!);
    setState(() {
      category = List<Map<String, dynamic>>.from(res);
    });
  }
 

    void sealItems() async{
      int totalQuantity ;
      for (var item in cartItems) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        totalQuantity= prefs.getInt('${item['name'].toString()}') ?? 0;
        setState(() {
          totalQuantity += int.parse(item['quantity'].toString());
        });
        await prefs.setInt('${item['name'].toString()}', totalQuantity);
      }
    }

  // Fetch products from Supabase based on selected category
  void _fetchProduct() async {
    final idd = prefss.getString('uid');
    if (selectedCategory != null) {
      final res = await Supabase.instance.client
          .from('new_product')
          .select()
          .eq('category',
              selectedCategory.toString()).eq('uid', idd!); // Filter by selected category
      setState(() {
        product = List<Map<String, dynamic>>.from(res);
      });
    } else {
      setState(() {
        product = [];
      });
    }
  }

  // Search product by name and category
  Future<void> filterByName(String name) async {
    final idd = prefss.getString('uid');
    if (name.isNotEmpty && selectedCategory != null) {
      final res = await Supabase.instance.client
          .from('new_product')
          .select()
          .ilike('name',
              '%$name%') // Case-insensitive search for products that contain the entered name
          .eq('category',
              selectedCategory.toString()).eq('uid', idd!); // Exact match for category

      setState(() {
        product = List<Map<String, dynamic>>.from(res);
      });
    } else {
      _fetchProduct(); // Fetch all products if search is empty
    }
  }

  // Fetch specific product details by ID or name
  Future<void> _fetchProductDetails(String name) async {
    final idd = prefss.getString('uid');
    final res = await Supabase.instance.client
        .from('new_product')
        .select()
        .eq('name', name)
        .eq('uid', idd!)
        .single(); // Get single product
    if (res != null) {
      setState(() {
        nameController.text = res['name'];
        priceController.text = res['price'].toString();
        quantityController.text = '1'; // Default quantity to 1
        _calculateTotal(); // Update the total price
      });
    }
  }

  // Calculate total from cartItems
  void _calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item['total'] as double;
    }
    totalController.text = total.toStringAsFixed(2); // Update totalController
  }

  // Function to show confirmation dialog before deleting the item
  void _showDeleteConfirmationDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _removeItemFromCart(item); // Delete the item if confirmed
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

// Function to remove item from the cart
  void _removeItemFromCart(Map<String, dynamic> item) {
    setState(() {
      cartItems.remove(item); // Remove the item from the list
      _calculateTotal(); // Recalculate the total after removing the item
    });
  }

  Future<void> _online() async {
    final idd = prefss.getString('uid');
    final DateTime now = DateTime.now();
    final String formattedDate11 = DateFormat('dd-MM-yyyy').format(now);

    final response = await Supabase.instance.client
        .from('payment_type')
        .select()
        .eq('date', formattedDate11.toString())
        .eq('uid', idd!)
        .single();
    print('-----------------------------------'+response['date']);
    if(paymentMode == 'cash'){
      if (response != null) {
        setState(() {
          cashTotal =
              double.parse(totalController.text?.toString() ?? '0.0') +
                  double.parse(response['cash']?.toString() ?? '0.0');
        });
      }
      // Update the cash total for the existing record
      await Supabase.instance.client.from('payment_type').update({
        'cash': cashTotal.toString(),
      }).eq('date', formattedDate11.toString()).eq('uid', id);

    }
    if(paymentMode == 'online'){
      final idd = prefss.getString('uid');
      if (response != null) {
        setState(() {
          cashTotal =
              double.parse(totalController.text?.toString() ?? '0.0') +
                  double.parse(response['online']?.toString() ?? '0.0');
        });
      }
      // Update the cash total for the existing record
      await Supabase.instance.client.from('payment_type').update({
        'online': cashTotal.toString(),
      }).eq('date', formattedDate11.toString()).eq('uid', idd!);

    }

  }


  // Function to add item to cart
  void _addItemToCart() {
    final name = nameController.text;
    final price = double.tryParse(priceController.text) ?? 0;
    final quantity = int.tryParse(quantityController.text) ?? 1;
    final total = price * quantity;

    if (name.isNotEmpty && price > 0 && quantity > 0) {
      setState(() {
        cartItems.add({
          'name': name,
          'price': price,
          'quantity': quantity,
          'total': total,
        });
      });
      _calculateTotal(); // Update total after adding item to cart
    }
  }



  Future<String?> getDataWithExpiry(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? expiryTimestamp = prefs.getInt('$key-expiry');
    String? value = prefs.getString(key);

    if (expiryTimestamp != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      // Check if the data is expired
      if (currentTime >= expiryTimestamp) {
        await prefs.remove(key);
        await prefs.remove('$key-expiry');
        return null; // Data expired
      }
    }

    return value; // Return the value if not expired
  }
  void _generateAndPrintPDF() async {
    final idd = prefss.getString('uid');
    final pdf = pw.Document();
    final DateTime now = DateTime.now();
    String formattedTime = DateFormat('hh:mm a').format(now);
    formattedDate = DateFormat('dd-MM-yyyy').format(now);


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('date');
    if( value == formattedDate.toString()){
      int num = prefs.getInt('num') ?? 0;
      setState(() {
        num += 1;
      });
      await prefs.setInt('num', num);
    }else{
      await prefs.setString('date', formattedDate.toString());
      await prefs.setInt('num', 1);
    }
    await Supabase.instance.client.from('view_bill').insert({
      'name': widget.name,
      'mobile_no': widget.mobile,
      'date': formattedDate.toString(),
      'total': totalController.text,
      'payment_type': paymentMode.toString(),
      'bill_no': '${prefs.getInt('num') ?? 0}',
      'uid': idd!,
    });

    // Create the PDF content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Shop Name:- Annas Kitchn', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 10),
              pw.Text('Bill Number:- ${prefs.getInt('num') ?? 0}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.Text('Date:- $formattedDate',
                  style: pw.TextStyle(fontSize: 18)), // Add the date here
              pw.Text('Time:- $formattedTime',
                 style: pw.TextStyle(fontSize: 18)), // Add the time here
              pw.SizedBox(height: 10),
              pw.Text('Customer Name: ${widget.name}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 10),
              pw.Text('Mobile:- ${widget.mobile}',
                  style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 15),
              // Table with borders on all sides
              pw.Table.fromTextArray(
                headers: ['Name', 'Price', 'Quantity', 'Total'],
                data: cartItems.map((item) {
                  return [
                    item['name'],
                    item['price'].toString(),
                    item['quantity'].toString(),
                    item['total'].toString(),
                  ];
                }).toList(),
                border: pw.TableBorder(
                  top: pw.BorderSide(width: 2, color: PdfColors.black), // Top border
                  bottom: pw.BorderSide(width: 2, color: PdfColors.black), // Bottom border
                  left: pw.BorderSide(width: 1, color: PdfColors.black), // Left border
                  right: pw.BorderSide(width: 1, color: PdfColors.black), // Right border
                  horizontalInside: pw.BorderSide(width: 1, color: PdfColors.grey), // Horizontal lines inside
                  verticalInside: pw.BorderSide(width: 1, color: PdfColors.grey), // Vertical lines inside
                ),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellPadding: pw.EdgeInsets.all(5),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total:- ${totalController.text} Rs  ${paymentMode} payment',
                  style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Generate Bill",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Enter your bill details to create a bill.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Row for dropdown and search field
              Row(
                children: [
                  // Dropdown to select category
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Category',
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
                          _fetchProduct();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Category';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Search TextFormField
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        label: Text('Search...'),
                        prefixIcon: Icon(Icons.search_outlined),
                      ),
                      onChanged: (value) {
                        filterByName(
                            value); // Call the filter function when the search text changes
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an item to search.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Row for product list table and inputs
              Row(
                children: [
                  // Expanded to ensure it takes appropriate space
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 270, // Set a fixed height for the table
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Colors.black), // Set the border color and width
                      ),
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder
                              .all(), // Keep the table border if needed
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                              ),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Select Item',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            ...product.map((item) {
                              return TableRow(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _fetchProductDetails(item[
                                          'name']); // Fetch product details when tapped
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(item['name'].toString()),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Column for input fields (wrapped in Expanded or Flexible)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          readOnly: true, // Make this field read-only
                          decoration: const InputDecoration(
                            label: Text('Name'),
                            prefixIcon: Icon(Icons.food_bank_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the item name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: priceController,
                          readOnly: true, // Make this field read-only
                          decoration: const InputDecoration(
                            label: Text('Price'),
                            prefixIcon: Icon(Icons.currency_rupee_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the item price.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: quantityController,
                          decoration: const InputDecoration(
                            label: Text('Quantity'),
                            prefixIcon: Icon(Icons.add_alert_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the quantity.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {
                              _addItemToCart();
                              nameController.clear();
                              priceController.clear();
                              quantityController.clear();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Keeps the button size minimal
                              children: const [
                                Icon(Icons
                                    .add_shopping_cart), // Icon for "Add to Cart"
                                SizedBox(
                                    width:
                                        8), // Adds space between the icon and text
                                Text("Add Cart"),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 14.0),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Cart Items Table
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Quantity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...cartItems.map((item) {
                    return TableRow(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showDeleteConfirmationDialog(
                                item); // Show confirmation before deleting
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['name'].toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDeleteConfirmationDialog(
                                item); // Show confirmation before deleting
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['price'].toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDeleteConfirmationDialog(
                                item); // Show confirmation before deleting
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['quantity'].toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showDeleteConfirmationDialog(
                                item); // Show confirmation before deleting
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['total'].toString()),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),

              const SizedBox(height: 15),

              // Payment Row with equal width
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: totalController,
                        readOnly: true, // Make this read-only
                        decoration: const InputDecoration(
                          label: Text('Total'),
                          prefixIcon: Icon(Icons.currency_rupee_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            paymentMode = 'cash';
                          });
                          _generateAndPrintPDF();
                          _online();
                          sealItems();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Bill()));
                        },
                        child: const Text("   Cash Payment"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 8.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              paymentMode = 'online';
                            });
                            _generateAndPrintPDF();
                            _online();
                            sealItems();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Bill()));
                          },
                          child: const Text("  Online Payment"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 8.0),
                          )),
                    ),
                  ],
                ),
              ),
              Center(
                child: Image(
                  image: AssetImage(tCreateAbhaScreenImage1),
                  height: height * 0.2,
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
