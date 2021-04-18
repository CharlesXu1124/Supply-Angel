import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/screens/menu_screen.dart';
//import 'package:flutter_unity_widget_example/screens/simple_screen.dart';
import 'dataprovider/appdata.dart';
import 'screens/api_screen.dart';
import 'screens/loader_screen.dart';
import 'screens/loginpage.dart';
import 'screens/orientation_screen.dart';
import 'screens/registrationpage.dart';
import 'screens/searchrestaurantpage.dart';
import 'package:provider/provider.dart';
import './screens/mainpage.dart';
import 'dart:async';

import 'screens/simple_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseApp app = await Firebase.initializeApp(
  //   name: 'db2',
  //   options: Platform.isIOS || Platform.isMacOS
  //       ? FirebaseOptions(
  //           appId: '1:265604596275:ios:884eb28b049fce1d205946',
  //           apiKey: 'AIzaSyDv1FvrAo0oig-UNBHBPOdpxeCYCc5-gCc',
  //           projectId: 'fir-rtc-e5aeb',
  //           messagingSenderId: '265604596275',
  //           databaseURL: 'https://fir-rtc-e5aeb.firebaseio.com',
  //         )
  //       : FirebaseOptions(
  //           appId: '1:265604596275:ios:884eb28b049fce1d205946',
  //           apiKey: 'AIzaSyDv1FvrAo0oig-UNBHBPOdpxeCYCc5-gCc',
  //           messagingSenderId: '265604596275',
  //           projectId: 'fir-rtc-e5aeb',
  //           databaseURL: 'https://fir-rtc-e5aeb.firebaseio.com',
  //         ),
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MenuScreen.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
          SearchRestaurantPage.id: (context) => SearchRestaurantPage(),
          MenuScreen.id: (context) => MenuScreen(),
          '/': (context) => MenuScreen(),
          '/simple': (context) => SimpleScreen(),
          '/loader': (context) => LoaderScreen(),
          '/orientation': (context) => OrientationScreen(),
          '/api': (context) => ApiScreen(),
        },
      ),
    );
  }
}
