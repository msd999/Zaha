import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:picker/picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'add_service.dart';
import 'package:getwidget/getwidget.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';




class Add_company extends StatefulWidget {
  @override
  Add_companyState createState() => Add_companyState();

}

class Add_companyState extends State<Add_company> {
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
  List city_list = List(); //edited line
  String _mySelection;
  String _mycountrySelection;
  String _mycitySelection;
  var car_array;
  var is_city = false;
  var select_country = false;

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
      cat_list = resBody;
      car_array = resBody;
    });

    print(resBody);

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
    check_if_gust();
    this.getSWData();
    this.getCountries();
    this.getCities();
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
                                    "أضف شركة",
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
                                    "لإضافة شركتك إلى قائمة الشركات المعروضة في تطبيقنا يرجى تعبئة النموذج التالي.",
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
                                TextFormField(
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
                                      textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                                  ),
                                  items: cat_list.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['category']),
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
                                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                                  ),
                                  items: countries_list.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['country']),
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
                                /*is_city? MultiSelectFormField(

                                  autovalidate: false,

                                  chipBackGroundColor: Colors.red,
                                  chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                                  dialogTextStyle: TextStyle(fontWeight: FontWeight.bold,),
                                  checkBoxActiveColor: Colors.red,
                                  checkBoxCheckColor: Colors.green,
                                  dialogShapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                  title: Text(
                                    "اختر المدن التي توجد فيها شركتك",
                                    style: TextStyle(fontSize: 16),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  dataSource: [
                                    {
                                      "display": "Running",
                                      "value": "Running",
                                    },
                                    {
                                      "display": "Climbing",
                                      "value": "Climbing",
                                    },
                                    {
                                      "display": "Walking",
                                      "value": "Walking",
                                    },
                                  ],
                                  textField: 'display',
                                  valueField: 'value',
                                  okButtonLabel: 'موافق',
                                  cancelButtonLabel: 'إلغاء',
                                  hintWidget: Text('من فضلك اختر مدينة أو أكثر',textDirection: TextDirection.rtl,textAlign: TextAlign.right,),
                                  initialValue: _myActivities,
                                  onSaved: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _myActivities = value;
                                    });
                                  },
                                ):Container(),*/

                                is_city ? city_list.length>0 ? DropdownButton(
                                  hint: SizedBox(
                                      width: MediaQuery.of(context).size.width/2, // for example
                                      child: Text("اختر المدينة",
                                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,)
                                  ),
                                  items: city_list.map((item) {
                                    //_mycitySelection = item['city_id'].toString();
                                    return new DropdownMenuItem(
                                      child: new Text(item['city']),
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
                                TextFormField(
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
                                      hintText: "نبذة عن الشركة "),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: phonesController,
                                  keyboardType: TextInputType.multiline,
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
                                      fontSize: 12, color: Colors.grey),),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: whatsappController,
                                  keyboardType: TextInputType.multiline,
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
                                      fontSize: 12, color: Colors.grey),),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
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
                                SizedBox(
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
        'أضف الشركة ',
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