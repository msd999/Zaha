import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaha_application/style/TextStyles.dart';
import 'package:zaha_application/style/consts.dart';

class about extends StatefulWidget {
  @override
  aboutState createState() => aboutState();
}

_lanchurl(String Url) async{
  if(await canLaunch(Url)) {
    await launch(Url);
  } else{
    throw 'could not lauch $Url';
  }
}
class aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kzaha,
        body:Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/img/logo.png',width: 150.0,),

              //BoldText("تطبيقك في البناء ,الاكساء ",18.0,kwhite),

              SizedBox(height: 20),
             Text('تواصل معنا',
                 style: TextStyle(
               color: Colors.deepOrange,
               fontSize: 16.0,
             )),
              SizedBox(height: 20),
            Row(
            children: <Widget>[
              SizedBox(height: 30.0,),
              Icon(Icons.mail,color:Colors.white,),
              SizedBox(width: 10.0),
              Text('info@zaha-app.com',style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 16.0,
              ),),
            ],
        ) ,
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  Icon(Icons.phone,color:Colors.white,),
                  SizedBox(width: 10.0),
                  Text('0994942994',style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 16.0,
                  ),),
                ],
              ),
          Row(
            children: <Widget>[
              SizedBox(width: 20.0,),
              IconButton(
                color: Colors.deepOrange,
                icon: Icon(FontAwesomeIcons.facebookF),
                onPressed: (){
                  _lanchurl("https://www.facebook.com/");
                },
              ),
              SizedBox(width: 20.0,),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.web),
                onPressed: (){
                  _lanchurl("https://www.zaha.sy");
                },
              )
            ],
          )

            ],
          ),
        )

    );

  }


}
