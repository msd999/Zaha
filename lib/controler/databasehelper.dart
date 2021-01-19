import 'dart:io';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/view/login.dart';

class DatabaseHelper {

  String serverUrl = "https://zaha-app.com/api/app-api";
  var status;
  var result_replay;
  String msg;
  var c_favorite_status;
  var fb_status;
  var apple_status;
  var send_order_status;
  List user_companies_list = [];
  List feedbacks_list = [];
  var token;


  loginData(String email, String password) async {
    String myUrl = "$serverUrl/login.php";
    final response = await http.post(myUrl,
        body: {
          "email": "$email",
          "password": "$password"
        });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["Succes"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"],data["name"]);
    }
  }

  forget_pass_send_pin(String email) async {
    status = false;
    msg = "";
    String myUrl = "$serverUrl/forget_pass_send_pin.php";
    final response = await http.post(myUrl,
        body: {
          "email": "$email",
        });
    print(email.toString());
    print (response.body.toString());
    var data = json.decode(response.body);



    if (data["Succes"] == 1) {
      status = true;
    } else {
      status = false;
      msg = data["message"];
    }
  }

  forget_pass_check_pin(String email, String pin) async {
    status = false;
    msg = "";
    String myUrl = "$serverUrl/forget_pass_check_pin.php";
    final response = await http.post(myUrl,
        body: {
          "email": "$email",
          "pin": "$pin",
        });
    print (response.body.toString());
    var data = json.decode(response.body);

    if (data["Succes"] == 1) {
      status = true;
      result_replay = data;
    } else {
      status = false;
      msg = data["message"];
    }
  }

  resetPass(String token, String password) async {
    status = false;
    msg = "";

    String myUrl = "$serverUrl/reset_password.php";
    final response = await http.post(myUrl,
        body: {
          "token": "$token",
          "newpass": "$password"
        });
    print (response.body.toString());

    var data = json.decode(response.body);

    if (data["Succes"] == 1) {
      status = true;
      _save(token,data["name"]);
    } else {
      status = false;
      msg = data["message"];
    }
  }

  vert(String email,String pincode) async {
    String myUrl = "$serverUrl/vert.php";
    final response = await http.post(myUrl,
        body: {
          "email": "$email",
          "pincode": "$pincode"
        });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["Succes"]}');
    } else {
      print('data : ${data["Succes"]}');
    }
  }



  checklogin() async {
    String myUrl = "$serverUrl/checklogin.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print("value: $value");

    if(value == 0){
      status = true;
    }else{

      final response = await http.post(myUrl,
          body: {
            "token": '$value'
          });
      status = response.body.contains('error');

      var data = json.decode(response.body);

      if (status) {
        print('data : ${data["Succes"]}');
      } else {
        print('data : ${data["token"]}');

      }
    }
  }



  company_favorite_status(String c_id) async {
    String myUrl = "$serverUrl/company_favorite_status.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    final response = await http.post(myUrl,
        body: {
          "token": '$value',
          "c_id": '$c_id'
        });

    print ('$c_id');
    if (response.body.contains('error')){
      c_favorite_status = false;
    }else{
      c_favorite_status = true;
    }

  }


  registerData(String name, String email, String password, String phone) async {
    String myUrl = "$serverUrl/register.php";
    final response = await http.post(myUrl,
        body: {
          "name": "$name",
          "email": "$email",
          "password": "$password",
          "phone": "$phone"
        });
    String jsonsDataString = response.body.toString();
    var data = json.decode(jsonsDataString);
    print(data["Succes"]);
    if (data["Succes"] == 1){
      status = false;
      _save(data["token"],name);
    }else{
      status = true;
      msg = data["message"].toString();
    }
    //status = response.body.contains('error');

  }

  registerFB(String name, String email, String fbid) async {
    String myUrl = "https://zaha-app.com/api/app-api/ios/fb_login.php";
    final response = await http.post(myUrl,
        body: {
          "name": "$name",
          "email": "$email",
          "fbid": "$fbid",
        });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      //print('data : ${data["Succes"]}');
      //return 'error';
      fb_status = false;

    } else {
      //print('token : ${data["token"]}');
      _save(data["token"],name);

      fb_status = true;
      //return '${data["token"]}';

    }
  }

  registerApple(String name, String email, String appleid) async {
    String myUrl = "https://zaha-app.com/api/app-api/ios/apple_login.php";
    final response = await http.post(myUrl,
        body: {
          "name": "$name",
          "email": "$email",
          "appleid": "$appleid",
        });
    status = response.body.contains('error');
    print('apple: ${response.body.toString()}');
    var data = json.decode(response.body);

    if (status) {
      //print('data : ${data["Succes"]}');
      //return 'error';
      apple_status = false;

    } else {
      //print('token : ${data["token"]}');
      _save(data["token"],name);

      apple_status = true;
      //return '${data["token"]}';

    }
  }

  send_work_order(String name,String phone, String title, String details) async{
    String myUrl = "https://zaha-app.com/api/app-api/add_order.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    final response = await http.post(myUrl,
        body: {
          "name": "$name",
          "phone": "$phone",
          "title": "$title",
          "details": "$details",
          "token": "$value",
        });

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      var data = json.decode(response.body);

      send_order_status = data.contains('error');

      msg = data["msg"].toString();

    } else {
      // If the server did not return a 201 CREATED response,
      send_order_status = true;
      msg = 'تحقق من اتصالك بالانترنت.';
    }
  }

  send_feedback(String feedback,String country) async{
    String myUrl = "https://zaha-app.com/api/app-api/add_feedback.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    final response = await http.post(myUrl,
        body: {
          "feedback": "$feedback",
          "country": "$country",
          "token": "$value",
        });

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      var data = json.decode(response.body);

      send_order_status = data.contains('error');

      msg = data["msg"].toString();

    } else {
      // If the server did not return a 201 CREATED response,
      send_order_status = true;
      msg = 'تحقق من اتصالك بالانترنت.';
    }
  }

  send_edit_order(String name,String phone, String title, String details, String or_id) async{
    String myUrl = "https://zaha-app.com/api/app-api/edit_order.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    final response = await http.post(myUrl,
        body: {
          "name": "$name",
          "phone": "$phone",
          "title": "$title",
          "details": "$details",
          "token": "$value",
          "or_id": "$or_id",
        });

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      var data = json.decode(response.body);

      send_order_status = data.contains('error');

      msg = data["msg"].toString();

    } else {
      // If the server did not return a 201 CREATED response,
      send_order_status = false;
      msg = 'تحقق من اتصالك بالانترنت.';
    }
  }

  registerG(String name, String email, String gid) async {
    String myUrl = "https://zaha-app.com/api/app-api/ios/g_login.php";
    final response = await http.post(myUrl,
        body: {
          "name": "$name",
          "email": "$email",
          "gid": "$gid",
        });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      //print('data : ${data["Succes"]}');
      //return 'error';
      fb_status = false;

    } else {
      //print('token : ${data["token"]}');
      _save(data["token"],name);

      fb_status = true;
      //return '${data["token"]}';

    }
  }

  Future<List> getzahaData() async {
    String myUrl = "$serverUrl/data.php";
    http.Response response = await http.get(myUrl);
    return json.decode(response.body);
  }

  Future<List> ads() async {
    String myUrl = "$serverUrl/ads2.php";
    http.Response response = await http.get(myUrl);
    return json.decode(response.body);
  }

  Future<List> apple_ads() async {
    String myUrl = "$serverUrl/apple_ads.php";
    http.Response response = await http.get(myUrl);
    return json.decode(response.body);
  }

  Future<List> getData() async {
    String myUrl = "$serverUrl/cat.php";
    http.Response response = await http.get(myUrl);
    return json.decode(response.body);
  }

  Future<List> getorder() async {
    String myUrl = "$serverUrl/work.php";
    http.Response response = await http.get(myUrl);
    return json.decode(response.body);
  }

  Future<List> getmyorder() async {
    String myUrl = "$serverUrl/myworkorder.php";


    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    http.Response response = await http.post(myUrl,
        body: {
          'token': '$value'
        });
    return json.decode(response.body);
  }

  var order_info;
  var myorder_status = false;
  Future<List> getonorder(String or_id) async {
    String myUrl = "$serverUrl/order_info.php";


    http.Response response = await http.post(myUrl,
        body: {
          'or_id': '$or_id'
        });

        print(or_id);

    if(response.body.contains('error'))
      {

      }else{
      order_info = json.decode(response.body);
      myorder_status = true;
    }
  }

  var deletemyorder_status = false;

  Future<List> deletemyorder(String or_id) async {
    String myUrl = "$serverUrl/deletemyorder.php";

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    http.Response response = await http.post(myUrl,
        body: {
          'token': '$value',
          'or_id': '$or_id'
        });
    var is_error = response.body.contains('error');
    var data = json.decode(response.body);

    if(is_error){
      deletemyorder_status = false;
      msg = data["msg"];
      print(msg);
    }else{
      deletemyorder_status = true;
    }
  }

  Future<List> policy() async {
    String myUrl = "$serverUrl/policy.php";
    http.Response response = await http.get(myUrl);
    return json.decode(response.body);
  }

  Future<List> getcompany() async {
    String myUrl = "$serverUrl/get_company.php";
    http.Response response = await http.get(myUrl);
    return json.decode(response.body);
  }


  Future<List> getData1(String id) async {
    String myUrl = "";

    if(Platform.isIOS){
      myUrl = "$serverUrl/ios/companyn.php";
    }else{
      myUrl = "$serverUrl/companyn.php";
    }
    //String myUrl = "$serverUrl/companyn.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    http.Response response = await http.post(myUrl,
        body: {
          'cat_id': '$id',
          'token': '$value'
        });
    print (response.body.toString());


    try {
      var x = json.decode(response.body);

    } on FormatException catch (e) {
      return null;
    }


    return json.decode(response.body);
  }

  Future<List> get_user_companies() async {
    String myUrl = "$serverUrl/my_companies.php";
    //String myUrl = "$serverUrl/companyn.php";
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    http.Response response = await http.post(myUrl,
        body: {
          'token': '$value'
        });
    if(response.body.length > 0){
      user_companies_list = json.decode(response.body);
    }
  }

  Future<List> get_feedbacks() async {
    String myUrl = "$serverUrl/get_feedbacks.php";
    //String myUrl = "$serverUrl/companyn.php";

    http.Response response = await http.post(myUrl,
        body: {

        });
    if(response.body.length > 0){
      feedbacks_list = json.decode(response.body);
    }
  }

  Future<List> getservice(String id) async {
    String myUrl = "$serverUrl/get_company_services.php";
    http.Response response = await http.post(myUrl,
        body: {
          "c_id": '$id',
        });
    return json.decode(response.body);
  }

  Future<List> gefavourite() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/get_user_favorite_companies.php";
    http.Response response = await http.post(myUrl,
        body: {'token': '$value'});
    return json.decode(response.body);
  }

  Future<List> getprofile() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
print(value.toString());
    String myUrl = "$serverUrl/get_user_profile.php";
    http.Response response = await http.post(myUrl,
        body: {'token': '$value'});
    return json.decode(response.body);
  }

  registervisit(String company_id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/user_visit_company.php";
    final response = await http.post(myUrl,
        body: {
          "token": "$value",
          "co_id": "$company_id",

        });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["Succes"]}');
    }
  }

  registerfav(String company_id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/add_company_to_favorite.php";
    final response = await http.post(myUrl,
        body: {
          "token": "$value",
          "co_id": "$company_id",

        });
    status = response.body.contains('error');


    if (status) {
      var data = json.decode(response.body);

      print('data : ${data["Succes"]}');
    }
    else {
      return json.decode(response.body);
    }
  }

  deletefav(String company_id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/delete_from_favourite.php";
    final response = await http.post(myUrl,
        body: {
          "token": "$value",
          "co_id": "$company_id",

        });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["Succes"]}');
    }
    else {
      return json.decode(response.body);
    }
  }


  _save(String token,String name) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);

    final key2 = 'name';
    final value2 = name;
    prefs.setString(key2, value2);
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }



  Future<List> detailcompany(String company_id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/detailcompany.php";
    http.Response response = await http.post(myUrl,
        body: {   "token": "$value",
          "com_id": "$company_id",});
    return json.decode(response.body);
  }







  //isfav
  isfavcom(String company_id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/isfav.php";
    final response = await http.post(myUrl,
        body: {
          "token": "$value",
          "c_id": "$company_id",

        });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["isfav"]}');
    }
    else {
      return json.decode(response.body);
    }
  }
  //


}