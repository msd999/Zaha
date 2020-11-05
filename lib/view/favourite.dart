import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/view/companydetail.dart';



class favourite extends StatefulWidget{
  favourite(this.i) ;
int i;
@override

companystate createState() => companystate();
}



class companystate extends State<favourite>{
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
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
              future: databaseHelper.gefavourite(),
              builder: (context ,snapshot){
                if(snapshot.hasError) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.album, size: 50),
                          title: Text('error'),
                          subtitle: Text('error'),
                        ),
                      ],
                    ),
                  );
                }
                return snapshot.hasData
                    ? new BikeListItem(list1: snapshot.data)
                    //: new Center(child: new CircularProgressIndicator(),);
                : Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.album, size: 50),
                        title: Text('Heart Shaker'),
                        subtitle: Text('TWICE'),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],

      ),
      bottomNavigationBar: this._getBottomAppbar(),
    );
  }
  Widget _getBottomAppbar(){
    return BottomNavigationBar(
      backgroundColor: Colors.white54,
      elevation: 0,
      selectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), title: Text("اHOME")),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("CHAT")),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text("PROFILE")),
      ],
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
        itemCount:list1==null?0:list1.length,
        itemBuilder: (context,i){
          return new Container(
            padding: const EdgeInsets.all(10.0),
            child: new GestureDetector(
              onTap: ()=>Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new CompanyDetailPagee(id:list1[i]['cid'] , logo:list1[i]['logo'],
                      name: list1[i]['cname'],typoe: list1[i]['typoe'],adress: list1[i]['adress'],phone: list1[i]['phone'],
                      email: list1[i]['email'],whatsup: list1[i]['whatsup'],details: list1[i]['details'],mobilephone: list1[i]['mobilephone'],) ),

              ),child:Card(
              elevation: 0.1,
              child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: ()=>Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new CompanyDetailPagee(id:list1[i]['cid'] , logo:list1[i]['logo'],
                        name: list1[i]['cname'],typoe: list1[i]['typoe'],adress: list1[i]['adress'],phone: list1[i]['phone'],
                        email: list1[i]['email'],whatsup: list1[i]['whatsup'],details: list1[i]['details'],mobilephone: list1[i]['mobilephone'],) ),

                ),
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
                                      fontWeight: FontWeight.bold, fontSize: 14.0
                                      ,    fontFamily: 'Poppins-Bold',),
                                    softWrap: true,
                                  ),
                                ),
                                _buildTag(context)
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:list1[i]['city'] ,
                                  ),
                                ],
                              ),
                              style: TextStyle(color: Colors.grey.shade700,fontFamily: 'Poppins-Bold',),
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
    String bike='https://zaha.app/appadmin/logo/$logo1';
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
          fit: BoxFit.cover,
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
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}