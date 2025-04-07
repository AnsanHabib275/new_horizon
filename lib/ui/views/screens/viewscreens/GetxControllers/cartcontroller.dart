// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:new_horizon/core/models/cartproduct.dart';
import 'package:new_horizon/core/services/apis/user/getcompletecart.dart';

class CartController extends GetxController {
  RxList<CartProduct> products = List<CartProduct>.of([]).obs;
  RxDouble totaprice = 0.0.obs;
  var isLoading = false.obs;

  var trigger = false.obs;

  void toggleTrigger() => trigger.toggle();

  @override
  void onInit() {
    super.onInit();
    loadCartProducts();
  }

  Future<void> loadCartProducts() async {
    isLoading(true);
    print('Loading cart products...');
    try {
      List<CartProduct> fetchedProducts = await GetUserCart.getcart();
      products.assignAll(fetchedProducts);
      updateTotalPrice();
      toggleTrigger();
      print(
          'Cart products loaded successfully. Total items: ${products.length}');
    } on CartException catch (cartException) {
      print(
          'CartException occurred: ${cartException.message}, Code: ${cartException.code}');
      if (cartException.message == "NO_ACTIVE_CARTS_FOUND_FOR_THIS_USER" &&
          cartException.code == 3088) {
        products.clear();
        updateTotalPrice();
        print('No active carts found for this user. Cart is now empty.');
      }
    } catch (e) {
      print('Error loading cart products: $e');
    } finally {
      isLoading(false);
    }
  }

  void updateTotalPrice() {
    double tempTotalPrice = 0.0;
    for (var product in products) {
      tempTotalPrice += product.price * product.quantity;
    }
    totaprice(tempTotalPrice);
    print('Total price updated: $totaprice');
  }

  void removeProduct(CartProduct product) {
    print('Removing product: ${product.name}');
    products.remove(product);
    updateTotalPrice();
  }
}
