import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SealItem extends StatefulWidget {
  const SealItem({super.key});

  @override
  _SealItemState createState() => _SealItemState();
}

class _SealItemState extends State<SealItem> {
  int _selectedIndex = 0;
  String id='';
  late SharedPreferences prefss;
  Map<String, int> itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _uuuid();
    _initPrefsAndFetchCategory();
  }
  void _uuuid() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id=prefs.getString('uid')!;
  }

  Future<void> _initPrefsAndFetchCategory() async {
    prefss = await SharedPreferences.getInstance();
    _loadItems() ; // Call fetch after initialization
  }


  Future<void> _loadItems() async {
    List<String> productNames = await _fetchProductNames();
    await _loadQuantities(productNames);
  }

  /// Fetch product names from Supabase
  Future<List<String>> _fetchProductNames() async {
    final idd = prefss.getString('uid');
    final supabase = Supabase.instance.client;
    final response = await supabase.from('new_product').select('name').eq('uid', idd!);

    if (response.isNotEmpty) {
      return response.map<String>((item) => item['name'] as String).toList();
    }
    return [];
  }

  /// Load stored quantities from SharedPreferences
  Future<void> _loadQuantities(List<String> productNames) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> quantities = {};

    for (var name in productNames) {
      quantities[name] = prefs.getInt(name) ?? 0;
    }

    setState(() {
      itemQuantities = quantities;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sortedItems = itemQuantities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder(
        future: _fetchProductNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Error fetching data"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Today's Sold Items",
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      children: [
                        _tableCell("Name", isHeader: true),
                        _tableCell("Quantity", isHeader: true),
                      ],
                    ),
                    ...sortedItems.map((entry) {
                      return TableRow(
                        children: [
                          _tableCell(entry.key),
                          _tableCell(entry.value.toString()),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  /// Table cell widget
  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
