import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  RxBool isSwitch = false.obs;

  RxDouble CarouselController=0.0.obs;


  void changeIndex(int index) {
    selectedIndex.value = index;
  }
  // for changing theme by switch
  void changeSwitch() {
    isSwitch.value = !isSwitch.value;
  }
  //for dot indicator

  void updatePgaeIndicator(double index){
    CarouselController.value=index;
  }
}
