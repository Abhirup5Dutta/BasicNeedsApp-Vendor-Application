import 'package:flutter/material.dart';
import 'package:grocery_vendor_app/screens/banner_screen.dart';
import 'package:grocery_vendor_app/screens/coupon_screen.dart';
import 'package:grocery_vendor_app/screens/dashboard_screen.dart';
import 'package:grocery_vendor_app/screens/order_screen.dart';
import 'package:grocery_vendor_app/screens/product_screen.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return MainScreen();
    }
    if (title == 'Product') {
      return ProductScreen();
    }
    if (title == 'Banner') {
      return BannerScreen();
    }
    if (title == 'Coupons') {
      return CouponScreen();
    }
    if (title == 'Orders') {
      return OrderScreen();
    }
    return MainScreen();
  }
}
