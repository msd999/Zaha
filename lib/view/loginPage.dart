import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:giffy_dialog/src/base_dialog.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/Widget/bezierContainer.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:email_validator/email_validator.dart';

DatabaseHelper _databaseHelper= new DatabaseHelper();


//login with google start
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String uid;


Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;
  uid = user.uid;

  // Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  if (uid != null){
    _databaseHelper.registerG(name, email, uid);
  }

  return 'signInWithGoogle succeeded: $user';
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}
//login with google end

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool formvisible;
  int _formsIndex;
  bool is_click = false;

  int form = 0;
  _Guestlog() async {
    setState(() async {

      final prefs = await SharedPreferences.getInstance();
      final key = 'token';
      final value = "0";
      prefs.setString(key, value);

      Navigator.pushReplacementNamed(context, '/GroceryHomePage');


    }
    );
  }

  _check(){
    _databaseHelper.checklogin().whenComplete(() {
      if (_databaseHelper.status==false) {


        Navigator.pushReplacementNamed(context, '/GroceryHomePage');
      }
    });}

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;
    if(value != '0'){
      Navigator.pushReplacementNamed(context, '/GroceryHomePage');
    }
  }

  //login with facebook start
  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
    await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult
                .accessToken.token}');

        var profile = json.decode(graphResponse.body);
        //print('data : ${profile}');
        print('fbid : ${profile["id"]}');
        print('name : ${profile["name"]}');
        print('email : ${profile["email"]}');

        _databaseHelper.registerFB(profile["name"].toString(),profile["email"].toString(),profile["id"].toString()).whenComplete(() {
          if (_databaseHelper.fb_status == true){
            Navigator.pushReplacementNamed(context, '/GroceryHomePage');
          }else{
            print ('error');
          }
        });

        /*if(result == "error"){
          print('error');
        }else{
          print (result.toString());
        }*/
        onLoginStatusChanged(true);
        break;
    }
  }

  bool isLoggedIn = false;
  var profileData;

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  //login with facebook end

  @override
  initState() {
    super.initState();
    // read();
    _check();
    if(Platform.isIOS){                                                      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
    formvisible=false;
    _formsIndex=1;
  }

  appleLogIn() async {
    //print('dd');
    if(await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.email);//All the required credentials
          print(result.credential.fullName.givenName);//All the required credentials
          print(result.credential.fullName.familyName);//All the required credentials
          print(result.credential.authorizationCode);
          String fullname ="${result.credential.fullName.givenName} ${result.credential.fullName.familyName}";
          _databaseHelper.registerApple(fullname.toString(),result.credential.email.toString(),result.credential.authorizationCode.toString()).whenComplete(() {
            if (_databaseHelper.apple_status == true){
              Navigator.pushReplacementNamed(context, '/GroceryHomePage');
            }else{
              print ('error');
            }
          });
          //All the required credentials
          break;//All the required credentials
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white70,
                thickness: 1,
              ),
            ),
          ),
          Text('أو',style: TextStyle(
              color: Colors.white,
              fontFamily: "CustomIcons",
              fontSize: 18,
              fontWeight: FontWeight.w400)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Colors.white70,
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return InkWell(onTap: initiateFacebookLogin, child: Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),

      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Icon(FontAwesomeIcons.facebook,color: Colors.white,),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text(' الإستمرار بإستخدام فيسبوك',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "CustomIcons",
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    ),
    );
  }
  Widget _appleButton() {
    return InkWell( onTap: appleLogIn, child: Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Icon(FontAwesomeIcons.apple,color: Colors.black,),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text(' الإستمرار بإستخدام أبل',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _googleButton() {
    return InkWell( onTap: google_button_tap,
        child: Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child:Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Icon(FontAwesomeIcons.google,color: Colors.red,),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
                child: Text('متابعة بواسطة جوجل',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "CustomIcons",
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
      )
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,builder: (_) => AssetGiffyDialog(
          buttonCancelText: Text('إلغاء',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16,color: Colors.white)),
            buttonOkText: Text('موافق',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16,color: Colors.white)),
            buttonOkColor: Colors.orange,
          image: Image.asset("assets/support.png",fit: BoxFit.cover),
          title: Text('خدمة سعادة المتعاملين',
            style: TextStyle(
                fontSize: 18.0, fontFamily: "CustomIcons",color: Colors.orange),
          ),
          description: Text('هل تواجه أي مشاكل في استخدام التطبيق؟ نحن هنا لمساعدتك، فقط انقر على زر موافق للتحدث مع موظف الدعم الفني عبر واتس أب.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "CustomIcons",fontSize: 16),
          ),
          onOkButtonPressed: () {
            FlutterOpenWhatsapp.sendSingleMessage("+963940665994", "هل يمكنك مساعدتي");
            Navigator.pop(context);
            },
        ) );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'هل تواجه مشاكل؟ ',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,color: Colors.white,fontFamily: "CustomIcons",),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'تكلم مع الدعم الفني',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontFamily: "CustomIcons",
                  fontWeight: FontWeight.w600),
            ),



          ],
        ),
      ),
    );
  }

  Widget _gust() {
    return InkWell(
      onTap: () {
        setState(() async {

          final prefs = await SharedPreferences.getInstance();
          final key = 'token';
          final value = "0";
          prefs.setString(key, value);

          Navigator.pushReplacementNamed(context, '/GroceryHomePage');


        }
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'التسجيل لاحقاً',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontFamily: "CustomIcons",
                  fontWeight: FontWeight.w600),
            ),


          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Z',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'AH',
              style: TextStyle(color: Colors.indigo, fontSize: 45),
            ),
            TextSpan(
              text: 'A',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 45),
            ),
          ]),
    );
  }

  alert_dialog(String text, int image_index,String title){
    String image_name;
    if(image_index == 1){
      //alert image
      image_name = "assets/alert.png";
    }
    showDialog(

        context: context,builder: (_) => AssetGiffyDialog(
      onlyOkButton: true,
      buttonCancelText: Text('إلغاء',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16)),
      buttonOkText: Text('موافق',style:TextStyle(fontFamily: "CustomIcons",fontSize: 16,color: Colors.white)),
      buttonOkColor: Colors.orange,
      image: Image.asset(image_name,fit: BoxFit.cover),
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
      },
    ) );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            /*image: DecorationImage(
              image: AssetImage("assets/word.png"),
              fit: BoxFit.fill,
            ),*/

              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff3a4d66),Color(0xff192941)]
              )

          ),
      height: height,
      child: Stack(
        children: <Widget>[
          /*Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),*/
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .1),
                  //_title(),
                  Image.asset("assets/zaha_logo.png") ,
                  SizedBox(height: 40),
                  //_emailPasswordWidget(),
                  //SizedBox(height: 15),

                  choose_form(),


                  SizedBox(height: 20),
                  _divider(),
                  SizedBox(height: 20),
                  _facebookButton(),
                  SizedBox(height: 20),
                  android_or_ios(),
                  SizedBox(height: 20),
                  _gust(),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          //Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }

  android_or_ios(){
    if(Platform.isIOS){
      return _appleButton();
    }else if(Platform.isAndroid){
      return _googleButton();
    }
  }

  google_button_tap(){

      signInWithGoogle().whenComplete(() {
        //Navigator.pushReplacementNamed(context, '/GroceryHomePage');
        print(name);
        print(email);
        print(imageUrl);
        print(uid);

        if (uid != null){
          Navigator.pushReplacementNamed(context, '/GroceryHomePage');
        }
      });
  }



  ///////////////////sign in form start/////////////////////

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  Widget _emailField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "CustomIcons"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                    hintText: "الايميل",

                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.white,fontFamily: "CustomIcons"),

                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }

  Widget _passwordField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[

          TextField(
            controller: _passwordController,
              style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "CustomIcons"),
              obscureText: true,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,

              decoration: InputDecoration(

                  hintText: "كلمة المرور",

                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.white,fontFamily: "CustomIcons"),

                  prefixIcon: const Icon(
                    Icons.security,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(onTap:(){login_btn_tap(); } , child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: login_button_child(),
    ),
    );
  }

  int login_btn_child_index = 0;
  login_button_child(){
    if (login_btn_child_index == 0){
      return Text(
        'تسجيل الدخول',
        style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "CustomIcons"),
      );
    } else{
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  login_btn_tap(){
    if(login_btn_child_index == 0){
      setState(() {
        login_btn_child_index = 1;
      });
      if(EmailValidator.validate(_emailController.text.trim()) == false){
        alert_dialog('يرجى كتابة الإيميل بشكل صحيح',1,'بيانات ناقصة');
        setState(() {
          login_btn_child_index = 0;
        });
      }else if(_passwordController.text.isEmpty){
        alert_dialog('يرجى كتابة كلمةالمرور',1,'بيانات ناقصة');
        setState(() {
          login_btn_child_index = 0;
        });
      }else{
        _databaseHelper.loginData(_emailController.text.trim().toLowerCase(),
            _passwordController.text).whenComplete(() {
          if (_databaseHelper.status) {
            alert_dialog('تأكد من صحة الإيميل أو كلمة المرور',1,'بيانات خاطئة');
            setState(() {
              login_btn_child_index = 0;
            });
          } else {
            Navigator.pushReplacementNamed(context, '/GroceryHomePage');

          }
        });
      }
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        setState(() {
          form = 0;
        });
      },
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 0, top: 0, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('عودة',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget singin_form(){
    return Column(
      children: <Widget>[
        _backButton(),
        _emailField("Email id"),
        _passwordField("Password",),
        SizedBox(height: 15),
        _submitButton(),
        /*SizedBox(height: 10,),
        InkWell(onTap: (){},child: Text('هل نسيت كلمة المرور؟',
    style: TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500,color: Colors.orange,fontFamily: "CustomIcons")),
    ),*/
      ],
    );
  }

  ///////////////////sign in form end///////////////////////

  //////////////////signup form start///////////////////////
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();

  Widget _nameField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "CustomIcons"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  hintText: "الاسم الكامل",

                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.white,fontFamily: "CustomIcons"),

                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }
  Widget _phoneField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "CustomIcons"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,

              decoration: InputDecoration(
                  hintText: "رقم الهاتف",

                  hintStyle: TextStyle(fontSize: 14.0, color: Colors.white,fontFamily: "CustomIcons"),

                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xff51637b),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submit_signup_Button() {
    return InkWell(onTap:(){signup_btn_tap(); } , child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: signup_button_child(),
    ),
    );
  }

  int signup_btn_child_index = 0;
  signup_button_child(){
    if (signup_btn_child_index == 0){
      return Text(
        'إنشاء حساب جديد',
        style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "CustomIcons"),
      );
    } else{
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  signup_btn_tap(){
    if(signup_btn_child_index == 0){
      setState(() {
        signup_btn_child_index = 1;
      });
      if(EmailValidator.validate(_emailController.text.trim()) == false){
        alert_dialog('يرجى كتابة الإيميل بشكل صحيح',1,'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      }else if(_passwordController.text.isEmpty){
        alert_dialog('يرجى كتابة كلمةالمرور',1,'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      }else if(_passwordController.text.length < 6){
        alert_dialog('كلمة المرور قصيرة جداً',1,'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      }else if(_nameController.text.isEmpty || _nameController.text.length <6){
        alert_dialog('يرجى كتابة الاسم الكامل',1,'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      }else if(_phoneController.text.isEmpty || _phoneController.text.length <6){
        alert_dialog('يرجى كتابة رقم الهاتف',1,'بيانات ناقصة');
        setState(() {
          signup_btn_child_index = 0;
        });
      }else{
        _databaseHelper.registerData(_nameController.text.trim(),
            _emailController.text.trim().toLowerCase(),
            _passwordController.text.trim(), _phoneController.text.trim())
            .whenComplete(() {
          if (_databaseHelper.status) {
           alert_dialog(_databaseHelper.msg,1,'رسالة خطأ');
           signup_btn_child_index = 0;
          } else {
            setState(() {
              form = 3;
            });
          }
        });
      }
    }
  }

  Widget singup_form(){
    return Column(
      children: <Widget>[
        _backButton(),
        _nameField("Email id"),
        _phoneField("Email id"),
        _emailField("Email id"),
        _passwordField("Password",),
        SizedBox(height: 15),
        _submit_signup_Button(),

      ],
    );
  }
  //////////////////signup form end/////////////////////////

  ////////////////// pin form start/////////////////////////
  final TextEditingController _pinController = new TextEditingController();
  Widget PinField(){
    return PinCodeTextField(
      controller: _pinController,
      highlight: true,
      highlightColor: Colors.orange,
      defaultBorderColor: Colors.white,
      hasTextBorderColor: Colors.white,
      pinTextStyle: TextStyle(fontSize: 18.0,color: Colors.white),
      keyboardType: TextInputType.number,
    );
  }

  Widget _submit_pin_Button() {
    return InkWell(onTap:(){pin_btn_tap(); } , child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],*/
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: pin_button_child(),
    ),
    );
  }

  int pin_btn_child_index = 0;
  pin_button_child(){
    if (pin_btn_child_index == 0){
      return Text(
        'تحقق',
        style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "CustomIcons"),
      );
    } else{
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  pin_btn_tap(){
    if(pin_btn_child_index == 0){
      setState(() {
        pin_btn_child_index = 1;
      });
       if(_pinController.text.isEmpty || _pinController.text.length <4){
        alert_dialog('يرجى كتابة رمز التحقق',1,'بيانات ناقصة');
        setState(() {
          pin_btn_child_index = 0;
        });
      }else{
         _databaseHelper.vert(_emailController.text.trim(),
             _pinController.text.trim()).whenComplete(() {
          if (_databaseHelper.status) {
            alert_dialog('رمز التحقق خاطئ.',1,'رسالة خطأ');
            setState(() {
              pin_btn_child_index = 0;
            });
          } else {
            Navigator.pushReplacementNamed(context, '/GroceryHomePage');
          }
        });
      }
    }
  }

  Widget pin_form(){
    return Column(
      children: <Widget>[
        Text('''أدخل كود التحقق الذي أرسلناه إلى ايميلك ${_emailController.text}''',
          style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: "CustomIcons"),
        textDirection: TextDirection.rtl,textAlign: TextAlign.center,),
        SizedBox(height: 25),
        PinField(),
        SizedBox(height: 25),
        _submit_pin_Button(),

      ],
    );
  }
  ////////////////// pin form end/////////////////////////

  ///////////////////welcome form start/////////////////////

  Widget _signupButton(String text) {
    return InkWell(onTap: ()=>{ setState(() {form = 2;})},child:Container(
      //width: MediaQuery.of(context).size.width/1.9,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.only(right: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            /*BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)*/
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: Text(
        text,

        style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "CustomIcons"),
      ),
    ),
    );
  }
  Widget _loginButton(String text) {
    return InkWell(onTap: ()=>{ setState(() {form = 1;})},child: Container(
      //width: MediaQuery.of(context).size.width/1.9,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.only(left: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              //offset: Offset(1, 1),
              //blurRadius: 2,
              //spreadRadius: 2,
            )
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff3a4d66), Color(0xff192941)])),
      child: Text(
        text,

        style: TextStyle(fontSize: 20, color: Colors.white,fontFamily: "CustomIcons"),
      ),
    ),
    );
  }


  Widget welcome_form(){
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(child:_loginButton('تسجيل دخول')),
          Expanded(child:_signupButton('حساب جديد')),

        ],
      ),
    );
  }

  //////////////////welcome form end///////////////////////


  Widget choose_form(){
    if(form == 0){
      return welcome_form();
    }else if(form == 1){
      return singin_form();
    }else if(form == 2){
      return singup_form();
    }else if(form == 3){
      return pin_form();
    }
  }
}
