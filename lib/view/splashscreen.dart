import 'package:app_novo/view/login.dart';
import 'package:app_novo/view/telaos.dart';
//import 'package:app_novo/view/nao-utilizados/os%20copy.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String loginData = "";

  SharedPreferences sharedPreferences;
  void initState() {
    super.initState();
    readFromStorage();
  }

  void readFromStorage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final key = 'operador';
    loginData = sharedPreferences.getString(key);
    print(loginData);
    if (loginData == null || loginData.isEmpty) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login()));
        });
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => OS()));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(Colors.green),
          )
        ]));
  }
}
