import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/service.dart';

import 'package:mailto/mailto.dart';

import 'package:flutter/services.dart';

DatabaseHelper _databaseHelper = new DatabaseHelper();

class CompanyDetailPagee extends StatefulWidget {
  String id;
  String logo;
  String name;
  String typoe;
  String adress;
  String phone;
  String email;
  String whatsup;
  String details;
  String mobilephone;
  List list;
  int index;

  CompanyDetailPagee({this.id, this.logo,this.name,this.typoe,this.adress
  ,this.phone,this.email,this.whatsup,this.details,this.mobilephone});

  @override
  DetailState createState() => DetailState();
}

class DetailState extends State<CompanyDetailPagee> {

  List<String> _phonelist = [];
  
  create_phone_list(){
    if(widget.phone.isNotEmpty && widget.phone != null){
      if(widget.phone.contains(',')){


        var str = widget.phone.split(',');
        for(int i = 0; i < str.length; i++){
          _phonelist.add(str[i]);
        }
      }else{
        //print(widget.phone);
        _phonelist.add(widget.phone.toString());
      }


    }
    
    if(widget.mobilephone.contains(",")){
      var str = widget.mobilephone.split(',');
      for(int i = 0; i < str.length; i++){
        _phonelist.add(str[i]);
      }
    }else{
      _phonelist.add(widget.mobilephone.toString());
    }
  }
  bool isfav = false;

  fav_check(){
    //print(widget.list[widget.index]['c_id'].toString());
    _databaseHelper.company_favorite_status(widget.id).whenComplete(() {
      if (_databaseHelper.c_favorite_status==true) {

        setState(() {isfav = true;});
      }

      print(_databaseHelper.c_favorite_status.toString());
    });

  }
  void initState() {
    super.initState();
    fav_check();
    create_phone_list();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String bike =
        "https://zaha-app.com/dash/logo/${widget.logo}";
    return Scaffold(
      body: Stack(
        children: <Widget>[
          /*Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.black26,

            ),
            height: 400,
        child: Image(
                image: CachedNetworkImageProvider(bike), fit: BoxFit.cover),
          ),*/
          SingleChildScrollView(

            //padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: CachedNetworkImageProvider(bike), fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height/4,
                width: MediaQuery.of(context).size.height,),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${widget.name}",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 28.0,
                      fontFamily: "CustomIcons",
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text(
                        "${widget.typoe}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          isfav ? Icons.favorite : Icons.favorite_border,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          bool results = isfav;

                          if (isfav) {
                            _databaseHelper
                                .deletefav(
                                    "${widget.id}")
                                .whenComplete(() {
                              setState(() {isfav = false;});
                            });
                          } else {
                            _databaseHelper
                                .registerfav(
                                    "${widget.id}")
                                .whenComplete(() {
                              setState(() {isfav = true;});
                            });


                          }
                        }),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                    Icon(
                    Icons.location_on,
                    size: 50.0,
                    color: Colors.orange,
                    textDirection: TextDirection.rtl,
                  ),

                          Text('${widget.adress.toString().trim()}',textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: "CustomIcons",
                            ),
                          ),
                          SizedBox (
                            height: 15,
                          ),

                          Text(
                            "تواصل مباشرة من خلال: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "CustomIcons",
                            ),
                            textDirection: TextDirection.rtl,
                          ),



                        ],
                      ),

                      const SizedBox(
                        height: 5.0,
                      ),
                      Center(

                        child: Row(

                            mainAxisAlignment: MainAxisAlignment.center ,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: <Widget>[

                          email_widget(),

                          FlatButton(
                              child: Icon(
                                FontAwesomeIcons.whatsapp,
                                size: 40,
                                color: Colors.indigo,
                              ),
                              onPressed: () {
                                FlutterOpenWhatsapp.sendSingleMessage(
                                    "${widget.whatsup}",
                                    "");
                              }),
                          FlatButton(
                              child: Icon(
                                Icons.phone_android,
                                size: 40,
                                color: Colors.indigo,
                              ),
                              //onPressed: _initCall
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('اضغط على الرقم للاتصال',textAlign: TextAlign.center,),
                                    content: Container(
                                      width: double.maxFinite,
                                      //height: double.infinity,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _phonelist.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text(_phonelist[index],textAlign: TextAlign.center,),
                                            onTap: () { _initCall(_phonelist[index]);},
                                          );
                                        },
                                      ),
                                    ),

                                  );
                                });
                          },
                          ),

                        ]),
                      ),


                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: Colors.deepOrangeAccent,
                          textColor: Colors.white,
                          child: Text(
                            'عرض الخدمات',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: "CustomIcons",
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () => Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => new service(
                                      "${widget.id}"))),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),

                        child: Divider(
                          color: Colors.black,
                          thickness: 0.5,
                        ),),
                      RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.info,color: Colors.deepOrange,),

                            Text(" لمحة عن الشركة ",style: TextStyle(
                              fontSize: 25,
                              color: Colors.indigo,
                              fontFamily: "CustomIcons",
                              fontWeight:FontWeight.w300,

                            ),),

                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "${widget.details}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                          fontFamily: "CustomIcons",
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),

                        child: Divider(
                          color: Colors.black,
                          thickness: 0.5,
                        ),),
                      /*RaisedButton(
                        onPressed: () {},
                        color: Colors.white,
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.comment,color: Colors.deepOrange,),

                            Text(" التعليقات ",style: TextStyle(
                              fontSize: 25,
                              color: Colors.indigo,
                              fontFamily: "CustomIcons",
                              fontWeight:FontWeight.w300,

                            ),),

                          ],
                        ),
                      ),
                      GFCard(
                        boxFit: BoxFit.cover,
                        elevation: 1,
                        border: Border.all(),
                        color:  Colors.white60,
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: AssetImage('assets/img/avatar.png'),
                          ),
                          title: Text('أحمد عبد الله',style: TextStyle(color: Colors.orange,fontSize: 18.0,
                            fontFamily: "CustomIcons",),),
                        ),
                        content: Text("شركة مميزة وتعامل راقي ومحترم",textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.indigo,fontSize: 16.0,
                            fontFamily: "CustomIcons",),),

                      ),

                      GFCard(
                        boxFit: BoxFit.cover,
                        color: const Color(0xff222838),
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: AssetImage('assets/img/avatar.png'),
                          ),
                          title: Text('محمد الحسن',style: TextStyle(color: Colors.orange,fontSize: 18.0,
                            fontFamily: "CustomIcons",),),
                        ),
                        content: Text("تعامل الشركة راق وخدماتهم مميزة والدعم الفني ممتاز",textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.white,fontSize: 16.0,
                            fontFamily: "CustomIcons",),),

                      ),

                      GFCard(
                        boxFit: BoxFit.cover,
                        color: const Color(0xff222838),
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: AssetImage('assets/img/avatar.png'),
                          ),
                          title: Text('اليسار غانم',style: TextStyle(color: Colors.orange,fontSize: 18.0,
                            fontFamily: "CustomIcons",),),
                        ),
                        content: Text("تعامل الشركة راق وخدماتهم مميزة والدعم الفني ممتاز",textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.white,fontSize: 16.0,
                            fontFamily: "CustomIcons",),),

                      ),*/
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: korange),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Failed'),
            content: new Text('لا يمكنك الاضافة للمغضلة'),
            actions: <Widget>[
              new RaisedButton(
                child: new Text(
                  'Close',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget line_phone(){
    if(widget.phone.isNotEmpty && widget.phone != null && widget.phone != ""){
      return InkWell (onTap: _initCalla,
        child: Text.rich(
          TextSpan(children: [

            TextSpan(
              text:
              '${widget.phone}',
            ),
            WidgetSpan(
                child: Icon(
                  Icons.phone,
                  size: 30.0,
                  color: Colors.grey,
                )),
          ]),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
            fontFamily: "CustomIcons",
          ),
        ),);
    SizedBox (
    height: 5,
    );
    }else{
      return Container();
    }
  }

  Widget email_widget(){

    if(widget.email.isNotEmpty && widget.email != null && widget.email != ""){
    print("-${widget.email}-");

    return FlatButton(
        child: Icon(
          Icons.mail,
          size: 40,
          color: Colors.indigo,
        ),
        onPressed: () {
          launchMailto;
        });

    /*return InkWell (onTap: launchMailto,
      child:
      Text.rich(

        TextSpan(children: [

          TextSpan(
            text:
            '${widget.email}',
          ),
          WidgetSpan(
              child: Icon(
                Icons.email,
                size: 30.0,
                color: Colors.grey,
              )),
        ]),
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
          fontFamily: "CustomIcons",
        ),
      ),);*/
    }else{
      return Container();
    }
  }

  _initCall(String number) async {
    if (await canLaunch('tel:$number')) {
      await launch('tel:$number');
    } else {
      //throw 'could not lauch ';
      print('could not lauch $number') ;
    }
  }


  launchMailto() async {
    final mailtoLink = Mailto(
      to: [widget.email.trim()],
      //cc: ['info@zaha-app.com'],
      subject: 'من أحد مستخدمي تطبيق زها',
      body: '',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
  }

  _initCalla() async {
    if (await canLaunch('tel:${widget.phone}')) {
      await launch('tel:${widget.phone.trim()}');
    } else {
      //throw 'could not lauch ';
      print('tel:${widget.phone.trim()}') ;
    }

  }


}









