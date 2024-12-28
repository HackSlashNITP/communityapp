import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;
  
  RxBool isSwitch = false.obs;

  RxInt CarouselController=0.obs;


  void changeIndex(int index) {
    selectedIndex.value = index;
  }
  // for changing theme by switch
  void changeSwitch() {
    isSwitch.value = !isSwitch.value;
  }
  //for dot indicator 

  void updatePgaeIndicator(int index){
    CarouselController.value=index;
  }
}
