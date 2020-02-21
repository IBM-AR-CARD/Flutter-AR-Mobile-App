import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/GlobalData.dart';
import 'package:flutter_app/Models/UserData.dart';
import 'package:flutter_app/Request/request.dart';

class PersonDetail extends StatefulWidget {
  UserData userData;
  changeData(userData){
    this.userData = userData;
  }
  PersonDetail(this.userData);

  @override
  State createState() {
    return _PersonDetail(userData);
  }
}

class _PersonDetail extends State<PersonDetail> {
  UserData userData;
  _PersonDetail(this.userData);
  GlobalData globalData;
  ScrollController _scrollController;
  bool hasDisplayed = false;
  bool onFavouriteRequest = false;
  @override
  void initState() {
    super.initState();
    print(userData.userName);
    globalData = GlobalData();
    _scrollController = ScrollController();
    initControllerState();
  }

  initControllerState() {
    _scrollController.addListener(() {
      print(_scrollController.offset);
      if (!hasDisplayed && _scrollController.offset > 345) {
        hasDisplayed = true;
        setState(() {});
      } else if (hasDisplayed && _scrollController.offset < 345) {
        hasDisplayed = false;
        setState(() {});
      }
    });
  }
  double _width;
  double _height;
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 34, 52),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
      titleSpacing:0,
                leading: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context,false),
                    iconSize: 30,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: listOfActions(),
                title: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                expandedHeight: 400.0,
                floating: false,
                pinned: true,
                backgroundColor:  Color.fromARGB(255, 41, 43, 66),
                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 150,
                        width: _width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                                  0.3,
                                  1
                                ],
                                colors: [
                                  Color.fromARGB(255, 69, 67, 89),
                                  Color.fromARGB(255, 55, 51, 75)
                                ])),
//                        color: Color.fromARGB(255, 41, 43, 66),
                      )
                    ),
                    Positioned(
                      top: 110,
                      left: 30,
                      child:ClipRRect(
                        borderRadius:  BorderRadius.circular(40.0),
                        child: FadeInImage(
                          width: 80,
                          height: 80,
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              userData.profile),
                          placeholder: AssetImage(
                            'assets/images/unknown-avatar.jpg',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 160,
                      right: 80,
                      child:InkWell(
                        onTap: onViewAR,
                        child: Container(
                          height: 30,
                          width: 70,
                          decoration: new BoxDecoration(
                            color: Color.fromARGB(255, 0, 123, 181),
                            borderRadius: new BorderRadius.all(
                                Radius.circular(9)),
                          ),
                          child: Center(
                            child: Text(
                              'View AR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ) ,
                      )
                    ),
                    Positioned(
                      top: 150,
                      right: 10,
                      child:IconButton(
                        iconSize: 35,
                        onPressed: (){
                          _onFavourite();
                        },
                        icon: Icon(
                          Icons.star_border,
                          color: userData.isFavourite?Colors.greenAccent:Colors.white,
                        ),
                      )
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: _width*0.85,
                        height: 190,
//                        color: Colors.cyanAccent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${userData.firstName} ${userData.lastName}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Divider(
                              height: 5,
                            ),
                            Text(
                              "@${userData.userName}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                              ),
                            ),
                            Divider(),
                            Text(
                              userData.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Divider(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              height: 40,
              color: Color.fromARGB(255, 51, 53, 77),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child:Text(
                      'My Contacts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
//                                fontWeight: FontWeight.bold
                      ),
                    ) ,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(Icons.message,
                          color: Colors.white,),
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(Icons.public,color: Colors.white,),
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(Icons.email,color: Colors.white,),
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left:_width*0.15*0.5,right:_width*0.15*0.5),
              width: _width*0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[]..addAll(getExperience())..addAll(getEducation())..add(
                  Divider(
                    height: 400,
                  )
                ),
              ),
            ) ,
          ])
        )
    ]
    )
    );
//        ),
//          SliverFillRemaining(
//            hasScrollBody: true,
//              child:Expanded(
//              child: Column(
//                  children: <Widget>,
//      ),
//    );
  }
  listOfActions(){
    return [
      hasDisplayed
          ? Padding(
        padding: const EdgeInsets.only(top: 0, right: 15),
        child: Container(
          margin:
          EdgeInsets.only(top: 8,bottom: 8),
        child: ClipRRect(
          borderRadius:  BorderRadius.circular(16.0),
            child: FadeInImage(
              width: 40,
              height: 40,
              fit: BoxFit.fill,
              image: NetworkImage(
                  userData.profile),
              placeholder: AssetImage(
                'assets/images/unknown-avatar.jpg',
              ),
            ),
          ),
        ),
      )
          : SizedBox.shrink(),
      hasDisplayed
          ? Padding(
          padding: const EdgeInsets.only(top: 0, right: 0),
          child: InkWell(
          onTap: onViewAR,
          child:Container(
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
          ) ,
          ))
          : SizedBox.shrink(),
      hasDisplayed
          ? Padding(
          padding: const EdgeInsets.only(top: 0, right: 10),
          child: IconButton(
            iconSize: 35,
            onPressed: (){
              _onFavourite();
            },
            icon: Icon(
                Icons.star_border,
              color: userData.isFavourite?Colors.greenAccent:Colors.white,
            ),
          )
      )
          : SizedBox.shrink()
    ];
  }
  List<Widget> getExperience(){
    if(userData.experience == null || userData.experience == ""){
      return [];
    }
    return [
      Divider(
        height: 20,
      ),
      Text(
        "Experience",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 45,
        ),
      ),
      Divider(
        height: 20,
      ),
      Text(
        userData.experience,
        textAlign: TextAlign.start,
//                            overflow: TextOverflow.ellipsis,
        style: TextStyle(
//                              fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      Divider(
        height: 20,
      ),
      Divider(
        color: Colors.white.withOpacity(0.3),
        thickness: 1,
        height: 20,
      ),
    ];
  }
  List<Widget> getEducation(){
    if(userData.education == null || userData.education == ""){
      return [];
    }
    return [Divider(
      height: 20,
    ),
      Text(
        "Education",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 45,
        ),
      ),
      Divider(
        height: 20,
      ),
      Text(
        userData.education,
        textAlign: TextAlign.start,
//                            overflow: TextOverflow.ellipsis,
        style: TextStyle(
//                              fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      Divider(
        height: 20,
      ),
      Divider(
        color: Colors.white.withOpacity(0.3),
        thickness: 1,
        height: 20,
      ),];
  }
  onViewAR(){
    globalData.scanData = this.userData;
    Navigator.pop(context,"pop");
  }
  _onFavourite()async{
    if(onFavouriteRequest) return;
    try{
      if(userData.isFavourite){
        final response = await RequestCards.favouriteRemove(userData.id);
        if(response.statusCode == 200){
          userData.isFavourite = false;
        }else{
          throw Exception();
        }
      }else{
        final response = await RequestCards.favouriteAdd(userData.id);
        if(response.statusCode == 200){
          userData.isFavourite = true;
        }else{
          throw Exception();
        }
      }
    }catch(err){
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Network Error"),
              content: new Text("please contact admin"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }finally{
      onFavouriteRequest = false;
      setState(() {

      });
    }
  }
}
