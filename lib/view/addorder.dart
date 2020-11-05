import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';

import 'myOrders.dart';

class addorder extends StatefulWidget {
  @override
  _addorderState createState() => _addorderState();

}

class _addorderState extends State<addorder> {

  DatabaseHelper databaseHelper = new DatabaseHelper();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final titleController = TextEditingController();
  final detailsController = TextEditingController();

  var gust = false;
  check_if_gust() async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key);
    print('$value');
    if(value == '0'){
      setState(()  {
        gust = true;
      });
    }
  }

  void initState() {
    super.initState();
    check_if_gust();
  }

  @override
  Widget build(BuildContext context) {

    return gust ? gust_user()
        :Scaffold(
        backgroundColor: const Color(0xff222838),
        appBar: AppBar(

        backgroundColor: Colors.deepOrange,

        title: Text(
          "أضف طلب",
          style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0
            ,      fontFamily: "CustomIcons",),
    ),
    actions: <Widget>[

    ],
    ),
    body: SingleChildScrollView(
    child :Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: <Widget>[
        Container(

          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10,bottom: MediaQuery.of(context).size.height / 10),
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
                      "أضف طلب",
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
                  Text('''هل تبحث عن متعهدين، عمال أو ورش بناء للبدء بمشروعك! 
تقدم بطلبك للحصول على العرض الأفضل ضمن نخبة من الاختصاصيين الأفضل في سورية
''',style:TextStyle(fontFamily: "CustomIcons",fontSize: 14,),textAlign: TextAlign.right,textDirection: TextDirection.rtl,),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(

                        hintText: "اسمك"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(

                        hintText: "رقم هاتف للتواصل"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(

                        hintText: "عنوان الطلب"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: detailsController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(

                        hintText: "تفاصيل الطلب"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton.icon(
                      label: Text(
                        'أضف طلب جديد',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: "CustomIcons",
                        ),
                      ),
                      icon: Icon(Icons.add),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 32.0,
                      ),
                      onPressed: () => {send_order(),

                      }

                  ),


                ],
              ),
            ),
          ),
        ),

      ],
    ),),
    );
  }

  send_order() async{
    if(nameController.text == "" || nameController.text == null){
      _showDialog("يرجى إدخال الاسم");
      return;
    }else if(phoneController.text == "" || phoneController.text == null ){
      _showDialog("يرجى إدخال رقم الهاتف");
      return;
    }else if(titleController.text == "" || titleController.text == null ){
      _showDialog("يرجى إدخال عنوان الطلب");
      return;
    }else if(detailsController.text == "" || detailsController.text == null ){
      _showDialog("يرجى إدخال تفاصيل الطلب");
      return;
    }else{

      databaseHelper.send_work_order(nameController.text,phoneController.text,titleController.text,detailsController.text);
      if (databaseHelper.send_order_status == true){
        _showDialog(databaseHelper.msg);
      }else{
        alert_dialog('تم إضافة طلبك بنجاح، سيتم نشره بعد المراجعة.',1,'تم بنجاح');
        nameController.text = "";
        detailsController.text = "";
        titleController.text = "";
        phoneController.text = "";

      }



    }
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

  alert_dialog(String text, int image_index,String title){
    String image_name;
    if(image_index == 1){
      //alert image
      image_name = "assets/tick.png";
    }
    showDialog(

        context: context,builder: (_) => AssetGiffyDialog(
      onlyOkButton: true,
      //buttonCancelText: Text('إلغاء',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16)),
      buttonOkText: Text('موافق',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16,color: Colors.white)),
      buttonOkColor: Colors.orange,
      image: Image.asset(image_name,fit: BoxFit.fitHeight),
      title: Text(title,
        style: TextStyle(
            fontSize: 18.0, fontFamily: "CustomIcons",color: Colors.orange),
      ),
      description: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "CustomIcons",fontSize: 16),
      ),
      onOkButtonPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    ) );
  }

  Widget gust_user(){
    return Scaffold(

        backgroundColor: Colors.grey,
        appBar: AppBar(

          backgroundColor: Colors.deepOrange,

          title: Text(
            "أضف طلب",
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0
              ,      fontFamily: "CustomIcons",),
          ),
          actions: <Widget>[

          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Container(
              //alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
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
                        "عذراً، يجب أن تسجل دخولك حتى تتمكن من إضافة طلب.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0
                          ,      fontFamily: "CustomIcons",),textAlign: TextAlign.center,textDirection: TextDirection.rtl,
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      RaisedButton(
                          color: Colors.deepOrange,
                          padding: EdgeInsets.all(15),
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: new Text("تسجيل الدخول",style: TextStyle(fontSize: 18,fontFamily: "CustomIcons",color: Colors.white,fontWeight: FontWeight.bold),),
                          elevation:5.0,
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
}