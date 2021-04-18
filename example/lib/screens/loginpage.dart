import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../brand_colors.dart';
import '../dataprovider/appdata.dart';
import '../screens/registrationpage.dart';
import '../utils/request.dart';
import '../widgets/FoodDBButton.dart';
import '../widgets/ProgressDialog.dart';
import 'package:provider/provider.dart';

import 'mainpage.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool hasLoginFailed = false;

  void login(context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Connecting with server',
            ));

    // final User user = (await _auth
    //         .signInWithEmailAndPassword(
    //             email: emailController.text, password: passwordController.text)
    //         .catchError((err) {
    //   Navigator.pop(context);
    //   PlatformException thisEx = err;
    //   showWarningMSG(thisEx.message);
    // }))
    //     .user;

    var user_info =
        await Request.login(emailController.text, passwordController.text);

    if (user_info['success']) {
      String cusId = user_info['cus_id'];

      String cusName = user_info['cus_name'];

      Provider.of<AppData>(context, listen: false).updateCustomerID(cusId);
      Provider.of<AppData>(context, listen: false).updateCustomerName(cusName);

      Navigator.pop(context);

      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    } else {
      Navigator.pop(context);
      print('failed');

      setState(() {
        hasLoginFailed = true;
      });
    }

    // cancel the progress bar

    // if (user != null) {
    //   //verify login
    //   DatabaseReference userRef =
    //       FirebaseDatabase.instance.reference().child('users/${user.uid}');
    //   userRef.once().then((DataSnapshot snapshot) {
    //     if (snapshot.value != null) {
    //       Navigator.pushNamedAndRemoveUntil(
    //           context, MainPage.id, (route) => false);
    //     }
    //   });
    // }
  }

  void showWarningMSG(String title) {
    final warningBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldKey.currentState.showSnackBar(warningBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Image(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    image: AssetImage('images/logo.png')),
                SizedBox(
                  height: 40,
                ),
                Text('Sign in to FoodDonationDB',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold')),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      FoodDBButton(
                        title: 'LOGIN',
                        color: Colors.indigo,
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showWarningMSG('No internet');
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showWarningMSG(
                                'Please enter a valid email address');
                            return;
                          }

                          if (passwordController.text.length < 6) {
                            showWarningMSG('Please enter a valid password');
                            return;
                          }

                          login(context);
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationPage.id, (route) => false);
                  },
                  child: Text('Don\'t have an account yet? Sign up here'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: hasLoginFailed,
                      child: Text(
                        'Incorrect username/password or both, retry login',
                        style: TextStyle(
                            color: BrandColors.colorPink,
                            fontSize: 14,
                            fontFamily: 'Brankd-Bold'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
