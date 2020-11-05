import 'dart:convert';
import 'dart:math';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:http/http.dart' as http;
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';

DatabaseHelper databaseHelper= new DatabaseHelper();
class search_tab extends StatefulWidget{


  @override
  search_tabstate createState() => search_tabstate();
}



class search_tabstate extends State<search_tab> {
  List<Post> result_list = [];
  DatabaseHelper databaseHelper = new DatabaseHelper();
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
            icon: Icon(Icons.search),
            headerPadding: EdgeInsets.symmetric(horizontal: 10),
            listPadding: EdgeInsets.symmetric(horizontal: 10),
            onSearch: _getALlPosts,
            searchBarController: _searchBarController,
            placeHolder: Text("placeholder"),
            hintText: "Search hint text",
            hintStyle: TextStyle(
              color: Colors.grey[100],
            ),
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            searchBarStyle: SearchBarStyle(
              backgroundColor: Colors.deepOrange,
              padding: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),

            ),

            indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),

            onItemFound: (Post post, int index) {
              return Container(
                color: Colors.lightBlue,
                child: ListTile(
                  title: Text(post.name),
                  isThreeLine: true,
                  subtitle: Text(post.cat),

                ),
              );
            },
            onError: (error) {
              return Center(
                child: Text("Error occurred : $error"),
              );
            },
            cancellationWidget: Text("إلغاء"),
            emptyWidget: Center(child:Text("لا يوجد نتائج")),
            loader: Center(child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange),),),
          ),
        ),
      ),
    );
  }

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
      posts.add(Post(data[i]["id"],data[i]["name"],data[i]["cat"],data[i]["image"]));
    }
    return posts;
  }
}

class Post {
  final String id;
  final String name;
  final String cat;
  final String image;

  Post(this.id,this.name, this.cat,this.image);
}