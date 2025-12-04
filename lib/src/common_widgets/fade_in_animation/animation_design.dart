import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'fade_in_animation_controller.dart';
import 'fade_in_animation_model.dart'; // Ensure this is the correct path

class TFadelnAnimation extends StatelessWidget {
  TFadelnAnimation({
    Key? key,
    required this.durationInMs,
    this.animate,
    required this.child,
  }) : super(key: key);

  final fadeInController = Get.put(FadeInAnimationController());
  final int durationInMs;
  final TAnimatePosition? animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => AnimatedPositioned(
        duration: Duration(milliseconds: durationInMs),
        top: fadeInController.animate.value ? animate!.topAfter : animate!.topBefore,
        left: fadeInController.animate.value ? animate!.leftAfter : animate!.leftBefore,
        bottom: fadeInController.animate.value ? animate!.bottomAfter : animate!.bottomBefore,
        right: fadeInController.animate.value ? animate!.rightAfter : animate!.rightBefore,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: durationInMs),
          opacity: fadeInController.animate.value ? 1 : 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30),
            child: child,
          ),
        ),
      ),
    );
  }
}
