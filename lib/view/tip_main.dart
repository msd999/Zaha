import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter/material.dart';
import 'package:zaha_application/controler/databasehelper.dart';
import 'package:zaha_application/modules/Tip.dart';
import 'package:zaha_application/modules/TipCard.dart';

class TipMain extends StatefulWidget {
  final Tip tip;
  TipMain({this.tip});

  @override
  _TipMainState createState() => _TipMainState();
}

class _TipMainState extends State<TipMain> {
  DatabaseHelper dbHelper = new DatabaseHelper();
  List<TipCard> _tipCards = [];

  _cardWidget(TipCard tipCard) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.network(
                  "https://zaha-app.com/assets/img/tips/" +
                      tipCard.image.toString(),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    tipCard.title,
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

    if (widget.tip.body.contains('card_list')) {
      setState(() {
        dbHelper.getTipCards(widget.tip.id).then((value) {
          setState(() {
            _tipCards = List.from(value);
          });
        });
      });
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.deepOrange,
            pinned: false,
            snap: false,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(right: 10.0),
              title: Text(
                widget.tip.title.toString(),
                style: TextStyle(
                  backgroundColor: Colors.black54.withOpacity(0.4),
                  //color: Color(0xffEBEBEB),
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  fontFamily: "CustomIcons",
                ),
              ),
              background: Image.network(
                "https://zaha-app.com/assets/img/tips/" +
                    widget.tip.image.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          !widget.tip.body.contains('card_list')
              ? SliverToBoxAdapter(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('نص المقال',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: "CustomIcons",
                          )),
                    ),
                  ),
                )
              : SliverToBoxAdapter(),
          widget.tip.body.contains('card_list')
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _cardWidget(_tipCards[index]);
                    },
                    childCount: _tipCards.length,
                  ),
                )
              : SliverFillRemaining(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          //color: Color(0xffEBEBEB),
                          child: Html(
                            data: widget.tip.body != null
                                ? widget.tip.body
                                : '<p>لا يحتوي القسم على ملف نصي<p>',
                            style: {
                              'body': Style(
                                fontSize: FontSize(16.0),
                                fontFamily: "CustomIcons",
                              )
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

//
//
// SliverFillRemaining(hasScrollBody: true,
// child: _isCardsLoading
// ? Center(
// child: new GFLoader(type: GFLoaderType.circle),
// )
// : ListView.builder(
// primary: false,
// shrinkWrap: true,
// itemCount: _tipCards.length,
// itemBuilder: (BuildContext context , int index){
// return _cardWidget(_tipCards[index]);
// },
// ),
//)
