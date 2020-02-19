import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonDetail extends StatefulWidget {
  final _id;

  PersonDetail(this._id);

  @override
  State createState() {
    return _PersonDetail(_id);
  }
}

class _PersonDetail extends State<PersonDetail> {
  final _id;

  _PersonDetail(this._id);

  ScrollController _scrollController;
  bool hasDisplayed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initControllerState();
  }

  initControllerState() {
    _scrollController.addListener(() {
      print(_scrollController.offset);
      if (!hasDisplayed && _scrollController.offset > 200) {
        hasDisplayed = true;
        setState(() {});
      } else if (hasDisplayed && _scrollController.offset < 200) {
        hasDisplayed = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 34, 52),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
      titleSpacing:0,
//            bottom: PreferredSize(
//              preferredSize: Size(20.0, 40.0),
//              child: Text(''),
//            ),
                leading: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: IconButton(
                    iconSize: 30,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: <Widget>[
                  hasDisplayed
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0, right: 15),
                          child: ClipRRect(
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(40.0)),
                            child: FadeInImage(
                              width: 50,
                              height: 50,
                              image: NetworkImage(
                                  "https://api.jikipedia.com/upload/bd6a29fa1b5cb48d6dd93ded3f8ba864_75.png"),
                              placeholder: AssetImage(
                                'assets/images/unknown-avatar.jpg',
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  hasDisplayed
                      ? Padding(
                          padding: const EdgeInsets.only(top: 0, right: 0),
                          child: Container(
                            height: 10,
                            width: 70,
                            margin:
                                EdgeInsets.only(top: 12,bottom: 12),
                            decoration: new BoxDecoration(
                              color: Color.fromARGB(255, 0, 123, 181),
                              border:
                                  Border.all(color: Colors.black, width: 0.0),
                              borderRadius: new BorderRadius.all(
                                  Radius.circular(40)),
                            ),
                            child: Center(
                            child: Text(
                                'View AR',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            ),
    ),
                          ))
                      : SizedBox.shrink(),
                  hasDisplayed
                      ? Padding(
                      padding: const EdgeInsets.only(top: 0, right: 10),
                      child: IconButton(
                        iconSize: 35,
                        onPressed: (){},
                        icon: Icon(
                          Icons.star_border
                        ),
                      )
                  )
                      : SizedBox.shrink()
                ],
                title: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(
                        'https://img.huimin111.com/uploads/201911/28/13/mlayu5u5t3g.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )),
              ),
          SliverFillRemaining(
              child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[],
              )
            ],
          ))
        ],
      ),
    );
  }
}
