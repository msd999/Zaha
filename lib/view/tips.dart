import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/modules/Specialization.dart';
import 'package:zaha_application/view/specialization_tips.dart';

class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  DatabaseHelper dbHelper = new DatabaseHelper();

  List<Specialization> _specs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    dbHelper.getSpecializations().then((value) {
      setState(() {
        _specs = List.from(value);
        _isLoading = false;
      });
    });
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
            ' نصائح ',
            style: TextStyle(fontFamily: 'CustomIcons', color: Colors.white),
          ),
        ),
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: GFLoader(
                  type: GFLoaderType.circle,
                ),
              ),
            )
          : SingleChildScrollView(
              child: ResponsiveGridRow(
                children: [
                  // ignore: sdk_version_ui_as_code
                  for (var i = 0; i < _specs.length; i++)
                    ResponsiveGridCol(
                      xs: 6,
                      md: 4,
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        height: MediaQuery.of(context).size.width / 3 + 50,
                        alignment: Alignment(0, 0),
                        //color: Colors.grey,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new SpecializationTips(
                                  categoryTitle: _specs[i].name.toString(),
                                  categoryId: _specs[i].id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    shape: BoxShape.rectangle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          "https://zaha-app.com/dash/catimg/" +
                                              _specs[i].image),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              FittedBox(
                                child: Text(
                                  _specs[i].name.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'CustomIcons',
                                  ),
                                ),
                              )
                            ],
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
