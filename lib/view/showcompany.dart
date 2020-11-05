import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/tab/newcomdetail.dart';
import 'package:zaha_application/view/companydetail.dart';
import 'package:zaha_application/view/service.dart';


DatabaseHelper _databaseHelper= new DatabaseHelper();
class showcompany extends StatefulWidget{
  showcompany(this.i,this.title) ;
  String i;
  String title;
  @override

  companystate createState() => companystate();
}



class companystate extends State<showcompany>{

  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    String title= widget.title;
    // TODO: implement build
    return Scaffold(

      body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.deepOrange,
          pinned: true,
          snap: false,
          expandedHeight: 160.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text( widget.title,style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13.0
              ,      fontFamily: "CustomIcons",)),
            background: Image.asset('assets/img/cover.jpg',
            fit: BoxFit.fill,),
          ),
        )
        ,SliverFillRemaining(
          child:
                    FutureBuilder<List>(

                      future: databaseHelper.getData1(widget.i),
                      builder: (context ,snapshot){
                        if(snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? new BikeListItem(list1: snapshot.data)
                            : new Center(child: new CircularProgressIndicator(),);
                      },

                    ),




        )
      ],

      ),

    );
  }


}




class BikeListItem extends StatelessWidget {

  List list1;

  BikeListItem({this.list1});


  @override
  Widget build(BuildContext context) {

    return new ListView.builder(
        shrinkWrap: true,
        itemCount:list1.length,
        itemBuilder: (context,i){
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: (){
                _databaseHelper.registervisit("${list1[i]['cid']}");
                /*Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new CourseInfoScreen (list:list1 , index:i,)),

              );*/

                Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new CompanyDetailPagee(id:list1[i]['cid'] , logo:list1[i]['logo'],
                      name: list1[i]['cname'],typoe: list1[i]['typoe'],adress: list1[i]['adress'],phone: list1[i]['phone'],
                      email: list1[i]['email'],whatsup: list1[i]['whatsup'],details: list1[i]['details'],mobilephone: list1[i]['mobilephone'],) ),

                );
                },child:Card(
              elevation: 0.1,
              child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: (){
                  _databaseHelper.registervisit("${list1[i]['cid']}");
                  /*Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new CourseInfoScreen(list:list1 , index:i,)),

                  );*/
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new CompanyDetailPagee(id:list1[i]['cid'] , logo:list1[i]['logo'],
                          name: list1[i]['cname'],typoe: list1[i]['typoe'],adress: list1[i]['adress'],phone: list1[i]['phone'],
                          email: list1[i]['email'],whatsup: list1[i]['whatsup'],details: list1[i]['details'],mobilephone: list1[i]['mobilephone'],) ),

                  );},
                child: Row(
                  children: <Widget>[
                    _buildThumbnail(list1[i]['logo']),
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
                                    list1[i]["cname"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16.0
                                    ,      fontFamily: "CustomIcons",),textDirection: TextDirection.rtl,
                                    softWrap: true,
                                  ),


                                ),
                                //_buildTag(context)
                              ],
                            ),

                            const SizedBox(height: 5.0),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    list1[i]['cityo'],
                                    style: TextStyle(
                                      color: Colors.grey.shade700,      fontFamily: "CustomIcons",),textDirection: TextDirection.rtl,
                                    softWrap: true,
                                  ),
                                ),
                                //_buildTag(context)
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
              ,)
            ,);
        });
  }

  Container _buildThumbnail( var logo) {
    var logo1=logo;
    String bike='https://zaha-app.com/dash/logo/$logo1';
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
          bottomRight: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(bike),
          fit: BoxFit.fill,

        ),
      ),
    );
  }

  Container _buildTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.deepOrange),
      child: Text(
        "",
        style: TextStyle(color: Colors.white,  fontFamily: "CustomIcons", fontWeight: FontWeight.bold),
      ),
    );
  }
}