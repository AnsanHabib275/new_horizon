import 'package:flutter/material.dart';
import 'package:new_horizon/core/constants/asset_constants.dart';

class ListItem {
  final IconData? icon; // Can be null now
  final String? assetPath; // New field for asset images
  final String text;

  ListItem.icon(this.icon, this.text)
      : assetPath = null; // Constructor for IconData
  ListItem.asset(this.assetPath, this.text)
      : icon = null; // Constructor for asset images
}

final List<ListItem> items = [
  ListItem.asset(AssetConstants.dashboard, 'Dashboard'),
  ListItem.asset(AssetConstants.benefitsverification, 'Benefits Verfication'),
  ListItem.asset(AssetConstants.benefitsverification, 'Favorites'),
  ListItem.asset(AssetConstants.prod, 'Products'),
  ListItem.asset(AssetConstants.patients, 'Patients'),
  ListItem.asset(AssetConstants.orderr, 'Orders'),
  ListItem.asset(AssetConstants.pay, 'Payments'),
  ListItem.asset(AssetConstants.historry, 'History'),
  ListItem.asset(AssetConstants.logout, 'Logout'),
];
