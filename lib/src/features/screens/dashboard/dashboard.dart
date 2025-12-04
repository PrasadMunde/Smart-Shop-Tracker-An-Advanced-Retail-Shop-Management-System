import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopcare/src/constants/sizes.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/features/screens/dashboard/widget/banner_card.dart';
import 'package:shopcare/src/features/screens/dashboard/widget/category_card.dart';
import 'package:shopcare/src/features/screens/dashboard/widget/search.dart';
import 'package:shopcare/src/features/screens/dashboard/widget/slider.dart';
import 'package:shopcare/src/features/screens/dashboard/widget/top_sources_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import '../../../constants/image_strjngs.dart';
import '../../../constants/text_strings.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> imgList = [
    'assets/dashboard_screen/slider_images/banner1.jpg',
    'assets/dashboard_screen/slider_images/banner2.jpg',
    'assets/dashboard_screen/slider_images/banner3.png',
    'assets/dashboard_screen/slider_images/banner4.jpg',
    'assets/dashboard_screen/slider_images/banner3.png',
  ];
  late SharedPreferences prefss;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dt();
  }

  Future<void> dt() async {
    final SharedPreferences perf =await SharedPreferences.getInstance();
    final idd = perf.getString('uid');

    final DateTime now = DateTime.now();
    final String formattedDate11 = DateFormat('dd-MM-yyyy').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('date');
    if( value != formattedDate11.toString()){
      await Supabase.instance.client.from('payment_type').insert({
        'date': formattedDate11.toString(),
        'cash': '0',
        'online': '0',
        'uid': idd!
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDashboardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tOnBoardingTitle1,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                tOnBoardingTitle2,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: tDashboardPadding),

              // Search Box...
              search(),
              const SizedBox(height: tDashboardPadding),

              // Slider Image
              Center(
                child: slider(imgList: imgList),
              ),

              const SizedBox(height: tDashboardPadding),

              // Categories
              SizedBox(
                height: 45,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryCard(
                      title: tOnShopeMangerSectionTitle1,
                      subtitle: tOnShopeMangerSectionSubTitle1,
                      image: const AssetImage(tCard1),
                    ),
                    CategoryCard(
                      title: tOnShopeMangerSectionTitle2,
                      subtitle: tOnShopeMangerSectionSubTitle2,
                      image: const AssetImage(tDawonlodCard),
                    ),
                    CategoryCard(
                      title: tOnShopeMangerSectionTitle3,
                      subtitle: tOnShopeMangerSectionSubTitle3,
                      image: const AssetImage(tCard2),
                    ),
                    CategoryCard(
                      title: tOnShopeMangerSectionTitle4,
                      subtitle: tOnShopeMangerSectionSubTitle4,
                      image: const AssetImage(tCard3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: tDashboardPadding),

              // Banners
              banner(),

              //Top Sources...
              const SizedBox(height: tDashboardPadding),
              Text(
                tOnBoardingSubTitle2,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.apply(fontSizeFactor: 1.2),
              ),
              topSources(),
              const SizedBox(height: tDashboardPadding),
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
