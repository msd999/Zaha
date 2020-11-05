import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/loginPage.dart';

DatabaseHelper databaseHelper = new DatabaseHelper();

class profile extends StatefulWidget {
  @override
  profileState createState() => profileState();

}

class profileState extends State<profile>{

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
    // TODO: implement build
    return gust ? gust_user()
        :Scaffold(
      appBar: AppBar(title: Text("حسابي"),        backgroundColor: Colors.deepOrange,
      ),
        backgroundColor: korange,
        body: SafeArea(

          child: FutureBuilder<List>(
    future: databaseHelper.getprofile(),
    builder: (context ,snapshot){
    if(snapshot.hasError) print(snapshot.error);
    return snapshot.hasData
    ? new profiles(list: snapshot.data)
        : new Center(child: new CircularProgressIndicator(),);
    }
        ),),);
  }

  Widget gust_user(){
    return Scaffold(

        backgroundColor: Colors.grey,
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
                    "هذه الصفحة مخصصة للأعضاء فقط، من فضلك قم بتسجيل الدخول.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,

                    ),textAlign: TextAlign.center,textDirection: TextDirection.rtl,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  RaisedButton(
                      color: Colors.deepOrange,
                      padding: EdgeInsets.all(15),
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: new Text("تسجيل الدخول",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
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
class profiles extends StatelessWidget{
  List list;
  profiles({this.list});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      shrinkWrap: true,
      itemCount:list.length,
      itemBuilder: (context,i){
        return GestureDetector(
            onTap: (){},


          child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 330,
            color: Color.fromRGBO(48, 57, 79,1.0),
          ),
          Positioned(
            top: 10,
            right:30,
            child: Icon(
              Icons.settings,
              color:Colors.white
            ),
          ),

          Column(
            children: <Widget>[
              Container(
                  height: 90,
                  margin: EdgeInsets.only(top: 60),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/img/profile.png',width: 150.0,),
                  )
              ),
              Padding(
                padding: EdgeInsets.all(4),
              ),
              Text(
                list[i]["username"],
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                   fontFamily: "CustomIcons",
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),


              UserInfo(list[i]['email'],list[i]['phone'])
            ],
          )
        ],
      ),);

});
  }}

class UserInfo extends StatelessWidget {
  UserInfo(this.email,this.phone, );
  String email;
 String phone;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "User Information",
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "CustomIcons",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Email"),
                            subtitle: Text(email),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Phone"),
                            subtitle: Text(phone),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)
                            )
                            ,
                            color: kzaha,
                            textColor: Colors.white,
                            child: Text('تسجيل خروج',style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: "CustomIcons",
                            ),),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                            onPressed: ()async{
                              final prefs = await SharedPreferences.getInstance();
                              final key = 'token';
                              final value = "0";
                              prefs.setString(key, value);
                              Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) => new LoginPage()));},
                          ),
                        ],

                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
