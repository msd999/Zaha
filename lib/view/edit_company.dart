import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picker/picker.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';

import 'my_companies.dart';

class edit_company extends StatefulWidget {
  String id;

  edit_company({this.id});

  @override
  edit_companyState createState() => edit_companyState();

}

class edit_companyState extends State<edit_company> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  final com_nameController = TextEditingController();
  final man_nameController = TextEditingController();
  final categoryController = TextEditingController();
  final addressController = TextEditingController();
  final com_aboutController = TextEditingController();
  final phonesController = TextEditingController();
  final whatsappController = TextEditingController();
  final emailController = TextEditingController();

  var co_id;
  File _image;
  String base64Image;
  List _myActivities;


  int lsubmit_btn_child_index = 0;

  List cat_list = List(); //edited line
  List countries_list = List(); //edited line
  List city_list = List();
  List com_list = List();//edited line
  String _mySelection;
  String _mycountrySelection;
  String _mycitySelection;
  var car_array;
  var is_city = false;
  var select_country = false;
  var is_load_profile_pic = false;
  var is_load_services_pic = false;


  //images

  List<File> profile_image = [];
  List<File> services_image = [];

  Future<String> getCountries() async {

    String url = "https://zaha-app.com/api/app-api/get_countries.php";
    if(Platform.isIOS){
      url = "https://zaha-app.com/api/app-api/ios/get_countries.php";
    }
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      countries_list = resBody;
    });

    //print(resBody);

    return "Sucess";
  }

  Future<String> getCities() async {
    var res = await http
        .get(Uri.encodeFull("https://zaha-app.com/api/app-api/get_cities.php?c_id=${_mycountrySelection}"), headers: {"Accept": "application/json"});

    print(res.body.toString());
    var resBody = json.decode(res.body);

    setState(() {
      //print('city: ${resBody}');
      //print('city: https://zaha-app.com/api/app-api/get_cities.php?c_id=${_mycountrySelection}');
      city_list.clear();
      city_list = resBody;

      is_city = true;
      select_country = true;
    });


    return "Sucess";
  }


  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull("https://zaha-app.com/api/app-api/cat.php"), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      cat_list = resBody;
      car_array = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  Future<String> getComData() async {
    var res = await http
        .post(Uri.encodeFull("https://zaha-app.com/api/app-api/get_company.php"), body: {
      'id': '${widget.id}'
    });
    var resBody = json.decode(res.body);

    setState(() {
      com_list = resBody;
      com_nameController.text = com_list[0]["cname"];
      man_nameController.text = com_list[0]["manger"];
      addressController.text = com_list[0]["adress"];
      com_aboutController.text = com_list[0]["details"];
      phonesController.text = com_list[0]["phone"];
      whatsappController.text = com_list[0]["whatsup"];
      emailController.text = com_list[0]["email"];
      _mySelection = com_list[0]["cat_id"];
      _mycountrySelection = com_list[0]["country"];
    });

    getCities();

    setState(() {
      _mycitySelection = com_list[0]["city"];
    });

    print('https://zaha-app.com/dash/logo/'+com_list[0]["logo"].toString());
    //get profile image
    File img_one = await urlToFile('https://zaha-app.com/dash/logo/'+com_list[0]["logo"].toString());
    profile_image.add(img_one);

    setState(() {
      is_load_profile_pic = true;
    });

    List com_services = await databaseHelper.getservice(com_list[0]["cid"].toString());
    for (int i =0; i < com_services.length;i++){
      File img_one = await urlToFile("https://zaha-app.com/dash/service/${com_services[i]['photo']}");
      services_image.add(img_one);
    }

    //print(resBody);

    setState(() {
      is_load_services_pic = true;
    });
    return "Sucess";
  }

  upload(String fileName) async {

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    http.post('https://zaha-app.com/api/app-api/add_company.php', body: {
      "image": base64Image,
      "name": fileName,
      "cname": com_nameController.text,
      "cat_id": _mySelection,
      "details": com_aboutController.text,
      "phone": phonesController.text,
      "email": emailController.text,
      "address": addressController.text,
      "whatsapp": whatsappController.text,
      "manager": man_nameController.text,
      'token': '$value',
    }).then((result) async {
      if(result.statusCode == 200){
        print('data: ${result.body.toString()}');
        var data = json.decode(result.body);
        var error = data['error'];
        if(error == 1){
          _showDialog('حدث خطأ يرجى المحاولة لاحقاً');
          setState(() {
            lsubmit_btn_child_index = 0;
          });
        }else{
          co_id = data['co_id'];

          final prefs = await SharedPreferences.getInstance();
          final key = 'co_id';
          final value = co_id;
          prefs.setString(key, value.toString());


          //Navigator.pushReplacementNamed(context, '/add_service',arguments: co_id);
          alert_dialog('تم ارسال معلومات الشركة إلى المراجعة بنجاح.', 1, 'تم بنجاح');
        }
      }

      //setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      _showDialog(error.toString());
      setState(() {
        lsubmit_btn_child_index = 0;
      });
      //setStatus(error);
    });
  }

  startUpload(File _image) {
    if (null == _image) {
      return;
    }
    String fileName = _image.path
        .split('/')
        .last;
    upload(fileName);
  }

  var gust = false;

  check_if_gust() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);
    print('$value');
    if (value == '0') {
      setState(() {
        gust = true;
      });
    }
  }

  void initState() {
    super.initState();
    print(widget.id);
    check_if_gust();

    this.getSWData();
    this.getCountries();
    getComData();
    //this.getCities();
  }

  Future getImage() async {
    var image = await Picker.pickImage(

        source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    base64Image = base64Encode(image.readAsBytesSync());
    // if you want save a file on gallery:
    //var filePath = await Picker.saveFile(fileData: image);

    //print(_image.lengthSync());

    setState(() {
      _image = image;
    });
  }

  Widget gust_user() {
    return Scaffold(

        backgroundColor: Colors.grey,
        appBar: AppBar(

          backgroundColor: Colors.deepOrange,

          title: Text(
            "أضف طلب",
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0
              , fontFamily: "CustomIcons",),
          ),
          actions: <Widget>[
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Container(
              //alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 4),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[


                      Text(
                        "عذراً، يجب أن تسجل دخولك حتى تتمكن من إضافة شركة.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0
                          , fontFamily: "CustomIcons",),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      RaisedButton(
                          color: Colors.deepOrange,
                          padding: EdgeInsets.all(15),
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: new Text("تسجيل الدخول", style: TextStyle(
                              fontSize: 18,
                              fontFamily: "CustomIcons",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),
                          elevation: 5.0,
                          splashColor: Colors.yellow[200],
                          animationDuration: Duration(seconds: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),

                          )

                      )


                    ],
                  ),
                ),
              ),
            ),

          ],
        )
    );
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

  alert_dialog(String text, int image_index, String title) {
    String image_name;
    if (image_index == 1) {
      //alert image
      image_name = "assets/tick.png";
    }
    showDialog(

        context: context, builder: (_) =>
        AssetGiffyDialog(
          onlyOkButton: true,
          //buttonCancelText: Text('إلغاء',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16)),
          buttonOkText: Text('موافق', style: TextStyle(
              fontFamily: "CustomIcons", fontSize: 16, color: Colors.white)),
          buttonOkColor: Colors.orange,
          image: Image.asset(image_name, fit: BoxFit.fitHeight),
          title: Text(title,
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "CustomIcons",
                color: Colors.orange),
          ),
          description: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons", fontSize: 16),
          ),
          onOkButtonPressed: () {
            Navigator.pushReplacementNamed(context, '/add_service');

          },
        ));
  }

  send_order() async {
    if (lsubmit_btn_child_index == 0) {
      setState(() {
        lsubmit_btn_child_index = 1;
      });

      if (com_nameController.text == "" || com_nameController.text == null) {
        _showDialog("يرجى إدخال اسم الشركة");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else if (com_nameController.text.length < 3) {
        _showDialog("اسم الشركة قصير جداً");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else
      if (man_nameController.text == "" || man_nameController.text == null) {
        _showDialog("يرجى إدخال اسم الشخص المسؤول. ");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else if (man_nameController.text.length < 3) {
        _showDialog("اسم الشخص المسؤول قصير جداً");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else if (_mySelection == "" || _mySelection == null) {
        _showDialog("يرجى اختيار اختصاص الشركة.");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      }else if (_mycountrySelection == "" || _mycountrySelection == null) {
        _showDialog("يرجى اختيار الدولة.");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      }else if (_mycitySelection == "" || _mycitySelection == null) {
        _showDialog("يرجى اختيار المدينة.");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      }else if (phonesController.text == "" || phonesController.text == null) {
        _showDialog("يرجى إدخال أرقام التواصل.");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else
      if (whatsappController.text == "" || whatsappController.text == null) {
        _showDialog("يرجى إدخال أرقام واتس أب.");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else if (profile_image == null || profile_image.length == 0) {

        _showDialog("يرجى اختيار صورة اللوغو");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;


      } else if ( images.length+services_image.length < 3) {

        _showDialog("يرجى اختيار ثلاث صور خدمات على الأقل");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;


      }else {

        ////////get user parameter///////
        final prefs = await SharedPreferences.getInstance();
        final key = 'token';
        final value = prefs.get(key) ?? 0;



        //////parameter

        Uri uri = Uri.parse('https://zaha-app.com/api/app-api/update_comapny.php');
        http.MultipartRequest request = http.MultipartRequest("POST", uri);

        Map<String, String> postBody = new Map<String, String>();

        postBody.putIfAbsent('token', () => value);
        postBody.putIfAbsent('manager', () => '${man_nameController.text}');
        postBody.putIfAbsent('whatsapp', () => '${whatsappController.text}');
        postBody.putIfAbsent('address', () => '${addressController.text}');
        postBody.putIfAbsent('email', () => '${emailController.text}');
        postBody.putIfAbsent('phone', () => '${phonesController.text}');
        postBody.putIfAbsent('details', () => '${com_aboutController.text}');
        postBody.putIfAbsent('cat_id', () => '${_mySelection}');
        postBody.putIfAbsent('cname', () => '${com_nameController.text}');
        postBody.putIfAbsent('country', () => '${_mycountrySelection}');
        postBody.putIfAbsent('city', () => '${_mycitySelection}');
        postBody.putIfAbsent('coid', () => '${widget.id}');


        /*var path = await FlutterAbsolutePath.getAbsolutePath(profile_image[0].identifier);
        File service_image = new File(path);*/
        base64Image = base64Encode(profile_image[0].readAsBytesSync());
        postBody.putIfAbsent('image', () => '${base64Image}');



        for (var i = 0; i < images.length; i++) {
          var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);

          File service_image = new File(path);
          base64Image = base64Encode(service_image.readAsBytesSync());
          postBody.putIfAbsent('imgs_file $i', () => '${base64Image}');

        }

        for (var i = 0; i < services_image.length; i++) {
          /*var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);

          File service_image = new File(path);*/
          base64Image = base64Encode(services_image[i].readAsBytesSync());
          postBody.putIfAbsent('imgs_file $i', () => '${base64Image}');

        }

        request.fields.addAll(postBody);



        print("start send");
        http.Response response2 =
        await http.Response.fromStream(await request.send());
        print(response2.body.toString());
        var res = json.decode(response2.body);

        if (res["error"] != 1) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyCompanies()));
        } else {
          _showDialog("حدث خطأ! يرجى المحاولة لاحقاً.");
        }
        print("Result: ${response2.statusCode}");
        print("Result: ${response2.body}");

        setState(() {
          lsubmit_btn_child_index = 0;
        });

        //startUpload(_image);
        /*setState(() {
          lsubmit_btn_child_index = 0;
        }); */       /*databaseHelper.send_work_order(com_nameController.text,man_nameController.text,categoryController.text,addressController.text);
      if (databaseHelper.send_order_status == true){
        _showDialog(databaseHelper.msg);
      }else{
        alert_dialog('تم إضافة طلبك بنجاح، سيتم نشره بعد المراجعة.',1,'تم بنجاح');
        com_nameController.text = "";
        man_nameController.text = "";
        categoryController.text = "";
        addressController.text = "";

      }*/


      }
    }



  }



  submite_button_child() {
    if (lsubmit_btn_child_index == 0) {
      return Text(
        'تحديث بيانات الشركة ',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: "CustomIcons",
            color: Colors.white
        ),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  ////////services images///////
  List<Asset> images = List<Asset>();

  Widget image_button() {
    return InkWell(
      onTap: () {
        loadAssets();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(
            top: 10.0, right: 5.0, left: 5.0, bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xFFdd685f),
        ),
        child: Text(
          'انقر لاختيار صور الخدمات',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontFamily: "CustomIcons"),
        ),
      ),
    );
  }

  Widget buildGridView() {



    if (images != null)
      return ResponsiveGridRow(
        children: [

          for (var i = 0; i < services_image.length; i++)
            ResponsiveGridCol(
              xs: 6,
              md: 4,
              child: Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(0),
                /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFebebeb),

              ),*/
                height: 180,
                alignment: Alignment(0, 0),
                //color: Colors.grey,
                child: Column(children: [
                  Image.file(
                    services_image[i],
                  ),
                  IconButton(
                    icon:
                    Icon(Icons.delete),
                    color:
                    Colors.red,
                    onPressed:
                        () {
                      setState(() {
                        //print(images.length.toString());
                        //images.remove(i);
                        services_image.removeAt(i);
                        //print(images.length.toString());

                      });
                      //_deletePost(post.id);
                    },
                  ),
                ],),
              ),
            ),
          for (var i = 0; i < images.length; i++)
            ResponsiveGridCol(
              xs: 6,
              md: 4,
              child: Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(0),
                /*decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFebebeb),

              ),*/
                height: 230,
                alignment: Alignment(0, 0),
                //color: Colors.grey,
                child: Column(children: [ AssetThumb(
                  asset: images[i],
                  width: 300,
                  height: 300,
                ),

                  IconButton(
                    icon:
                    Icon(Icons.delete),
                    color:
                    Colors.red,
                    onPressed:
                        () {
                      setState(() {
                        print(images.length.toString());
                        //images.remove(i);
                        images.removeAt(i);
                        print(images.length.toString());

                      });
                      //_deletePost(post.id);
                    },
                  ),
                ],),
              ),
            ),
        ],
      );
    else
      return Container();
  }

  Future<void> loadAssets() async {
    List<Asset> images_temp = List<Asset>();

    setState(() {
      images_temp = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 30,
        enableCamera: true,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList ;
    });
  }
  /////////////////////////

  ////////logo images///////
  List<Asset> logo_image = List<Asset>();

  Widget logo_image_button() {
    return InkWell(
      onTap: () {
        loadAssets_logo();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(
            top: 10.0, right: 5.0, left: 5.0, bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xFFdd685f),
        ),
        child: Text(
          'اختيار صورة لوغو الشركة',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontFamily: "CustomIcons"),
        ),
      ),
    );
  }

  Widget buildGridView_logo() {
    if (profile_image != null) {

        return ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              xs: 12,
              md: 12,
              child: Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(0),
                height: MediaQuery.of(context).size.width/2,
                alignment: Alignment(0, 0),
                //color: Colors.grey,
                child: Column(children: [ Image.file(
                  profile_image[0],fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width/2,
                ),
                ],),
              ),
            ),
          ],
        );


    }else {
      return Container();
    }
  }

  Future<void> loadAssets_logo() async {
    List<Asset> images_temp = List<Asset>();

    setState(() {
      images_temp = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        //selectedAssets: logo_image,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    logo_image.clear();
    logo_image = resultList ;
    var path = await FlutterAbsolutePath.getAbsolutePath(logo_image[0].identifier);
    File service_image = new File(path);
    profile_image.clear();
    profile_image.add(service_image);

    setState(() {

    });
  }
/////////////////////////

  @override
  Widget build(BuildContext context) {
    return gust ? gust_user()
        : Scaffold(
      backgroundColor: const Color(0xff222838),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('أضف شركة', style: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: "CustomIcons",
        ),),
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 1,
                      child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "تعديل معلومات الشركة",
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "CustomIcons",
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),
                                //comapny title
                                TextFormField(

                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),
                                  controller: com_nameController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "اسم الشركة"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //manager name
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),

                                  controller: man_nameController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(

                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "اسم الشخص المسؤول"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                cat_list.length >0 ? DropdownButton(
                                  hint: SizedBox(
                                      width: MediaQuery.of(context).size.width/2, // for example
                                      child: Text("اختر اختصاص الشركة",
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

                                ):Center(child: new GFLoader(type:GFLoaderType.circle)),
                                SizedBox(
                                  height: 10,
                                ),
                                countries_list != null? countries_list.length >0 ? DropdownButton(
                                  hint: SizedBox(
                                      width: MediaQuery.of(context).size.width/2, // for example
                                      child: Text("اختر الدولة",
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

                                ):Center(child: new GFLoader(type:GFLoaderType.circle)):Center(child: new GFLoader(type:GFLoaderType.circle)),
                                SizedBox(
                                  height: 10,
                                ),
                                is_city ? city_list.length>0 ? DropdownButton(
                                  hint: SizedBox(
                                      width: MediaQuery.of(context).size.width/2, // for example
                                      child: Text("اختر المدينة",
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

                                ):Center(child: new GFLoader(type:GFLoaderType.circle)):Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                //company address
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),
                                  controller: addressController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "عنوان الشركة والمحافظة"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //about comapny
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),
                                  controller: com_aboutController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 3,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "نبذة عن الشركة "),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //phone numbers
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),
                                  controller: phonesController,
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "أرقام التواصل"),
                                ),
                                Text(
                                  "لإضافة أكثر من رقم استخدم الفاصلة, مثال: 0988776655, 0933111222",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),),
                                SizedBox(
                                  height: 10,
                                ),
                                //whatsapp number
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),
                                  controller: whatsappController,
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "أرقام واتس أب"),
                                ),
                                Text(
                                  "لإضافة أكثر من رقم استخدم الفاصلة, مثال: 0988776655, 0933111222",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),),
                                SizedBox(
                                  height: 10,
                                ),
                                //email
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w600,
                                    fontFamily: "CustomIcons",
                                  ),
                                  controller: emailController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "البريد الإلكتروني"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //chose logo image
                                /*SizedBox(
                                  width: double.infinity, // match_parent
                                  child: RaisedButton(
                                    color: Colors.blueAccent,
                                    textColor: Colors.white,
                                    child: Text(
                                      "اختر صورة لوغو الشركة", style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "CustomIcons",
                                    ),),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            5.0)),
                                    onPressed: getImage,

                                  ),),
                                SizedBox(
                                  height: 5,
                                ),
                                //display logo image
                                _image == null
                                    ? Image.asset('assets/img/default_logo.png')
                                    : Image.file(_image),*/


                                SizedBox(
                                  height: 15,
                                ),
                                //send button
                                Column(
                                  children: <Widget>[
                                    //Center(child: Text('Error: $_error')),
                                    logo_image_button(),
                                    is_load_profile_pic?
                                    buildGridView_logo():Center(child: new GFLoader(type:GFLoaderType.circle)),
                                  ],
                                ),

                                SizedBox(
                                  height: 15,
                                ),
                                //send button
                                Column(
                                  children: <Widget>[
                                    //Center(child: Text('Error: $_error')),
                                    image_button(),

                                    buildGridView(),
                                  ],
                                ),

                                InkWell(onTap:(){send_order(); } , child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),

                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [Colors.deepOrange, Colors.deepOrange])),
                                  child: submite_button_child(),
                                ),
                                )

                              ])

                      )
                  )
              )
            ],
          )


      ),

    );
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    //Directory tempDir = await getTemporaryDirectory();
    Directory documentDirectory = await getApplicationDocumentsDirectory();

// get temporary path from temporary directory.
    String tempPath = documentDirectory.path;


// create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.jpg');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get("$imageUrl");
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }
}