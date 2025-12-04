import 'package:flutter/material.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/Bill/bill.dart';
import 'package:shopcare/src/features/screens/shop_care_features/shop_care_features_card_screen/view_sell/view_sell.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strjngs.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class banner extends StatelessWidget {
  const banner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: tCardBgColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>Bill())
                );
              },
              child: Column(
                children: [
                  Image(
                    image: AssetImage(tManageImage),
                    height: 125,
                  ),
                  Text(
                    tOnHealoInventoryTitle1,
                    style: Theme.of(context).textTheme.headlineSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    tOnHealoInventorySubTitle1,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: tDashboardCardPadding,
        ),
        Expanded(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>View_Sell())
              );
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tCardBgColor),
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(tDownloadCardImage),
                        height: 120,
                      ),
                      Text(
                        '    '+tOnHealoInventoryTitle3+'  De' ,
                        style: Theme.of(context).textTheme.headlineSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>HealoFeatures())
                      );
                    },
                    child: const Text('View All'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
