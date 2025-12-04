import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import 'package:shopcare/src/constants/image_strjngs.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class View_Sell extends StatefulWidget {
  const View_Sell({super.key});

  @override
  State<View_Sell> createState() => _View_SellState();
}

class _View_SellState extends State<View_Sell> {
  int _selectedIndex = 0;
  String value = '0';
  bool _showMore = false;
  List<Map<String, dynamic>> sell = [];
  String onlinePayment = '';
  String cashPayment = '';
  String totalPayment = '';
  Map<String, dynamic>? todaysPayment;
  String id='';
  late SharedPreferences prefss;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Future<void> _initPrefsAndFetchCategory() async {
    prefss = await SharedPreferences.getInstance();
    _fetchSell();
    _fetchPayments(); // Call fetch after initialization
  }

  void _uuuid() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id=prefs.getString('uid')!;
  }

  void _fetchSell() async {
    final idd = prefss.getString('uid');
    final res = await Supabase.instance.client.from('payment_type').select().eq('uid', idd!);
    setState(() {
      sell = List<Map<String, dynamic>>.from(res);
    });
  }

  Future<void> _fetchPayments() async {
    final idd = prefss.getString('uid');
    final DateTime now = DateTime.now();
    final String formattedDate11 = DateFormat('dd-MM-yyyy').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dt = prefs.getString('date');
    if (dt == formattedDate11.toString()) {
      setState(() {
        value = prefs.getInt('num').toString();
      });
    } else {
      setState(() {
        value = '0';
      });
    }
    final response = await Supabase.instance.client
        .from('payment_type')
        .select()
        .eq('date', formattedDate11).eq('uid', idd!);
    final data = List<Map<String, dynamic>>.from(response);

    if (data.isNotEmpty) {
      // Extract the first row of data
      double totalOnline = double.tryParse(data[0]['online'].toString()) ?? 0.0;
      double totalCash = double.tryParse(data[0]['cash'].toString()) ?? 0.0;

      // Update the state
      setState(() {
        onlinePayment = totalOnline.toString();
        cashPayment = totalCash.toString();
        totalPayment = (totalOnline + totalCash).toString();
      });
    } else {
      // Handle the case where no payment data is found for today
      print('No payment data found for the date: $formattedDate11');
      setState(() {
        onlinePayment = '0.0';
        cashPayment = '0.0';
        totalPayment = '0.0';
      });
    }
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
                    "View Sell",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Here is today\'s sell and details of the shop.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Form(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row to display fields side by side
                      Row(
                        children: [
                          // Today's Bill and Online Payment side by side
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(text: value),
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text('Today\'s Bill'),
                                prefixIcon: Icon(Icons.receipt),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between fields
                          Expanded(
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: onlinePayment),
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text('Online Payment'),
                                prefixIcon: Icon(Icons.currency_rupee_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: tFormHeight - 10),
                      Row(
                        children: [
                          // Cash Payment and Total Sell side by side
                          Expanded(
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: cashPayment),
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text('Cash Payment'),
                                prefixIcon: Icon(Icons.currency_rupee_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between fields
                          Expanded(
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: totalPayment),
                              readOnly: true,
                              decoration: const InputDecoration(
                                label: Text('Total Sell'),
                                prefixIcon: Icon(Icons.currency_rupee_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Sell History",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Sell history table
                      Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Cash',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Online',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Total',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...sell.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['date'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['cash'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['online'].toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    (double.tryParse(item['cash'].toString())! +
                                            double.tryParse(
                                                item['online'].toString())!)
                                        .toString(),
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
                height: height * 0.3,
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
