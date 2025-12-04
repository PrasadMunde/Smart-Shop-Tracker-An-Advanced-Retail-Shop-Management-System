import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final AssetImage image;

  const CategoryCard({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 55,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          child: Row(
            children: [
              Container(
                width: 45,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  color: tCardBgColor,
                ),
                child: Center(
                  child: Image(image: image),
                ),
              ),
              Container(
                width: 115,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: tCardBgColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall ,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
