// ignore_for_file: camel_case_types, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_horizon/core/models/favmodel.dart';
import 'package:new_horizon/core/services/apis/user/favoriteapi.dart';
import 'package:new_horizon/core/services/apis/user/getcompletecart.dart';

class Favcartcounter extends GetxController {
  RxInt itemsadded = 0.obs;
  var trigger = false.obs;

  void toggleTrigger() => trigger.toggle();

  Future<void> loadFavProducts(BuildContext context) async {
    List<FavModel> favourites = [];
    try {
      favourites = await GetFavProdApi.getfavProdapi(context);
      print('Products retrieved: ${favourites.length}');
      itemsadded.value = favourites.length;
      print('Controller value updated to: ${itemsadded.value}');
      toggleTrigger();
    } catch (e) {
      print(e.toString());
      if (e is CartException) {
        if (e.code == 4012 || e.code == 3089) {
          itemsadded.value = 0;
        }
      } else if (e.toString().contains("Bad Request")) {
        itemsadded.value = 0;
      }
    }
  }
}
