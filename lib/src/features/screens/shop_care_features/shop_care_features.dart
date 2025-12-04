import 'package:flutter/material.dart';
import 'package:shopcare/src/common_widgets/appbar/appbar.dart';
import 'package:shopcare/src/features/screens/profile/update_profile_screen.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/Bill/bill.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/add_new_product/add_new_product.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/manage_category/manage_category.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/seal_item/seal_item.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/view_bill/view_bill.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/view_sell/view_sell.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/view_update_delete_product/view_update_delete_product.dart';
import 'package:shopcare/src/features/screens/shop_care_features/widget/bulid_card_item.dart';
import '../../../common_widgets/bottom_navbar/custom_bottom_navbar.dart';
import '../../../constants/image_strjngs.dart';
import '../../../constants/sizes.dart';
import '../../../constants/text_strings.dart';

class HealoFeatures extends StatefulWidget {
  const HealoFeatures({super.key});

  @override
  State<HealoFeatures> createState() => _HealoFeaturesState();
}

class _HealoFeaturesState extends State<HealoFeatures> {
  int _selectedIndex = 0;
  bool _showMore = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleMoreItems() {
    setState(() {
      _showMore = !_showMore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: tDashboardPadding,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shope Manger Section",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "Explore all stuff related to Shope Manger...",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 10,
                children: [
                  BuildCardItem(
                    imagePath: tManageImage,
                    title: tOnShopeMangerSectionTitle1,
                    subtitle: tOnShopeMangerSectionSubTitle1,
                    tap: MangeCategory(),
                  ),
                  BuildCardItem(
                    imagePath: tDownloadCardImage,
                    title: tOnShopeMangerSectionTitle2,
                    subtitle: tOnShopeMangerSectionSubTitle2,
                    tap: AddNewProduct(),
                  ),
                  BuildCardItem(
                    imagePath: tUpdateProfileImage,
                    title: tOnShopeMangerSectionTitle3,
                    subtitle: tOnShopeMangerSectionSubTitle3,
                    tap: UpdateProfileScreen(),
                  ),
                  BuildCardItem(
                    imagePath: tHealthRecImage,
                    title: tOnShopeMangerSectionTitle4,
                    subtitle: tOnShopeMangerSectionSubTitle4,
                    tap: ViewUpdateDeleteProduct(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: tDashboardPadding,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shop Care Inventory",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "Explore all the Shop Care utilities...",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 10,
                children: [
                  BuildCardItem(
                    imagePath: tBillImage,
                    title: tOnHealoInventoryTitle1,
                    subtitle: tOnHealoInventorySubTitle1,
                    tap: Bill(),
                  ),
                  BuildCardItem(
                    imagePath: tCalorieCounterImage,
                    title: tOnHealoInventoryTitle2,
                    subtitle: tOnHealoInventorySubTitle2,
                    tap: ViewBill(),
                  ),
                  BuildCardItem(
                    imagePath: tCard2,
                    title: tOnHealoInventoryTitle3,
                    subtitle: tOnHealoInventorySubTitle3,
                    tap: View_Sell(),
                  ),
                  BuildCardItem(
                    imagePath: tSleepTrackerImage,
                    title: tOnHealoInventoryTitle4,
                    subtitle: tOnHealoInventorySubTitle4,
                    tap: SealItem(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
