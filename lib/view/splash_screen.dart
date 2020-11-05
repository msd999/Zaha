import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:http/http.dart' as http;

import 'package:zaha_application/view/login.dart';

DatabaseHelper _databaseHelper= new DatabaseHelper();

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<int> check_connect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      try {
        final response =
        await http.get("https://google.com");
        if (response.statusCode == 200) {
          return 1;
        }
      } on SocketException catch (_) {
        Navigator.of(context).pushReplacementNamed('/noconnect');
        return 0;
      }
    }else if(connectivityResult == ConnectivityResult.none){
      Navigator.of(context).pushReplacementNamed('/noconnect');
      return 0;
    }
  }

  _check(){
    _databaseHelper.checklogin().whenComplete(() {
      if (_databaseHelper.status==false) {
        Navigator.pushReplacementNamed(context, '/GroceryHomePage');
      }else{
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });}

  @override
  initState() {
    super.initState();
    // read();
    //check_connect();
    _check();
    /*Future.delayed(Duration(seconds:1 ),(){
      Navigator.of(context).pushReplacementNamed('/login');
    });*/



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // backgroundColor: kzaha,
        body:Container(
        decoration: BoxDecoration(

          image: DecorationImage(
            image: AssetImage(
                'assets/img/bg3.jpg'
            ),
            fit: BoxFit.cover,
          ),

        ),child:Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/img/logo.png',width: 250.0,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "تطبيقك في البناء ",
                  style: TextStyle(fontSize: 23.0,color: korange,fontFamily:"CustomIcons"),
                ),
                RotateAnimatedTextKit(
                    text: ["والإكساء"],
                    textStyle: TextStyle(fontSize: 23.0, color: korange,fontFamily:"CustomIcons"),
                ),
              ],
            ),

              SizedBox(height: 50),


            ],
          ),
        ),)

    );
  }
}
