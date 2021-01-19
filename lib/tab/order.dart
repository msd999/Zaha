import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:zaha_application/Widget/NavDrawer.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/pnetwork.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/addorder.dart';
import 'package:zaha_application/view/myOrders.dart';
import 'package:zaha_application/view/newhome.dart';

import 'package:zaha_application/view/showcompany.dart';

import 'package:zaha_application/view/banercompany.dart';

import 'abouttab.dart';
import 'hometab.dart';
import 'new_search.dart';

DatabaseHelper databaseHelper= new DatabaseHelper();
class order extends StatefulWidget{

  @override
  orderstate createState() => orderstate();
}



class orderstate extends State<order>{
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      backgroundColor: Color(0xFF31394d),
      drawer: NavDrawer(),
      appBar: AppBar(

        backgroundColor: Colors.deepOrange,

        title: Text(
          "ZAHA",
        ),
        actions: <Widget>[

          IconButton(
            tooltip: "about app",
            icon: Icon(Icons.info),
            onPressed: ()=>Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new abouttab())),
          ),

          /*IconButton(
            tooltip: "Search",
            icon: Icon(Icons.search),
            onPressed: ()=>Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new abouttab())),
          ),*/





        ],
      ),
      body: Column(
          children: <Widget>[
      Row( mainAxisAlignment: MainAxisAlignment.center, children:  <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child:
       RaisedButton.icon(
         label: Text(
           'طلباتي  ',
           style: TextStyle(
             fontWeight: FontWeight.normal,
             fontFamily: "CustomIcons",
           ),
         ),
        icon: Icon(Icons.menu),
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
        builder: (BuildContext context) => new myOrder())),

         }

      ),

            ),

            Padding(
              padding: EdgeInsets.all(10),
              child:
              RaisedButton.icon(
                  label: Text(
                    'أضف طلب جديد',
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
                          builder: (BuildContext context) => new addorder())),

                  }

              ),

            ),
            ],),
            Expanded(
              child:  FutureBuilder<List>(
                future: databaseHelper.getorder(),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFffffff),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.orange,
        onTap: onTabTapped, // new
        currentIndex: 2,
        type: BottomNavigationBarType.fixed, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('الرئيسية',style: TextStyle( fontSize: 16.0
              ,      fontFamily: "CustomIcons",),),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('بحث',style: TextStyle( fontSize: 16.0
              ,      fontFamily: "CustomIcons",),),
          ),
          new BottomNavigationBarItem(icon: Icon(Icons.business),
            title: Text('طلبات أعمال',style: TextStyle( fontSize: 16.0
              ,      fontFamily: "CustomIcons",),),)
        ],
      ),

    );
  }

  void onTabTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new Example()),
      );
    } /*else if (index == 2) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new order()),
      );
    } */else if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new new_search()),
      );
    }
  }
}






class CategoryChooser extends StatelessWidget {
  List list;
  CategoryChooser({this.list});


  @override
  Widget build(BuildContext context) {
    return   new ListView.builder(
        shrinkWrap: true,
        itemCount:list.length,
        itemBuilder: (context,i){
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
                                      color: const Color(0xff222838),
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


}





