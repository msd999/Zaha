import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:zaha_application/controler/databasehelper.dart';

import '../pnetwork.dart';


class service extends StatefulWidget{
  service(this.i);

  String i;


  @override
  servicestate createState() => servicestate();
}



class servicestate extends State<service>{
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    print('id: ${widget.i}');
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
              title: Text('ZAHA'),
              background: Image.asset('assets/img/cover.jpg',
                fit: BoxFit.fill,),
            ),
          )
          ,SliverFillRemaining(
            child:

            FutureBuilder<List>(

              future: databaseHelper.getservice(widget.i),
              builder: (context ,snapshot){
                if(snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? new BikeListItem(list1: snapshot.data)
                     :Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                        new CircularProgressIndicator(),
                        SizedBox(height: 5,)
                        ,Text("الرجاء الانتظار",style: TextStyle(color: Colors.black,
                      fontFamily:"CustomIcons",
                    ),)
                      ],


               );//new CircularProgressIndicator(),);
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




    return new Container(child:list1==null
        ? Center(child: Text('none'))
        :ListView.builder(
        shrinkWrap: true,
        itemCount:list1==null?0:list1.length,
        itemBuilder: (context,i){

          String bike='https://zaha-app.com/dash/service/${list1[i]['photo']}';
          /*return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: () =>_showImageDialog(context, bike),
              child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                margin: EdgeInsets.only(bottom: 20.0),
                height: 300,
                child: Row(
                  children: <Widget>[
                    Expanded(child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(image: CachedNetworkImageProvider(bike), fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: [
                            BoxShadow(color: Colors.grey,offset: Offset(5.0,5.0), blurRadius: 10.0)
                          ]
                      ),
                    )),
                    Expanded(child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(list1[i]["service"],style: TextStyle(
                            fontFamily: "CustomIcons",
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,

                          ),),
                          SizedBox(height: 10.0,),
                          Text(list1[i]["detail"], style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            fontFamily: "CustomIcons",
                          )),

                        ],
                      ),
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey,offset: Offset(5.0,5.0), blurRadius: 10.0)
                          ]
                      ),
                    ),)
                  ],
                ),
              ),
              )
            ,);*/

          return Card(
            elevation: 18.0,

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              onTap: () =>_showImageDialog(context, bike),


            child: Column(
              children: <Widget>[
                Image.network(
                  bike,
                  fit: BoxFit.fill,

                ),

                service_title_widget(i),
                service_details_widget(i),

              ],
            ),



            ),

            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(8.0),);
        }),);
  }



Widget service_title_widget(int i){
    print(list1[i]["service"]);
    if(list1[i]["service"].toString().contains("null")  || list1[i]["service"].toString().trim() == ''){
      return Container();
    }else{
      return Padding(padding: EdgeInsets.all(15.0), child: Text(" ${list1[i]["service"]}",style: TextStyle(
        fontFamily: "CustomIcons",
        color: Colors.black,
        fontSize: 22.0,
        fontWeight: FontWeight.w700,

      ),),);
    }

}

  Widget service_details_widget(int i){
    if(list1[i]["detail"].toString().contains("null") || list1[i]["detail"].toString().trim() == ''){
      return Container();
    }else{
      return Padding(padding: EdgeInsets.all(15.0), child: Text(" ${list1[i]["detail"]}", style: TextStyle(
        color: Colors.grey,
        fontSize: 18.0,
        fontFamily: "CustomIcons",
      )),);
    }

  }

}


  _showImageDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: PNetworkImage(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10.0),
               
              ],
            ),
          ],
        ),
      ),
    );


}