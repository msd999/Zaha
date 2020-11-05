import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zaha_application/Widget/NavDrawer.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/tab/Search.dart';
import 'package:zaha_application/tab/abouttab.dart';
import 'package:zaha_application/tab/hometab.dart';
import 'package:zaha_application/tab/order.dart';




class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();

}

class _ExampleState extends State<Example> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    //profile(),

    hometab() ,
    Homee(),
    order(),



    //favouritetab(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:

            BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('الرئيسية',style: TextStyle( fontSize: 16.0
                    ,      fontFamily: "CustomIcons",),),
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text('بحث',style: TextStyle( fontSize: 16.0
                    ,      fontFamily: "CustomIcons",),),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  title: Text('طلبات أعمال',style: TextStyle( fontSize: 16.0
                    ,      fontFamily: "CustomIcons",),),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
          );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex.toString());
    });
  }
}
