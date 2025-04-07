// ignore_for_file: unused_local_variable, unused_element, avoid_print

import 'package:get/get.dart';
import 'package:new_horizon/core/models/cartproduct.dart';
import 'package:new_horizon/core/services/apis/user/getcompletecart.dart';

class CounterController extends GetxController {
  RxInt itemsadded = 0.obs;
  var trigger = false.obs; // This is the manual trigger

  void toggleTrigger() => trigger.toggle();

  loadCartProducts() async {
    List<CartProduct> products = [];
    try {
      products = await GetUserCart.getcart();
      print('Products retrieved: ${products.length}');
      itemsadded.value = products.length;
      print('Controller value updated to: ${itemsadded.value}');
      toggleTrigger();
    } catch (e) {
      print(e.toString());
      if (e is CartException) {
        if (e.code == 3088 || e.code == 3089) {
          itemsadded.value = 0;
        }
      } else if (e.toString().contains("Bad Request")) {
        itemsadded.value = 0;
      }
    }
  }
}
