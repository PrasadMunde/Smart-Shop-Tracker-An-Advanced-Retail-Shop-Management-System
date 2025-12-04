import 'package:flutter/material.dart';
import 'package:shopcare/src/features/screens/profile/profile_screen.dart';
import '../../constants/colors.dart';
import '../../constants/image_strjngs.dart';
import '../../constants/text_strings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen()));},
        child: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
      title: Text(
        tAppName,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20, top: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: tCardBgColor,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            icon: const Image(image: AssetImage(tProfileImage)),
          ),
        ),
      ],
    );
  }
}
