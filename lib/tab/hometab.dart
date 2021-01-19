import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/pnetwork.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/companydetail.dart';
import 'package:zaha_application/view/showcompany.dart';
import 'package:zaha_application/view/banercompany.dart';

DatabaseHelper databaseHelper= new DatabaseHelper();
class hometab extends StatefulWidget{
  hometab({Key key , this.title}) : super(key : key);
  final String title;
  @override
  homestate createState() => homestate();
}



class homestate extends State<hometab>{
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: Column(
          children: <Widget>[
            get_banner(),
            SizedBox(height: 10.0,),
            Expanded(
              child:  FutureBuilder<List>(
                future: databaseHelper.getData(),
                builder: (context ,snapshot){
                  if(snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? new CategoryChooser(list: snapshot.data)
                      : new Center(child: new CircularProgressIndicator(),);
                },

              ),
              flex:4 ,)
          ]
      ),

      floatingActionButton:FloatingActionButton(child:Icon(Icons.live_help),backgroundColor: korange, onPressed:_alertDialog),
    );
  }
  _alertDialog() {

    showDialog(
        context: context,builder: (_) => AssetGiffyDialog(
      buttonCancelText: Text('إلغاء',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16,color: Colors.white)),
      buttonOkText: Text('موافق',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16,color: Colors.white)),
      buttonOkColor: Colors.orange,
      image: Image.asset("assets/support.png",fit: BoxFit.cover),
      title: Text('خدمة اسعاد المتعاملين',
        style: TextStyle(
            fontSize: 18.0, fontFamily: "CustomIcons",color: Colors.orange),
      ),
      description: Text('هل تواجه أي مشاكل في استخدام التطبيق؟ نحن هنا لمساعدتك، فقط انقر على زر موافق للتحدث مع موظف الدعم الفني عبر واتس أب.',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "CustomIcons",fontSize: 16),
      ),
      onOkButtonPressed: () {
        FlutterOpenWhatsapp.sendSingleMessage("+963940665994", "هل يمكنك مساعدتي");
        Navigator.pop(context);
      },
    ) );
  }

  get_banner(){
    /*if(Platform.isIOS){                                                      //check for ios if developing for both android & ios
      return Expanded(child:
      FutureBuilder<List>(
        future: databaseHelper.apple_ads(),
        builder: (context ,snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new bannerr(list: snapshot.data)
              : new Center(child: new CircularProgressIndicator(),);
        },
      ),flex: 2,);
    }else{*/
      return Expanded(child:
      FutureBuilder<List>(
        future: databaseHelper.ads(),
        builder: (context ,snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new bannerr(list: snapshot.data)
              : new Center(child: new CircularProgressIndicator(),);
        },
      ),flex: 2,);
    //}
  }

}





class CategoryChooser extends StatelessWidget {
  List list;
  CategoryChooser({this.list});


  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      itemCount:list.length,

      scrollDirection: Axis.vertical,
      itemBuilder: (context,i) {

        return GestureDetector(
          onTap: (){


            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context) => new showcompany(list[i]['cat_id'],list[i]['category']) ),

            );},
          child:Card(
            color: kzaha,
            elevation: 0.1,
            shape: RoundedRectangleBorder(  borderRadius: BorderRadius.circular(40.0),),

            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),

              child: Row(
                children: <Widget>[
                  _buildThumbnail(list[i]['cat_img']),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  list[i]["category"],
                                  textDirection:TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold, fontSize: 22.0
                                    ,      fontFamily: "CustomIcons",),
                                  softWrap: true,
                                ),
                              ),

                            ],
                          ),
                          const SizedBox(height: 5.0),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          )
          ,);
      },

    );

  }
  Container _buildThumbnail( var logo) {
    var logo1=logo;
    String bike='https://zaha-app.com/dash/catimg/$logo1';
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: false
            ? BorderRadius.only(
          topRight: Radius.circular(4.0),
          bottomRight: Radius.circular(4.0),
        )
            : BorderRadius.only(
          topLeft: Radius.circular(4.0),
          bottomLeft: Radius.circular(4.0),
        ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(bike),
          fit: BoxFit.fill,
        ),
      ),
    );
  }


}




class bannerr extends StatelessWidget {
  List list;
  bannerr({this.list});
  String path="https://daas-1.com/zaha/zaha/admin2" ;

  @override
  Widget build(BuildContext context) {
    return Swiper(
      outer: false,
      itemBuilder: (context, i) {
        String bike='https://zaha-app.com/dash/logo/${list[i]['photo']}';
        //print(bike);
        return GestureDetector(
            onTap: (){
              print(list[i].toString());
              if(list[i]['comid'] != "258"){
                Navigator.of(context).push(

                  new MaterialPageRoute(
                      builder: (BuildContext context) => new CompanyDetailPagee(id:list[i]['cid'] , logo:list[i]['logo'],
                        name: list[i]['cname'],typoe: list[i]['typoe'],adress: list[i]['adress'],phone: list[i]['phone'],
                        email: list[i]['email'],whatsup: list[i]['whatsup'],details: list[i]['details'],mobilephone: list[i]['mobilephone'],) ),
                );
              }

            },child:ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child:Image(

              image: CachedNetworkImageProvider(bike), fit: BoxFit.fill),

        )
        ); },
      autoplay: true,
      duration: 300,
      viewportFraction: 0.8,
      scale: 0.9,

      pagination: new SwiperPagination(margin: new EdgeInsets.all(5.0)),
      itemCount: list.length,

    );

  }



}


class BeautifulAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75),
                  bottomLeft: Radius.circular(75),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade200,
                child: Image.asset('assets/img/customer-service.png',width: 60,),



              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        "خدمة إسعاد المتعاملين",
                      style: Theme.of(context).textTheme.title,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                      child: Text(
                          "هل تريد مني مساعدتك في استخدام التطبيق ",textDirection: TextDirection.rtl,),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text("لا"),
                            color: Colors.red,
                            colorBrightness: Brightness.dark,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: RaisedButton(
                            child: Text("نعم"),
                            color: Colors.green,
                            colorBrightness: Brightness.dark,
                            onPressed: () {
                              FlutterOpenWhatsapp.sendSingleMessage("+963940665994", "هل يمكنك مساعدتي");

                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}