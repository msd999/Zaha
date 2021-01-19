import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/Widget/NavDrawer.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/view/companydetail.dart';
import 'package:zaha_application/view/newhome.dart';

import 'abouttab.dart';
import 'hometab.dart';
import 'order.dart';

class Post {
  final String name;
  final String cat;
  final String id;
  final String image;
  final String email;
  final String phone;
  final String mobile;
  final String address;
  final String manager;
  final String details;
  final String whatsApp;

  Post(this.id,this.name, this.cat,this.image,this.email,this.phone,this.mobile,this.address,this.manager,this.details,this.whatsApp);
}
DatabaseHelper _databaseHelper= new DatabaseHelper();

class new_search extends StatefulWidget {
  @override
  new_search_Statee createState() => new_search_Statee();
}

class new_search_Statee extends State<new_search> {

  List cat_list = List(); //edited line
  List countries_list = List(); //edited line
  List city_list = List(); //edited line
  String _mySelection ;
  String _mycountrySelection;
  String _mycitySelection;
  final search_nameController = TextEditingController();

  var is_city = false;
  var select_country = false;

  int lsubmit_btn_child_index = 0;

  List<Post> results;

  Future<String> getCountries() async {

    String url = "https://zaha-app.com/api/app-api/get_countries.php";
    if(Platform.isIOS){
      url = "https://zaha-app.com/api/app-api/ios/get_countries.php";
    }
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    print(resBody.toString());
    setState(() {
      countries_list.clear();
      countries_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }
  Future<String> getCities() async {
    var res = await http
        .get(Uri.encodeFull("https://zaha-app.com/api/app-api/get_cities.php?c_id=${_mycountrySelection}"), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      print('city: ${resBody}');
      print('city: https://zaha-app.com/api/app-api/get_cities.php?c_id=${_mycountrySelection}');
      city_list.clear();
      city_list = resBody;
    });


    return "Sucess";
  }
  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull("https://zaha-app.com/api/app-api/cat.php"), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      cat_list.clear();
      cat_list = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  void initState() {
    super.initState();
    this.getSWData();
    this.getCountries();
    this.getCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31394d),
      drawer: NavDrawer(),
      appBar: AppBar(

        backgroundColor: Colors.deepOrange,

        title: Text(
          "ZAHA - البحث",style: TextStyle(color: Colors.white,  fontFamily: "CustomIcons", fontWeight: FontWeight.bold),
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
      body: Container(
    child: SingleChildScrollView(
    child: Column(children: [
      Card(
    shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.grey, width: 0.5),
    borderRadius: BorderRadius.circular(5),
    ),
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.all(10),
    //color: Colors.grey,
    elevation: 0,

    child:Column(
    //mainAxisSize: MainAxisSize.min,
    //scrollDirection: Axis.vertical,
    children: <Widget>[

      Padding(
          padding: const EdgeInsets.all(10.0),
          child:TextFormField(
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              //fontWeight: FontWeight.w600,
              fontFamily: "CustomIcons",
            ),
            controller: search_nameController,
            keyboardType: TextInputType.text,
            maxLines: null,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(0),
                  ),
                ),
                hintText: "أدخل كلمة البحث"),
          )),



        cat_list.length >0 ?  Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0,),
            child:DropdownButton(
isExpanded: true,
          hint: SizedBox(
              width: MediaQuery.of(context).size.width/2 - 30, // for example
              //width: 300, // for example
              child: Text("جميع الاختصاصات",
                textAlign: TextAlign.right,textDirection: TextDirection.rtl, style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  //fontWeight: FontWeight.w600,
                  fontFamily: "CustomIcons",
                ),)
          ),

          items: cat_list.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['category'], style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                //fontWeight: FontWeight.w600,
                fontFamily: "CustomIcons",
              )),
              value: item['cat_id'].toString(),
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;

              print(_mySelection);
            });
          },
          value: _mySelection,

        )):Center(child: new GFLoader(type:GFLoaderType.circle)),

        countries_list != null? countries_list.length >0 ? Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0,),child:  DropdownButton(
          isExpanded: true,
          hint: SizedBox(
              //width: MediaQuery.of(context).size.width/2 - 30, // for example
              width: 150, // for example
              child: Text("جميع الدول",
                textAlign: TextAlign.right,textDirection: TextDirection.rtl,style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  //fontWeight: FontWeight.w600,
                  fontFamily: "CustomIcons",
                ),)
          ),
          items: countries_list.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['country'], style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                //fontWeight: FontWeight.w600,
                fontFamily: "CustomIcons",
              )),
              value: item['country_id'].toString(),
            );
          }).toList(),
          onChanged: (newVal) {

            setState(() {
              _mycountrySelection = newVal;
              _mycitySelection = null;
              //print(_mycountrySelection);
              city_list.clear();
              city_list = List();
              is_city = true;
            });
            getCities();
          },
          value: _mycountrySelection,

        ),):Center(child: new GFLoader(type:GFLoaderType.circle)):Center(child: new GFLoader(type:GFLoaderType.circle)),

        is_city ? city_list.length>0 ? Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 5.0,bottom: 5.0,),child:DropdownButton(
        isExpanded: true,
        hint: SizedBox(
            width: MediaQuery.of(context).size.width/2, // for example
            child: Text("جميع المدن",
              textAlign: TextAlign.right,textDirection: TextDirection.rtl,style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                //fontWeight: FontWeight.w600,
                fontFamily: "CustomIcons",
              ),)
        ),
        items: city_list.map((item) {
          //_mycitySelection = item['city_id'].toString();
          return new DropdownMenuItem(
            child: new Text(item['city'], style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              //fontWeight: FontWeight.w600,
              fontFamily: "CustomIcons",
            )),
            value: item['city_id'].toString(),
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            _mycitySelection = newVal;
            //print(_mycitySelection);
          });
        },
        value: _mycitySelection,

      )):Center(child: new GFLoader(type:GFLoaderType.circle)):Container(),

        InkWell(onTap:(){_getALlPosts(); } , child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),bottomLeft: Radius.circular(5)),

              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.deepOrange, Colors.deepOrange])),
          child: submite_button_child(),
        ),
        ),

  ])),
      results != null ? Card(
  shape: RoundedRectangleBorder(
  side: BorderSide(color: Colors.grey, width: 0.5),
  borderRadius: BorderRadius.circular(5),
  ),
  clipBehavior: Clip.antiAlias,
  margin: const EdgeInsets.all(10),
  //color: Colors.grey,
  elevation: 0,

  child:Column(
  //mainAxisSize: MainAxisSize.min,
  //scrollDirection: Axis.vertical,
  children: <Widget>[

          Column(children: [

            for(int i = 0; i< results.length;i++)
              Container (
                child: Card(
                  elevation: 0.5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4.0),
                    onTap: (){
                      _databaseHelper.registervisit(results[i].id);
                      List list1;
                      /*Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new CourseInfoScreen(list:list1 , index:i,)),

                  );*/
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new CompanyDetailPagee(id:results[i].id , logo: results[i].image,
                              name: results[i].name,typoe: results[i].manager,adress: results[i].address,phone: results[i].phone,
                              email: results[i].email,whatsup: results[i].whatsApp,details: results[i].details,mobilephone: results[i].mobile,) ),

                      );},
                    child: Row(
                      children: <Widget>[
                        _buildThumbnail(results[i].image),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,

                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        results[i].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16.0
                                          ,      fontFamily: "CustomIcons",),textDirection: TextDirection.rtl,
                                        softWrap: true,
                                      ),


                                    ),
                                    //_buildTag(context)
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        results[i].cat,

                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,      fontFamily: "CustomIcons",),textDirection: TextDirection.rtl,
                                        softWrap: true,
                                      ),
                                    ),
                                    //_buildTag(context)
                                  ],
                                ),
                                //const SizedBox(height: 5.0),

                              ],
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


          ],)
  ])):Container(),


    ],)

    )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFffffff),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.orange,
        onTap: onTabTapped, // new
        currentIndex: 1,
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
    } else if (index == 2) {
      Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) => new order()),
      );
    } /*else if (index == 1) {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) => new new_search()),
      );
    }*/
  }

  submite_button_child() {
    if (lsubmit_btn_child_index == 0) {
      return Text(
        ' ابحث ',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: "CustomIcons",
            color: Colors.white,
          fontSize: 25,
        ),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }


  Future<List<Post>> _getALlPosts() async {


      setState(() {
        lsubmit_btn_child_index = 1;
      });

      /*if (search_nameController.text == "" || search_nameController.text == null) {
        _showDialog("يرجى إدخال كلمة البحث");
        setState(() {
          lsubmit_btn_child_index = 0;
        });
        return null;
      }*/

      if(results != null){
        results.clear();
      }


    String cat;
    String Country;
    String City;



    if (_mySelection == "" || _mySelection == null){
      cat = "0";
    }else{
      cat = _mySelection;
    }

    if (_mycountrySelection == "" || _mycountrySelection == null){
      Country = "0";
    }else{
      Country = _mycountrySelection;
    }

    if (_mycitySelection == "" || _mycitySelection == null){
      City = "0";
    }else{
      City = _mycitySelection;
    }

      String myUrl = "https://zaha-app.com/api/app-api/new_search.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    http.Response response = await http.post(myUrl,
        body: {
          'search': '${search_nameController.text}',
          'token': '$value',
          'country': '$Country',
          'cat': '$cat',
          'city': '$City'
        });

      print('token: $value country: $Country cat: $cat city: $City');
      print(response.body.toString());

      if(response.body.contains("error404")){
        _showDialog("لا يوجد نتائج");
        setState(() {
          lsubmit_btn_child_index = 0;
          results = [];
        });
        return null;
      }else if(response.body.contains("error500")){
        _showDialog("حدث خطأ غير معروف يرجى المحاولة لاحقاً");
        setState(() {
          lsubmit_btn_child_index = 0;
          results = [];
        });
        return null;
      }
    List data = json.decode(response.body);


    List<Post> posts = [];


    for (int i = 0; i < data.length; i++) {
      posts.add(Post(data[i]["id"],data[i]["name"],data[i]["cat"],data[i]["logo"],data[i]["email"],data[i]["phone"],data[i]["mobilephone"]
          ,data[i]["adress"],data[i]["typoe"],data[i]["details"],data[i]["whatsup"]));
    }

      setState(() {
        lsubmit_btn_child_index = 0;
        results = posts;
      });


  }

  void _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('تنبيه'),
            content: new Text(msg),
            actions: <Widget>[
              new RaisedButton(

                child: new Text(
                  'موافق',
                ),

                onPressed: () {
                  Navigator.of(context).pop();
                },

              ),
            ],
          );
        }
    );
  }

  Container _buildThumbnail( var logo) {
    var logo1=logo;
    print(logo1);
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
}