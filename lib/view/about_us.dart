import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaha_application/style/TextStyles.dart';
import 'package:zaha_application/style/consts.dart';

class about_us extends StatefulWidget {
  @override
  about_usState createState() => about_usState();
}

class about_usState extends State<about_us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kzaha,
        appBar: AppBar(

          backgroundColor: Colors.deepOrange,

          title: Text(
            "من نحن",
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0
              , fontFamily: "CustomIcons",),
          ),
          actions: <Widget>[
          ],
        ),
        body:Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),

    child:Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/img/logo.png',width: 150.0,),

              //BoldText("تطبيقك في البناء ,الاكساء ",18.0,kwhite),

              SizedBox(height: 20),
              Text('من نحن',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 28.0,
                      fontFamily: "CustomIcons"
                  )),
              SizedBox(height: 20),
              Text('''نحن منصة الكترونية يجتمع فيها جميع الشركات العاملة في مجال البناء والاكساء
              
 من خلال هذه المنصة تستطيع سواء الشركات أو الافراد الوصول الى خدمات او منتجات هذه الشركات.
 
              ''',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                      fontFamily: "CustomIcons"
                  ),textDirection: TextDirection.rtl,textAlign: TextAlign.right,),

            ],
          ),),
        )

    );

  }


}
