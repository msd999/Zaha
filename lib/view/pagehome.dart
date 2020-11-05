import 'package:flutter/material.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/tab/abouttab.dart';
import 'package:zaha_application/tab/favourite.dart';
import 'package:zaha_application/tab/hometab.dart';
import 'package:zaha_application/tab/profile.dart';


class GroceryHomePage extends StatefulWidget {


  @override
  GroceryHomePageState createState() {
    return new GroceryHomePageState();
  }
}

class GroceryHomePageState extends State<GroceryHomePage> {
  int _currentIndex = 0;
  List<Widget> _children = [];
  List<Widget> _appBars = [];

  @override
  void initState() {
    _children.add(hometab());
    _children.add(abouttab());
    _children.add(favouritetab());
    _children.add(profile());
    _appBars.add(_buildAppBar());
    _appBars.add(_buildAppBarOne("حول التطبيق"));
    _appBars.add(_buildAppBarOne("المفضلة"));
    _appBars.add(_buildAppBarOne("انت"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_currentIndex],
      body: _children[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return   AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          "zaha",
        ),
    );
  }
  Widget _buildAppBarOne(String title) {
    return AppBar(
      bottom: PreferredSize(child: Container(color: Colors.grey.shade200, height: 1.0,), preferredSize: Size.fromHeight(1.0)),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(title, style: TextStyle(color: Colors.black)),
    );
  }


  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: _onTabTapped,
      selectedItemColor: korange,
      //backgroundColor: kzaha,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("الرئيسية")),
        BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text("حول التطبيق")),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("المفضلة")),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text("البروفايل")),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
    );
  }

  _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}


