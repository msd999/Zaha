import 'dart:convert';
import 'dart:io';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/TextStyles.dart';
import 'package:zaha_application/style/consts.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

class feedbacks extends StatefulWidget {
  @override
  feedbacksState createState() => feedbacksState();
}

class feedbacksState extends State<feedbacks> {

  var is_loading = true;
  int lsubmit_btn_child_index = 0;
  var gust = false;
  List countries_list = List(); //edited line
  String _mycountrySelection ;
  final com_aboutController = TextEditingController();

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

  void initState() {
    super.initState();
    check_if_gust();
    getCountries();
    databaseHelper.get_feedbacks().whenComplete(() {

      setState(() {
        is_loading = false;
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kzaha,
        appBar: AppBar(

          backgroundColor: Colors.deepOrange,

          title: Text(
            "آراء المستخدمين",
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0
              , fontFamily: "CustomIcons",),
          ),
          actions: <Widget>[
          ],
        ),
        body:Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              gust ? Container(): Container(

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
                                    "أضف رأيك بالتطبيق",
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "CustomIcons",
                                    ),
                                  ),
                                ),






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

                                    });
                                  },
                                  value: _mycountrySelection,

                                ):Center(child: new GFLoader(type:GFLoaderType.circle)):Center(child: new GFLoader(type:GFLoaderType.circle)),


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
                                      hintText: "أدخل رأيك"),
                                ),


                                SizedBox(
                                  height: 10,
                                ),

                                InkWell(onTap:(){ } , child: Container(
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
              ),

              Expanded(
                child:  is_loading
                    ? new Center(child: new GFLoader(type:GFLoaderType.circle),)
                    : new BikeListItem(list1: databaseHelper.feedbacks_list),)

            ],
          ),
        )

    );

  }

  submite_button_child() {
    if (lsubmit_btn_child_index == 0) {
      return Text(
        'أرسل ',
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

  send_order() async{
    if(com_aboutController.text == "" || com_aboutController.text == null){
      _showDialog("يرجى إدخال رأيك");
      return;
    }else if(_mycountrySelection == "" || _mycountrySelection == null ){
      _showDialog("يرجى إدخال تفاصيل الطلب");
      return;
    }else{

      databaseHelper.send_feedback(com_aboutController.text,_mycountrySelection);
      if (databaseHelper.send_order_status == true){
        _showDialog(databaseHelper.msg);
      }else{
        alert_dialog('تم ارسال رأيك بنجاح، سيتم نشره بعد المراجعة.',1,'تم بنجاح');
        com_aboutController.text = "";

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

}

class BikeListItem extends StatelessWidget {

  List list1;

  BikeListItem({this.list1});


  @override
  Widget build(BuildContext context) {

    if(list1.length > 0){


      return new ListView.builder(
          shrinkWrap: true,
          itemCount:list1.length,
          itemBuilder: (context,i){
            return new Container(

              padding: const EdgeInsets.all(10.0),
              child: new GestureDetector(
                onTap: (){
                  //databaseHelper.registervisit("${list1[i]['cid']}");
                  /*Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new CourseInfoScreen (list:list1 , index:i,)),

              );*/

                  /*Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new CompanyDetailPagee(id:list1[i]['cid'] , logo:list1[i]['logo'],
                        name: list1[i]['cname'],typoe: list1[i]['typoe'],adress: list1[i]['adress'],phone: list1[i]['phone'],
                        email: list1[i]['email'],whatsup: list1[i]['whatsup'],details: list1[i]['details'],mobilephone: list1[i]['mobilephone'],) ),

                );*/
                },child: InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: (){

                },
                child:

                GFCard(
                  boxFit: BoxFit.cover,
                  color: const Color(0xffffffff),
                  title: GFListTile(
                    avatar: GFAvatar(
                      backgroundImage: AssetImage('assets/img/avatar.png'),
                    ),
                    title: Text(list1[i]["name"],style: TextStyle(color: Colors.orange,fontSize: 18.0,
                      fontFamily: "CustomIcons",),),
                    subTitle: Text(list1[i]["country"],style: TextStyle(color: Colors.black,fontSize: 16.0,
                      fontFamily: "CustomIcons",),),
                  ),
                  content: Text(list1[i]["feedback"],textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black,fontSize: 16.0,
                      fontFamily: "CustomIcons",),),

                ),

              ),

              )




              ,);
          });

    }else{
      return Text('لا يوجد آراء',style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold, fontSize: 20.0
        ,      fontFamily: "CustomIcons",),
        softWrap: true,
      );
    }

  }




}
