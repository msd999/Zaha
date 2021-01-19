import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:picker/picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/Widget/NavDrawer.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:getwidget/getwidget.dart';
import 'add_company.dart';
import 'companydetail.dart';
import 'edit_company.dart';


var fullwidth;
DatabaseHelper databaseHelper = new DatabaseHelper();

class MyCompanies extends StatefulWidget {

  @override
  MyCompaniesState createState() => MyCompaniesState();

}

class MyCompaniesState extends State<MyCompanies> {

  var gust = false;
  var is_loading = true;

  check_if_gust() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);
    print('$value');
    if (value == '0') {
      setState(() {
        gust = true;
      });
    }
  }

  void initState() {
    super.initState();
    check_if_gust();

    databaseHelper.get_user_companies().whenComplete(() {

        setState(() {
          is_loading = false;
        });

    });

  }

  Widget gust_user() {
    return Scaffold(

        backgroundColor: Colors.grey,
        appBar: AppBar(

          backgroundColor: Colors.deepOrange,

          title: Text(
            "شركاتي",
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0
              , fontFamily: "CustomIcons",),
          ),
          actions: <Widget>[
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Container(
              //alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Text(
                        "عذراً، يجب أن تسجل دخولك حتى تتمكن من إضافة شركة.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0
                          , fontFamily: "CustomIcons",),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      RaisedButton(
                          color: Colors.deepOrange,
                          padding: EdgeInsets.all(15),
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: new Text("تسجيل الدخول", style: TextStyle(
                              fontSize: 18,
                              fontFamily: "CustomIcons",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                          elevation: 5.0,
                          splashColor: Colors.yellow[200],
                          animationDuration: Duration(seconds: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),

                          )

                      )


                    ],
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    fullwidth = MediaQuery.of(context).size.width;
    return gust ? gust_user()
        : Scaffold(
      backgroundColor: const Color(0xff222838),
      drawer: NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('شركاتي', style: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: "CustomIcons",
        ),),
      ),
      body: Column(
          children: <Widget>[
            Row( mainAxisAlignment: MainAxisAlignment.center, children:  <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child:
                RaisedButton.icon(
                    label: Text(
                      'أضف شركة',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "CustomIcons",
                      ),
                    ),
                    icon: Icon(Icons.add),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    color: Colors.deepOrange,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                    onPressed: () => {Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new Add_company())),

                    }

                ),

              ),


            ],),
            Expanded(
              child:  is_loading
                      ? new Center(child: new GFLoader(type:GFLoaderType.circle),)
                      : new BikeListItem(list1: databaseHelper.user_companies_list),)


          ]
      ),

    );
  }
}

class BikeListItem extends StatelessWidget {

  List list1;

  BikeListItem({this.list1});


  @override
  Widget build(BuildContext context) {

    if(list1.length > 0){


      return new ListView.builder(
          shrinkWrap: true,
          itemCount:list1.length,
          itemBuilder: (context,i){
            var bg_color = Colors.green;
            String status = 'منشور';
            if(list1[i]['state'] == '2')
            {
              bg_color = Colors.orange;
              status = 'قيد المراجعة';
            }

            else if(list1[i]['state'] == '0')
            {
              bg_color = Colors.red;
              status = 'مرفوض';
            }
            return new Container(

              padding: const EdgeInsets.all(10.0),
              child: new GestureDetector(
                onTap: (){
                  //databaseHelper.registervisit("${list1[i]['cid']}");
                  /*Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new CourseInfoScreen (list:list1 , index:i,)),

              );*/

                  /*Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new CompanyDetailPagee(id:list1[i]['cid'] , logo:list1[i]['logo'],
                        name: list1[i]['cname'],typoe: list1[i]['typoe'],adress: list1[i]['adress'],phone: list1[i]['phone'],
                        email: list1[i]['email'],whatsup: list1[i]['whatsup'],details: list1[i]['details'],mobilephone: list1[i]['mobilephone'],) ),

                );*/
                },child: InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: (){
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new CompanyDetailPagee(id:list1[i]['cid'] , logo:list1[i]['logo'],
                            name: list1[i]['cname'],typoe: list1[i]['typoe'],adress: list1[i]['adress'],phone: list1[i]['phone'],
                            email: list1[i]['email'],whatsup: list1[i]['whatsup'],details: list1[i]['details'],mobilephone: list1[i]['mobilephone'],) ),

                    );
                  },
                  child:
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: [

                        Padding(
                          padding: const EdgeInsets.all(0),

                          child: Image.network(
                            'https://zaha-app.com/dash/logo/${list1[i]['logo']}',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.width/3,),


                        ),



                        Padding(
                          padding: const EdgeInsets.all(8.0),

                          child: Text(list1[i]["cname"],textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "CustomIcons",
                            ),softWrap: true,),


                        ),

                        Padding(
                          padding: const EdgeInsets.all(4.0),

                          child: Text('الحالة: $status',textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: bg_color,
                              fontFamily: "CustomIcons",
                            ),softWrap: true,),


                        ),


                        Padding(
                          padding: EdgeInsets.all(3),
                          child:
                          RaisedButton.icon(
                              label: Text(
                                'تعديل بيانات الشركة',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "CustomIcons",
                                ),
                              ),
                              icon: Icon(Icons.edit),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              color: Colors.grey,
                              textColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 32.0,
                              ),
                              onPressed: () => {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) => new edit_company(id: list1[i]["cid"]))),

                              }

                          ),

                        ),




                      ],
                    ),
                  ),





                ),

              )




              ,);
          });

    }else{
      return Text('لم تقم بإضافة شركات بعد',style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold, fontSize: 20.0
        ,      fontFamily: "CustomIcons",),
        softWrap: true,
      );
    }

  }




}