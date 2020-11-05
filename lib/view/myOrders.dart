import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/pnetwork.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/addorder.dart';
import 'package:zaha_application/view/editOrder.dart';

import 'package:zaha_application/view/showcompany.dart';

import 'package:zaha_application/view/banercompany.dart';

DatabaseHelper databaseHelper= new DatabaseHelper();
class myOrder extends StatefulWidget{

  @override
  myOrderstate createState() => myOrderstate();
}



class myOrderstate extends State<myOrder>{
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xff222838),
      appBar: AppBar(

        backgroundColor: Colors.deepOrange,

        title: Text(
          "طلباتي",
          style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
            ,      fontFamily: "CustomIcons",),
        ),
        actions: <Widget>[

        ],
      ),

      body: Column(
          children: <Widget>[

            Expanded(
              child:  FutureBuilder<List>(
                future: databaseHelper.getmyorder(),
                builder: (context ,snapshot){
                  if(snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? list_build(snapshot.data)
                      : new Center(child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),);
                },

              ),
              flex:4 ,)
          ]
      ),


    );
  }

  Widget list_build(List list){
    return   new ListView.builder(
        shrinkWrap: true,
        itemCount:list.length,
        itemBuilder: (context,i){

          var text_status = 'بانتطار المراجعة';
          var bg_color = Colors.orange;
          int it_ok = 0;
          print("status:  ${list[i]["status"]}");

          if(list[i]["status"] == '0'){

            it_ok = 1;
          }else if(list[i]["status"] == '1'){
            text_status = 'تم النشر ';
            bg_color = Colors.green;
            it_ok = 1;
          }else if(list[i]["status"] == '2'){
            text_status = 'تم رفض النشر ';
            bg_color = Colors.red;
            it_ok = 1;
          }
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: (){


              },child:Card(

              elevation: 0.8,
              child: InkWell(

                borderRadius: BorderRadius.circular(4.0),
                onTap: (){


                },
                child: Row(
                  children: <Widget>[

                    Expanded(
                      child: Container(


                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(child:
                            Text(
                              list[i]["subject"],
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold, fontSize: 20.0
                                ,      fontFamily: "CustomIcons",),
                              softWrap: true,
                            ),
                            ),

                            const SizedBox(height: 5.0),

                            Text(
                              list[i]["detail"],
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 16.0
                                ,      fontFamily: "CustomIcons",),),


                            const SizedBox(height: 5.0),

                            Divider(
                                color: Colors.black
                            ),
                            Center(child:Text(
                              "${list[i]["name"]} -  ${list[i]["phone"]} - ${list[i]["add_date"]}",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14.0
                                ,      fontFamily: "CustomIcons",),),),

                            statuss(text_status,it_ok,bg_color,list[i]["or_id"]),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            )
              ,)
            ,);
        });
  }

  statuss(String text, int it_ok, var bg_color , String post_id){
    print(" ok: $it_ok");
    if(it_ok == 1){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Divider(
            color: Colors.black,
          ),
          Text(
            " الحالة: $text",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: bg_color,
              fontSize: 14.0
              ,      fontFamily: "CustomIcons",),),

          Row( mainAxisAlignment: MainAxisAlignment.center, children:  <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child:
              RaisedButton(
                  child: Row(children: <Widget>[
                    Text(
                        " تعديل ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "CustomIcons",
                      ),
                    ),

                    Icon(Icons.edit),
                  ],),

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.grey,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  onPressed: () => {Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new editorder(post_id))),
                  }

              ),

            ),

            Padding(
              padding: EdgeInsets.all(5),
              child:
              RaisedButton(
                  
                  child: deleteButtonChild(),
                  //icon: Icon(Icons.delete),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.red,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  onPressed: () => {

                    print("orid: $post_id"),
                    setState((){
                      deleteButtonChild_index = 1;
                    }),
                    databaseHelper.deletemyorder(post_id).whenComplete(() {
                      if (databaseHelper.deletemyorder_status == true){
                        setState((){
                          deleteButtonChild_index = 0;
                        });
                      }else{
                        setState((){
                          deleteButtonChild_index = 0;
                        });
                      }
                    }),
                  }

              ),

            ),



          ]),
        ],) ;
    }else{
      return Container();
    }

  }

  int deleteButtonChild_index = 0;

  Widget deleteButtonChild() {
    if (deleteButtonChild_index == 0) {
      return Row(children: <Widget>[
        Text(
          " حذف ",
          style: const TextStyle(
        color: Colors.white,
            fontFamily: "CustomIcons",
      ),
        ),

        Icon(Icons.delete),
      ],);
    }else{
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),

      );
    }
  }



}












