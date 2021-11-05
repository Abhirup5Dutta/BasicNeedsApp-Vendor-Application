import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor_app/providers/auth_provider.dart';
import 'package:grocery_vendor_app/providers/order_provider.dart';
import 'package:grocery_vendor_app/providers/product_provider.dart';
import 'package:grocery_vendor_app/screens/add_edit_coupon_screen.dart';
import 'package:grocery_vendor_app/screens/add_newproduct_screen.dart';
import 'package:grocery_vendor_app/screens/home_screen.dart';
import 'package:grocery_vendor_app/screens/login_screen.dart';
import 'package:grocery_vendor_app/screens/register_screen.dart';
import 'package:grocery_vendor_app/screens/splash_screen.dart';
import 'package:grocery_vendor_app/widgets/reset_password_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
        Provider(create: (_) => ProductProvider()),
        Provider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
        fontFamily: 'Lato',
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        AddNewProduct.id: (context) => AddNewProduct(),
        AddEditCoupon.id: (context) => AddEditCoupon(),
      },
    );
  }
}
