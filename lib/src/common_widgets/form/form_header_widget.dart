import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    Key? key,
    this.imageColor,
    this.heightBetween,
    required this.title,
    required this.subtitle,
    required this.image,
    this.imageHeight=0.2,
    this.textAlign,
    this.crossAxisAlignment =CrossAxisAlignment.start,
  }) : super(key: key);
  final String image, title, subtitle;
  final CrossAxisAlignment  crossAxisAlignment;
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(
          image: AssetImage(image),
          color: imageColor,
          height: size.height *imageHeight ,
        ),
        SizedBox(height: heightBetween,),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          subtitle,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
