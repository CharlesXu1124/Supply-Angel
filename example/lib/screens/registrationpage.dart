
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../brand_colors.dart';
import '../screens/mainpage.dart';
import '../utils/request.dart';
import '../widgets/FoodDBButton.dart';
import '../widgets/ProgressDialog.dart';
import './loginpage.dart';

import 'package:connectivity/connectivity.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

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


  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Connecting with server',
            ));
    // final User user = (await _auth
    //         .createUserWithEmailAndPassword(
    //   email: emailController.text,
    //   password: passwordController.text,
    // )
    //         .catchError((err) {

    //   PlatformException thisEx = err;
    //   showWarningMSG(thisEx.message);
    // }))
    //     .user;

    // DatabaseReference newUserRef =
    //     FirebaseDatabase.instance.reference().child('users/${user.uid}');
    // Map userMap = {
    //   'cust_name': fullNameController.text,
    //   'cust_email': emailController.text,
    //   'cust_phone': phoneController.text,
    //   'credential': passwordController.text
    // };

    // newUserRef.set(userMap);
    print('registered');
    Request.register(fullNameController.text, emailController.text,
        phoneController.text, passwordController.text);

    Navigator.pop(context);

    //navigate to main page
    Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
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
                Text('Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold')),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
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
                        controller: phoneController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
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
                        title: 'REGISTER',
                        color: BrandColors.colorAccentPurple,
                        onPressed: () async {
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showWarningMSG('No internet');
                            return;
                          }

                          // check network availability

                          if (fullNameController.text.length < 3) {
                            showWarningMSG('Please enter a valid username');
                            return;
                          }

                          if (phoneController.text.length < 10) {
                            showWarningMSG('Please enter a valid phone number');
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showWarningMSG(
                                'Please enter a valid email address');
                            return;
                          }

                          if (passwordController.text.length < 6) {
                            showWarningMSG(
                                'Please enter a password with at least 6 characters/digits');
                            return;
                          }
                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    child: Text('Already have an account? Log in'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
