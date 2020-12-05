
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zaha_application/tab/order.dart';
import 'package:zaha_application/view/about_us.dart';
import 'package:zaha_application/view/add_service.dart';
import 'package:zaha_application/view/loginPage.dart';
import 'package:zaha_application/view/myOrders.dart';
import 'package:zaha_application/view/my_companies.dart';
import 'package:zaha_application/view/newhome.dart';
import 'package:zaha_application/view/no_connect.dart';
import 'package:zaha_application/view/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override

    MyAppstate createState() =>MyAppstate();
  }


 class MyAppstate extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var title;
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('ar', 'AE'), // OR Locale('ar', 'AE') OR Other RTL locales
      ],


      debugShowCheckedModeBanner: false,
      title: 'ZAHA',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),

       //  home:SignInDemo(),
    home: SplashScreen (),
      // home: LoginPage(title: 'zaha'),
        routes: <String,WidgetBuilder>{
        '/home' : (BuildContext context) =>  new Example(),
        '/login' : (BuildContext context) => new LoginPage(title:title),
       '/GroceryHomePage' : (BuildContext context) => new Example(),
       '/noconnect' : (BuildContext context) => new No_connect(),
       '/splash' : (BuildContext context) => new SplashScreen(),
       '/myorder' : (BuildContext context) => new myOrder(),
       '/order' : (BuildContext context) => new order(),
       '/add_service' : (BuildContext context) => new Add_service(),
       '/my_companies' : (BuildContext context) => new MyCompanies(),
       '/about_us' : (BuildContext context) => new about_us(),
      },

    );
  }
}










