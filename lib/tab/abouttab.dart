
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/TextStyles.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/policy.dart';



DatabaseHelper databaseHelper= new DatabaseHelper();

class abouttab extends StatefulWidget {
  @override
  _abouttabState createState() => _abouttabState();

}

class _abouttabState extends State<abouttab> {
  _lanchurl(String Url) async{
    if(await canLaunch(Url)) {
      await launch(Url);
    } else{
      throw 'could not lauch $Url';
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 0, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('عودة',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.white))
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white10,),
        backgroundColor: kzaha,
        body:Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image.asset('assets/img/logo.png',width: 150.0,),

              BoldText("تطبيقك في البناء و الإكساء ",15.0,korange),
              SizedBox(height: 5),
              Text('4.1.4',style: TextStyle(color: Colors.white),),
              SizedBox(height: 20),
              /*Text('تواصل معنا', style: TextStyle(
                color: korange,
                fontSize: 16.0,
              ),),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  Icon(Icons.mail,color:Colors.white,),
                  SizedBox(width: 10.0),
                  InkWell (onTap: launchMailto,
                    child:
                  Text('info@zaha.app',style: TextStyle(
                    color:  korange,
                    fontFamily: "CustomIcons",
                    fontSize: 16.0,
                  ),),),
                ],
              ) ,
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  Icon(Icons.phone,color:Colors.white,),
                  SizedBox(width: 10.0),
                  FlatButton(child: Text('+963-940665994',style: TextStyle(
                    fontFamily: "CustomIcons",
                  color: Colors.white,
                    fontSize: 16.0,
                  ),textDirection: TextDirection.ltr,),
                  onPressed:_initCall,)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  SizedBox(width: 20.0,),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.facebookF),
                    onPressed: (){
                      _lanchurl("https://www.facebook.com/ZahaSyria");
                    },
                  ),
                  SizedBox(width: 10.0,),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.whatsapp),
                    onPressed: (){
                      //_lanchurl("https://www.facebook.com/ZahaSyria");
                      FlutterOpenWhatsapp.sendSingleMessage("+963940665994", "هل يمكنك مساعدتي");
                    },
                  ),
                  SizedBox(width: 10.0,),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.telegram),
                    onPressed: (){
                      _lanchurl("https://t.me/zaha_1");
                    },
                  ),
                  SizedBox(width: 10.0,),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.public),
                    onPressed: (){
                      _lanchurl("https://www.zaha.app");
                    },
                  )
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  SizedBox(height: 10.0,),
                  Icon(Icons.security,color:Colors.white,),
                  SizedBox(width: 10.0),
                 FlatButton(
                   child: Text('سياسة الاستخدام',style: TextStyle(
                     fontFamily: "CustomIcons",
                     color:  korange,
                     fontSize: 16.0,
                   )),
                   onPressed:  ()=>Navigator.of(context).push(
                       new MaterialPageRoute(
                           builder: (BuildContext context) => new policy())),
                 )

                ],
              ),




         
            ],
          ),
        )

    );

  }
  _initCall() async {
    if(await canLaunch('tel:'+'00963994942994')) {
      await launch('tel:'+'00963994942994');
    } else{
      throw 'could not lauch ';
    }

  }

  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['info@zaha-app.com'],
      //cc: ['info@zaha-app.com'],
      subject: 'من أحد مستخدمي تطبيق زها',
      body: '',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
  }

}






