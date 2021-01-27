import 'dart:convert';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/modules/Tip.dart';
import 'package:zaha_application/view/tip_main.dart';

class SpecializationTips extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  SpecializationTips({this.categoryId, this.categoryTitle});

  @override
  _SpecializationTipsState createState() => _SpecializationTipsState();
}

class _SpecializationTipsState extends State<SpecializationTips> {
  DatabaseHelper dbHelper = new DatabaseHelper();

  List<Tip> _tips = [];
  String _countryID;
  List _countries = [];
  bool _isResult = false;
  bool _isLoading = true;

  Future<String> getCountries() async {
    String url = "https://zaha-app.com/api/app-api/get_countries.php";
    if (Platform.isIOS) {
      url = "https://zaha-app.com/api/app-api/ios/get_countries.php";
    }
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    //print(resBody.toString());
    setState(() {
      _countries = [];
      _countries = resBody;
    });

    //print(resBody);

    return "Success";
  }

  _cardWidget(Tip tip) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (BuildContext context) => new TipMain(
                tip: tip,
              ),
            ),
          );
        },
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.network("https://zaha-app.com/assets/img/tips/" +
                    tip.image.toString()),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    tip.title,
                    style: TextStyle(
                        fontFamily: 'CustomIcons', color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        title: FittedBox(
          child: Text(
            ' نصائح حول ' + widget.categoryTitle.toString(),
            style: TextStyle(fontFamily: 'CustomIcons', color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _countries != null || _countries.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: SizedBox(
                          //width: MediaQuery.of(context).size.width/2 - 30, // for example
                          width: 150, // for example
                          child: Text(
                            "اختر دولتك",
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              //fontWeight: FontWeight.w600,
                              fontFamily: "CustomIcons",
                            ),
                          )),
                      items: _countries.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['country'],
                              style: TextStyle(
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
                          _tips = [];
                          _countryID = newVal;
                          _isResult = true;
                          _isLoading = true;

                          dbHelper
                              .getSpecTips(widget.categoryId, _countryID)
                              .then((value) {
                            setState(() {
                              _tips = List.from(value);
                              _isLoading = false;
                            });
                          });
                        });
                      },
                      value: _countryID,
                    ),
                  )
                : Center(
                    child: new GFLoader(type: GFLoaderType.circle),
                  ),
            Visibility(
                visible: _isResult,
                child: Container(
                  child: _isLoading
                  ? Center(
                    child: new GFLoader(type: GFLoaderType.circle),
                  )
                  :
                  Container(
                    child: _tips.length == 0
                        ? Center(
                      child: Text('لا يتوفر معلومات خاصة بهذه الدولة حالياً',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            //fontWeight: FontWeight.w600,
                            fontFamily: "CustomIcons",
                          ),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: StaggeredGridView.countBuilder(
                        itemCount: _tips.length,
                        crossAxisCount: 4,
                        itemBuilder: (BuildContext context, int index) =>
                            _cardWidget(_tips[index]),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(2),
                        shrinkWrap: true,
                        primary:
                        false, // disable this widget of being the primary responsible scrolling widget
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
