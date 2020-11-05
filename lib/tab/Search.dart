import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:http/http.dart' as http;

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/view/companydetail.dart';


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

class Homee extends StatefulWidget {
  @override
  _HomeStatee createState() => _HomeStatee();
}

class _HomeStatee extends State<Homee> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<Post>> _getALlPosts(String text) async {
    /*await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    if (isReplay) return [Post("Replaying !", "Replaying body")];
    if (text.length == 5) throw Error();
    if (text.length == 6) return [];*/

    String myUrl = "https://zaha-app.com/api/app-api/search.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    http.Response response = await http.post(myUrl,
        body: {
          'search': '$text',
          'token': '$value'
        });

    List data = json.decode(response.body);
    print(data.length.toString());

    List<Post> posts = [];


    for (int i = 0; i < data.length; i++) {
      posts.add(Post(data[i]["id"],data[i]["name"],data[i]["cat"],data[i]["logo"],data[i]["email"],data[i]["phone"],data[i]["mobilephone"]
          ,data[i]["adress"],data[i]["typoe"],data[i]["details"],data[i]["whatsup"]));
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Directionality( // add this
        textDirection: TextDirection.rtl, // set this property
        child: SearchBar<Post>(
          loader: Center(child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange),),),
          searchBarPadding: EdgeInsets.symmetric(horizontal: 15),
          headerPadding: EdgeInsets.symmetric(horizontal: 5),
          listPadding: EdgeInsets.symmetric(horizontal: 5),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          placeHolder: Text(""),
          cancellationWidget: Icon(Icons.close),
          emptyWidget: Center(child:Text("لا يوجد نتائج")),
          onError: (error) {
            return Center(child:Text("لا يوجد نتائج"));
          },
          hintText: "أبحث هنا",

          hintStyle: TextStyle(
            color: Colors.grey[50],
          ),
          iconActiveColor: Colors.white,
          textStyle: TextStyle(

            color: Colors.white,
            fontWeight: FontWeight.bold,

          ),

          searchBarStyle: SearchBarStyle(
            backgroundColor: Colors.deepOrange,
            padding: EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10),

          ),

          //indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),

          onCancelled: () {
            print("Cancelled triggered");
          },
          //mainAxisSpacing: 10,
          //crossAxisSpacing: 5,
          crossAxisCount: 1,
          onItemFound: (Post post, int index) {
            return Container (
            child: Card(
              elevation: 0.5,
              child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: (){
                  _databaseHelper.registervisit(post.id);
                  List list1;
                  /*Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new CourseInfoScreen(list:list1 , index:i,)),

                  );*/
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new CompanyDetailPagee(id:post.id , logo: post.image,
                          name: post.name,typoe: post.manager,adress: post.address,phone: post.phone,
                          email: post.email,whatsup: post.whatsApp,details: post.details,mobilephone: post.mobile,) ),

                  );},
                child: Row(
                  children: <Widget>[
                    _buildThumbnail(post.image),
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
                                    post.name,
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
                                    post.cat,

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
            );
          },
        ),
        ),
      ),
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


