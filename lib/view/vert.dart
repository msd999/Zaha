import 'package:flutter/material.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/style/consts.dart';

DatabaseHelper _databaseHelper=  new DatabaseHelper();
class pincode extends StatefulWidget {


  pincode(this.email);
  String email;
  @override
  _pincodestate createState() => _pincodestate();
}
class _pincodestate extends State<pincode> {
  final TextEditingController _passwordController1 = new TextEditingController();
  _onPressed() {
    setState(() {
      if (
          _passwordController1.text
              .trim()
              .isNotEmpty) {
        _databaseHelper.vert(widget.email,
            _passwordController1.text.trim()).whenComplete(() {
          if (_databaseHelper.status) {
            _showDialog();
          } else {
            Navigator.pushReplacementNamed(context, '/GroceryHomePage');
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  kzaha,
                  kzaha
                ]
            )
        ),
        child: Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 40.0,bottom: 20.0),
                height: 80,
                child: Image.asset("assets/img/logo.png")),
            Text(" قم بتأكيد ايميلك".toUpperCase(), style: TextStyle(
                color: Colors.white70,
                fontSize: 24.0,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: Container(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomRight: Radius.circular(10.0)
                        )
                    ),
                    child: Icon(Icons.lock, color: kzaha,)),
                hintText: "ادحل رمز التاكيد",
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              controller: _passwordController1,
            ),
          //  SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.white,
                textColor: kzaha,
                padding: const EdgeInsets.all(20.0),
                child: Text("تاكيد".toUpperCase()),
                onPressed: _onPressed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
              ),
            ),

          ],
        ),
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
                  'Close',
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