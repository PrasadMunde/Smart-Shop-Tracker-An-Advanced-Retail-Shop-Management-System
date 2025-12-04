import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../features/screens/welcome/welcome_screen.dart';
class FadeInAnimationController extends GetxController{
  static FadeInAnimationController get find => Get.find();
  RxBool animate= false.obs;
  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
     animate = true.obs;
    await Future.delayed(Duration(milliseconds: 5000));
    Get.to(WelcomeScreen());
   }
}