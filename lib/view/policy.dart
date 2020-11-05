import 'package:flutter/material.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'dart:io';
import 'package:zaha_application/style/consts.dart';
DatabaseHelper databaseHelper= new DatabaseHelper();
class policy extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back, color:korange,),
          onPressed: ()=>Navigator.of(context).pop(),
        ),

      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(


              children: <Widget>[
                Image.asset("assets/img/logo1.png"),
                Text("سياسة استخدام".toUpperCase(),
                  textDirection:TextDirection.rtl,style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  fontFamily: "CustomIcons",
                ),),
                SizedBox(height: 16.0,),
                Text("سياسة الاستخدام الخاصة بالتطبيق",
                  textDirection:TextDirection.rtl,
                style: TextStyle(
                  fontFamily: "CustomIcons",
                )),

               ])),
          Expanded(

child:
                FutureBuilder<List>(
                  future: databaseHelper.policy(),
                  builder: (context ,snapshot){
                    if(snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new policylist(list: snapshot.data)
                        : new Center(child: new CircularProgressIndicator(),);
                  },

                ),


          )  ]
                ,
            ),

    );
  }



}



class policylist extends StatelessWidget {
  List list;
  policylist({this.list});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      itemCount:list.length,

      scrollDirection: Axis.vertical,
      itemBuilder: (context,i) {

        return GestureDetector(
          onTap: (){},
          child:Row(
            textDirection:TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Material(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: Colors.red,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Text('${list[i]['idd']}', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "CustomIcons",
                      fontSize: 18.0
                  )),
                ),
              ),
              SizedBox(width: 1.0,),
              Expanded(
                child: Column(
                  textDirection:TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${list[i]['title']}",
                  textDirection:TextDirection.rtl,
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0 ,
                       fontFamily: "CustomIcons",
                    )),
                    SizedBox(height: 10.0,),
                    Text("${list[i]['detail']}",textDirection:TextDirection.rtl),
                  ],
                ),
              )
            ],
          )

          ,);
      },

    );

  }
}