import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/consts.dart';
import 'package:zaha_application/view/newhome.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:zaha_application/view/vert.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;



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


DatabaseHelper _databaseHelper= new DatabaseHelper();
class LoginPage extends StatefulWidget{

  LoginPage({Key key , this.title}) : super(key : key);
  final String title;

  @override
  LoginPageState  createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool formvisible;
  int _formsIndex;
  bool is_click = false;
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


  String _contactText;

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

  appleLogIn( ) async {
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(

          image: DecorationImage(
            image: AssetImage(
                'assets/img/bg.jpg'
            ),
            fit: BoxFit.cover,
          ),

        ),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black45,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                      height: kToolbarHeight+40
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Image.asset("assets/img/logo1.png",width:130),
                      ],

                    ),
                  ),
                  const SizedBox(
                      height: 40.0
                  ),
                  Row(
                    children: <Widget>[

                      const SizedBox(
                          width: 10.0
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: korange,
                          textColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),

                          ),
                          child: Text(
                            "لدي حساب" ,
                            style: TextStyle(
                                fontFamily: "CustomIcons"
                            ),

                          ),
                          onPressed: (){
                            setState(() {
                              formvisible=true;
                              _formsIndex=1;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                          width: 10.0
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.grey.shade700,
                          textColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),

                          ),
                          child: Text(
                            "مستخدم جديد" ,
                            style: TextStyle(
                                fontFamily: "CustomIcons"
                            ),


                          ),
                          onPressed: (){
                            setState(() {
                              formvisible=true;
                              _formsIndex=2;
                            });
                          },
                        ),
                      ),

                      const SizedBox(
                          width: 10.0
                      ),


                    ],
                  ),
                  const SizedBox(height: 50.0,),
                  login_buttons(),

                  const SizedBox(height: 20,),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: (!formvisible)?null:Container(
                color: Colors.black54,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          textColor: _formsIndex==1?Colors.white:Colors.black,
                          color: _formsIndex==1?Color.fromRGBO(240, 90,43,1.0):Colors.white,
                          child: Text('لدي حساب',
                            style: TextStyle(
                                fontFamily: "CustomIcons"
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular((20.0)),

                          ),
                          onPressed: (){
                            setState(() {
                              _formsIndex=1;
                            });

                          },
                        ),

                        const SizedBox(width: 10.0,),
                        RaisedButton(

                          textColor: _formsIndex==2?Colors.white:Colors.black,
                          color: _formsIndex==2?Colors.deepOrange:Colors.white,
                          child: Text('مستخدم جديد',
                            style: TextStyle(
                                fontFamily: "CustomIcons"
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular((20.0)),

                          ),
                          onPressed: (){
                            setState(() {
                              _formsIndex=2;
                            });

                          },


                        ),

                        const SizedBox(width: 10.0,),
                        IconButton(color: Colors.white,icon: Icon(Icons.clear), onPressed:(){ setState(() {
                          formvisible=false;
                        });})

                      ],
                    ),
                    Container(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: _formsIndex==1?LoginForm():SignupForm(),
                      ),
                    )

                  ],
                ),
              ),

            )
          ],
        ),
      ),
    );
  }

  login_buttons(){
    if (Platform.isIOS){
      return Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                OutlineButton.icon(borderSide:BorderSide(
                    color: Colors.white

                ),
                  color: Colors.white70,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  icon: Icon(FontAwesomeIcons.apple),
                  label: Text("Apple"),
                  onPressed: () {
                    appleLogIn();
                  },
                ),

                const SizedBox(width: 10.0,),


                OutlineButton.icon(borderSide:BorderSide(
                    color: Colors.red

                ),
                  color: Color.fromRGBO(240, 90,43,1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  icon: Icon(FontAwesomeIcons.google),
                  label: Text("Google"),
                  onPressed: () {
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
                  },
                ),

                const SizedBox(width: 10.0,),
              ]),
          Row ( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton.icon(borderSide:BorderSide(
                    color: Colors.blue

                ),
                  color: Color.fromRGBO(240, 90,43,1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  icon: Icon(FontAwesomeIcons.facebookF),
                  label: Text("Facebook"),
                  onPressed: () => /*Navigator.of(context).push(
    new MaterialPageRoute(
    builder: (BuildContext context) => new Example()))*/
                  initiateFacebookLogin(),
                ),
                const SizedBox(width: 10.0),


                OutlineButton.icon(borderSide:BorderSide(
                    color: Colors.blueGrey

                ),
                  color: Color.fromRGBO(240, 90,43,1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  icon: Icon(Icons.exit_to_app),
                  label: Text("زيارة"),
                  onPressed:_Guestlog,),
                const SizedBox(width: 10.0),
                /*AppleSignInButton(
                          style: ButtonStyle.black,
                          type: ButtonType.continueButton,
                          onPressed: appleLogIn,
                        ),*/
              ]),
        ],
      );
    }else{
      return Row ( mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton.icon(borderSide:BorderSide(
                    color: Colors.red

                ),
                  color: Color.fromRGBO(240, 90,43,1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  icon: Icon(FontAwesomeIcons.google),
                  label: Text("Google"),
                  onPressed: () {
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
                  },
                ),

                const SizedBox(width: 10.0,),

                OutlineButton.icon(borderSide:BorderSide(
                    color: Colors.blue

                ),
                  color: Color.fromRGBO(240, 90,43,1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  icon: Icon(FontAwesomeIcons.facebookF),
                  label: Text("Facebook"),
                  onPressed: () => /*Navigator.of(context).push(
    new MaterialPageRoute(
    builder: (BuildContext context) => new Example()))*/
                  initiateFacebookLogin(),
                ),
                const SizedBox(width: 10.0),


                OutlineButton.icon(borderSide:BorderSide(
                    color: Colors.blueGrey

                ),
                  color: Color.fromRGBO(240, 90,43,1.0),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),

                  ),
                  icon: Icon(Icons.exit_to_app),
                  label: Text("زيارة"),
                  onPressed:_Guestlog,),
                const SizedBox(width: 10.0),
                /*AppleSignInButton(
                          style: ButtonStyle.black,
                          type: ButtonType.continueButton,
                          onPressed: appleLogIn,
                        ),*/
              ]);


    }

  }
}
class LoginForm extends StatefulWidget {

  const LoginForm({Key key,}) :super(key: key);

  @override
  State<StatefulWidget> createState()  => loginform();


}


class loginform extends State<LoginForm>{

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  _onPressed() {
    setState(() {
      if (_emailController.text
          .trim()
          .toLowerCase()
          .isNotEmpty &&
          _passwordController.text
              .trim()
              .isNotEmpty) {
        _databaseHelper.loginData(_emailController.text.trim().toLowerCase(),
            _passwordController.text.trim()).whenComplete(() {
          if (_databaseHelper.status) {
            _showDialog();
            var msgStatus = 'Check email or password';
          } else {
            Navigator.pushReplacementNamed(context, '/GroceryHomePage');
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container (
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(16.0),

      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            cursorColor: kzaha,

            controller: _emailController,
            decoration: InputDecoration(
              hintText: "البريد الالكتروني",
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.red),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                ),
              ),
              prefixIcon: const Icon(
                Icons.security,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "كلمة السر",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0,),
          RaisedButton(
            color: Colors.deepOrange,
            textColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text('تسجيل دخول',
              style: TextStyle(
                  fontFamily: "CustomIcons"
              ),
            ),
            onPressed: _onPressed,)
        ],
      ),
    );
  }
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Failed'),
            content: new Text('Check your email or password'),
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


}




class SignupForm extends StatefulWidget {

  const SignupForm({Key key,}) :super(key: key);

  @override
  State<StatefulWidget> createState()  => sigupform();


}


class sigupform extends State<SignupForm > {
  bool is_click;

  final TextEditingController _nameController1 = new TextEditingController();
  final TextEditingController _emailController1 = new TextEditingController();
  final TextEditingController _passwordController1 = new TextEditingController();
  final TextEditingController _phoneController1 = new TextEditingController();

  _onPressedRegister() {
    if(is_click == true){
      return;
    }

    setState(() {
      is_click = true;
      if (_emailController1.text.trim().isEmpty || _passwordController1.text.trim().isEmpty ||_nameController1.text.trim().isEmpty ||_phoneController1.text.trim().isEmpty){
        _showDialog('يرجى تعبئة جميع الحقول');
        is_click = false;
        return;
      }
      if (_emailController1.text
          .trim()
          .toLowerCase()
          .isNotEmpty &&
          _passwordController1.text
              .trim()
              .isNotEmpty) {

        _databaseHelper.registerData(_nameController1.text.trim(),
            _emailController1.text.trim().toLowerCase(),
            _passwordController1.text.trim(), _phoneController1.text.trim())
            .whenComplete(() {
          if (_databaseHelper.status) {
            _showDialog(_databaseHelper.msg);
            //var msgStatus = 'Check email or password';
          } else {
            Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new pincode(_emailController1.text.trim())));
          }
        });
      }
    });

    is_click = false;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),

      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[

          TextField(

            controller: _nameController1,
            decoration: InputDecoration(
              hintText: "الاسم الثلاثي ",
              border: OutlineInputBorder(),
              icon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: 10.0,),
          TextField(
            controller: _emailController1,
            decoration: InputDecoration(
              hintText: "البريد الالكتروني",
              border: OutlineInputBorder(),
              icon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _passwordController1,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "كلمة السر",
              border: OutlineInputBorder(),
              icon: Icon(Icons.security),
            ),
          ),
          const SizedBox(height: 10.0,),
          TextField(
            controller: _phoneController1,
            decoration: InputDecoration(

              hintText: "رقم الهاتف",
              icon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10.0,),
          RaisedButton(
            color: Colors.deepOrange,
            textColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Text("تسجيل ",
              style: TextStyle(
                  fontFamily: "CustomIcons"
              ),
            ),
            onPressed:_onPressedRegister,
          )
        ],
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




}






