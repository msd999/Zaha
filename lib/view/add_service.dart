import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:picker/picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';




class Add_service extends StatefulWidget {

  @override
  Add_serviceState createState() => Add_serviceState();

}

class Add_serviceState extends State<Add_service> {

  DatabaseHelper databaseHelper = new DatabaseHelper();
  File _image;
  String base64Image;


  final servicename_nameController = TextEditingController();
  final com_aboutController = TextEditingController();

  int lsubmit_btn_child_index = 0;

  upload(String fileName) async {

    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    final prefss = await SharedPreferences.getInstance();
    final keys = 'co_id';
    final values = prefs.get(keys) ?? 0;

    http.post('https://zaha-app.com/api/app-api/add_service.php', body: {
      "image": base64Image,
      "name": fileName,
      "service_name": servicename_nameController.text,
      "details": com_aboutController.text,
      'com_id': '$values',
      'token': '$value',
    }).then((result) {
      if(result.statusCode == 200){
        var data = json.decode(result.body);
        var error = data['error'];
        if(error == 1){
          _showDialog('حدث خطأ يرجى المحاولة لاحقاً');
          setState(() {
            lsubmit_btn_child_index = 0;
          });
        }else{

          //Navigator.pushReplacementNamed(context, '/GroceryHomePage');
          alert_dialog('تم ارسال الخدمة إلى المراجعة بنجاح',1,'تم بنجاح');
          setState(() {
            servicename_nameController.text = '';
            com_aboutController.text = '';
            _image = null;
            lsubmit_btn_child_index = 0;
          });

        }
      }

      //setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      _showDialog('حدث خطأ يرجى المحاولة لاحقاً');
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
    check_if_gust();
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

  @override
  Widget build(BuildContext context) {
    return gust ? gust_user()
        : Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
          title: Text('أضف  خدمة', style: TextStyle(
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
                                    "أضف خدمة",
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
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "تم ارسال شركتك للمراجعة، يمكنك الآن اضافة الخدمات التي تقدمها شركتك مع شرح وصور من خلال النموذج التالي.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      //fontWeight: FontWeight.w600,
                                      fontFamily: "CustomIcons",
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(

                                  controller: servicename_nameController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "عنوان الخدمة"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),



                                TextFormField(
                                  controller: com_aboutController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                      ),
                                      hintText: "وصف الخدمة"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),


                                SizedBox(
                                  width: double.infinity, // match_parent
                                  child: RaisedButton(
                                    color: Colors.blueAccent,
                                    textColor: Colors.white,
                                    child: Text(
                                      "اختر صورة الخدمة", style: TextStyle(
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
                                _image == null
                                    ? Image.asset('assets/img/default_logo.png')
                                    : Image.file(_image),


                                SizedBox(
                                  height: 15,
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
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                InkWell(onTap:(){
                                  Navigator.pushReplacementNamed(context, '/my_companies');
                                } , child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),

                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [Colors.green, Colors.lightGreen])),
                                  child: Text('تم الانتهاء من اضافة الخدمات',style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "CustomIcons",
                                    color: Colors.white,
                                  ),),
                                ),
                                ),

                              ])

                      )
                  )
              )
            ],
          )


      ),

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
            Navigator.pop(context);
            //Navigator.pop(context);
          },
        ));
  }

  send_order() async {
    if (lsubmit_btn_child_index == 0) {
      setState(() {
        lsubmit_btn_child_index = 1;
      });

      if (servicename_nameController.text == "" || servicename_nameController.text == null) {
        _showDialog("يرجى إدخال اسم الشركة");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else if (servicename_nameController.text.length < 3) {
        _showDialog("اسم الشركة قصير جداً");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else if (_image.lengthSync() > 2000000) {
        _showDialog("لا يمكن أن يتجاوز حجم الصورة ٢ ميغابايت.");
        setState(() {
          lsubmit_btn_child_index = 0;
        });        return;
      } else {
        startUpload(_image);
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
        'أضف الخدمة ',
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
}