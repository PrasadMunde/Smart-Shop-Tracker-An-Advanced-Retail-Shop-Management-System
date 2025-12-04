import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewBill extends StatefulWidget {
  const ViewBill({super.key});

  @override
  _ViewBillState createState() => _ViewBillState();
}

class _ViewBillState extends State<ViewBill> {
  int _selectedIndex = 0;
  bool _showMore = false;
  String id='';
  late SharedPreferences prefss;
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

  String? selectedCategory; // Dropdown selection
  String? filterDate; // Variable for date filter

  List<Map<String, dynamic>> bill = []; // List to store fetched bills

  @override
  void initState() {
    super.initState();;
    _uuuid();
    _initPrefsAndFetchCategory();// Fetch bills when the screen loads
  }

  Future<void> _initPrefsAndFetchCategory() async {
    prefss = await SharedPreferences.getInstance();
    _fetchBill(); // Call fetch after initialization
  }

  // Function to fetch bills from the Supabase database
  void _fetchBill() async {
    final idd = prefss.getString('uid');
    var query = Supabase.instance.client.from('view_bill').select().eq('uid', idd!);
    if (filterDate != null && filterDate!.isNotEmpty) {
      query = query.ilike('date', '%$filterDate%');
    }

    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      query = query.eq('order_type', selectedCategory.toString()); // Assuming 'order_type' column exists
    }

    final res = await query;
    setState(() {
      bill = List<Map<String, dynamic>>.from(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "View Bill Order Place Details",
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'View Bill Order Place Details and we show more details..',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Filter fields (Date and Dropdown)
              Row(
                children: [
                  // Filter by Date
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Filter By Date'),
                        prefixIcon: Icon(Icons.date_range_outlined),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filterDate = value;
                          _fetchBill(); // Fetch bills when date filter changes
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date to filter by.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Dropdown for Order Type
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Order',
                      ),
                      value: selectedCategory,
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'DNC',
                          child: Text('DNC'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ANC',
                          child: Text('ANC'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          _fetchBill(); // Fetch bills when category changes
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an order type.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bill Table
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Bill NO.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Date',
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
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Payment Type',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...bill.map((item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['bill_no'].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['date'].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['total'].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item['payment_type'].toString()),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 10),
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