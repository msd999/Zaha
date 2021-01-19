import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zaha_application/Widget/NavDrawer.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/tab/Search.dart';
import 'package:zaha_application/tab/abouttab.dart';
import 'package:zaha_application/tab/hometab.dart';
import 'package:zaha_application/tab/new_search.dart';
import 'package:zaha_application/tab/order.dart';




class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();

}

class _ExampleState extends State<Example> with TickerProviderStateMixin {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3,vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      drawer: NavDrawer(),
      appBar: AppBar(
        //backgroundColor: Color(0xFF275879),
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
        ],

        /*bottom: TabBar(
        unselectedLabelColor: Colors.white,
        labelColor: Colors.amber,
        tabs: [
        new Tab(icon: new Icon(Icons.call)),
        new Tab(
        icon: new Icon(Icons.chat),
        ),
        new Tab(
        icon: new Icon(Icons.notifications),
        )
        ],
        controller: _tabController,

          ),*/
      ),
      body:  /*TabBarView(
            children: [
              new Text("This is call Tab View"),
              new Text("This is chat Tab View"),
              new Text("This is notification Tab View"),
            ],
            controller: _tabController,),*/
        Center(
        child: hometab(),
      ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFffffff),
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.orange,
          onTap: onTabTapped, // new
          currentIndex: 0,
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
    /*if (index == 0) {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new hometab()),
      );
    } else*/ if (index == 2) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new order()),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new new_search()),
      );
    }
  }
}
