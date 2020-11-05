import 'package:cached_network_image/cached_network_image.dart';

import'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/service.dart';


DatabaseHelper  _databaseHelper= new DatabaseHelper();
class CompanyDetails extends StatefulWidget{

  String index;
  CompanyDetails(this.index) ;
  @override
  DetailState  createState() => DetailState();

}
class DetailState extends State<CompanyDetails>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      FutureBuilder<List>(

        future: _databaseHelper.detailcompany("${widget.index}"),
        builder: (context ,snapshot){
          if(snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new CompanyDetail(list: snapshot.data)
              : new Center( child:CircularProgressIndicator());
        },

      ),

    );
  }










  }





class CompanyDetail extends StatelessWidget {
  List list;
  CompanyDetail({this.list});


  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      itemCount:list.length,

      scrollDirection: Axis.vertical,
      itemBuilder: (context,i) {
        String bike='https://zaha.app/appadmin/logo/${list[i]['logo']}';
        return GestureDetector(
          onTap: (){},
          child:Stack(
            children: <Widget>[
              Container(
                foregroundDecoration: BoxDecoration(
                  color: Colors.black26,

                ),
                height: 400,
                child: Image(
                    image: CachedNetworkImageProvider(bike), fit: BoxFit.fill),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16.0,bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 250,)
                    ,Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0) ,
                      child: Text(
                        list[i]['cname'],
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 28.0,
                          fontFamily: "CustomIcons",
                          fontWeight: FontWeight.bold,


                        ),

                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(height: 16.0,),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Text(list[i]['typoe'],
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          color:Colors.white,
                          icon:Icon(Icons.favorite),
                          onPressed: (){

                            _databaseHelper.registerfav(list[i]['cid']).whenComplete(() {

                            });

                          },

                        )
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.all(32.0),
                      color:Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Text.rich(TextSpan(
                                        children: [WidgetSpan(
                                            child: Icon(Icons.location_on,size: 16.0,color:Colors.grey,)

                                        ),

                                          TextSpan(
                                            text: list[i]['adress'],
                                          )
                                        ]
                                    ),
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                        fontFamily: "CustomIcons",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[

                                      FlatButton(child:Icon(Icons.phone,color:kzaha,),
                                          onPressed:_initCall('jdskajdksaj')
                                      )
                                      ,
                                      Text(list[i]['phone'],style: TextStyle(
                                        fontFamily: "CustomIcons",
                                        color: Colors.black,
                                        fontSize: 12.0,
                                      ),),
                                    ],
                                  ),



                                  Row(
                                    children: <Widget>[

                                      Icon(Icons.email,color:kzaha,),

                                      SizedBox(width: 10.0),
                                      Text( list[i]['email'],style: TextStyle(
                                        fontFamily: "CustomIcons",
                                        color:  kzaha,
                                        fontSize: 12.0,
                                      ),),
                                    ],
                                  )

                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 30.0,),
                          Center(
                            child:Row(
                                children:<Widget>[
                                  FlatButton(child:Icon(FontAwesomeIcons.whatsapp,color:kzaha,),
                                      onPressed:(){
                                        FlutterOpenWhatsapp.sendSingleMessage("+963${ list[i]['whatsup']}", "");
                                      }
                                  ),
                                  FlatButton(child:Icon(Icons.phone_android,color:Colors.black,),
                                      onPressed:_initCall('sjdkjsakd')
                                  )
                                  ,Text("تواصل مباشرة"
                                    ,style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "CustomIcons",
                                    ),)
                                ]
                            ),),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)
                              )
                              ,
                              color: Colors.deepOrangeAccent,
                              textColor: Colors.white,
                              child: Text('عرض الخدمات',style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: "CustomIcons",
                              ),),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 32.0,
                              ),
                              onPressed: ()=>Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) => new service("${list[i]['cid']}"))),
                            ),
                          ),
                          const SizedBox(height: 10.0,),
                          Text("لمحة عن الشركة".toUpperCase(),style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            fontFamily: "CustomIcons",
                          ),),
                          const SizedBox(height: 10.0,),
                          Text("${ list[i]['details']}",textDirection:TextDirection.rtl,style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0,

                            fontFamily: "CustomIcons",


                          ),
                          ) ,      const SizedBox(height: 30.0,),
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
                  iconTheme: IconThemeData(color:korange),
                  elevation: 0,
                  centerTitle: true,
                  title: Text("تفاصيل",style: TextStyle(
                    fontSize: 16.0,
                    color:korange,
                    fontWeight: FontWeight.normal     ,
                    fontFamily: "CustomIcons",

                  ),),
                ),
              ),
            ],
          )

          ,);
      },

    );



    }









  _initCall(String phone) async {
    if(phone != null){
    if(await canLaunch('tell:' + '+963' + '${phone}')) {
      await launch('tell:'+'+963' +'${phone}');
    } {
      throw 'could not lauch ';
    }

  }
}}