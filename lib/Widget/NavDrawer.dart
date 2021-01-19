import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/tab/favourite.dart';
import 'package:zaha_application/tab/profile.dart';
import 'package:zaha_application/view/about_us.dart';
import 'package:zaha_application/view/add_company.dart';
import 'package:zaha_application/view/favourite.dart';
import 'package:zaha_application/view/feedbacks.dart';
import 'package:zaha_application/view/loginPage.dart';
import 'package:zaha_application/view/my_companies.dart';
import 'package:zaha_application/view/newhome.dart';

class NavDrawer extends StatefulWidget {
  @override
  NavDrawerState createState() => NavDrawerState();

}

class NavDrawerState extends State<NavDrawer> {

  String user_name = 'زائر';
  var gust = false;
  check_if_gust() async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);
    print('$value');
    if(value == '0'){
      setState(()  {
        gust = true;
        user_name = 'زائر';
      });
    }else{
      final key = 'name';
      final value = prefs.get(key);
      setState(()  {
        user_name = value;
      });
    }
  }

  void initState() {
    super.initState();
    check_if_gust();
  }

  @override
  Widget build(BuildContext context) {


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(

            child: Column(
              children: <Widget>[
                Container(
                    //margin: EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF275879),
                      child: Image.asset('assets/img/profile.png',width: 150.0,height: 150.0,),
                    )
                ),

                Text(
                  user_name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: "CustomIcons",
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),



              ],
            ),
            decoration: BoxDecoration(
                color: Color(0xFF275879),
                ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('الرئيسية',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "CustomIcons",
                  fontSize: 18),),
            onTap: () => {Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new Example()))},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('شركاتي',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "CustomIcons",
                  fontSize: 18),),
            onTap: () => {Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new MyCompanies()))},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('حسابي',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "CustomIcons",
                  fontSize: 18),),
            onTap: () => {Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new profile()))},
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.info),
            title: Text('من نحن',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "CustomIcons",
                  fontSize: 18),),
            onTap: () => {Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new about_us()))},
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('المفضلة',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "CustomIcons",
                  fontSize: 18),),
            onTap: () => {Navigator.of(context).push(
            new MaterialPageRoute(
            builder: (BuildContext context) => new favouritetab()))},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: gust ? Text('تسجيل الدخول',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "CustomIcons",
                  fontSize: 18),):Text('تسجيل خروج',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: "CustomIcons",
                  fontSize: 18),),
            onTap: ()async{
              final prefs = await SharedPreferences.getInstance();
              final key = 'token';
              final value = "0";
              prefs.setString(key, value);
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new LoginPage()));},
          ),
        ],
      ),
    );
  }

  Widget login_text(){
    return Text(
      "تسجيل الدخول",
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontFamily: "CustomIcons",
          fontSize: 20),
      textAlign: TextAlign.center,
    );
  }
}