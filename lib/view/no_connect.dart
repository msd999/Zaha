import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class No_connect extends StatefulWidget{

  No_connect({Key key , this.title}) : super(key : key);
  final String title;

  @override
  No_connectState  createState() => No_connectState();
}

class No_connectState extends State<No_connect> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
        body:Center(child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1,
            child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/img/no.png',width: 100,height: 100,),
                SizedBox(
                  height: 15,
                ),
                Text('يرجى التأكد من اتصالك بالانترنت',style: TextStyle(

                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                ),textAlign: TextAlign.center,),
                SizedBox(
                  height: 15,
                ),

                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.deepOrangeAccent,
                  textColor: Colors.white,
                  child: Text(
                    'حاول مجدداً!',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: "CustomIcons",
                      fontSize: 18
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/splash')
                ),
              ],
            ),
            ),
          ),
        ),
    );
  }
}


