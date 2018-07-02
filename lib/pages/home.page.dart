import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inka_msa/pages/home.list.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/pages/notif.page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AssetImage _logoImage = AssetImage('assets/images/msa.png');
  AssetImage background = AssetImage('assets/images/home.jpg');
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool launch = false;

  void simpanMessage (AppBloc appBloc, message) {
    print('type data');
    print(appBloc.auth.deviceState.attributes['notif'].runtimeType.toString());
    if (appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<Map<String, String>>' || appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<dynamic>' || appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<Map<String, dynamic>>'){
      appBloc.auth.deviceState.attributes['notif'].insert(0,
        {
          'title': message['title'],
          'messsage': message['message'],
          'time': message['time'],
          'detailUrl': message['detailUrl'],
          'status': false
        }
      );
    }
    else{
      appBloc.auth.deviceState.attributes['notif'] = [
        {
          'title': message['title'],
          'messsage': message['message'],
          'time': message['time'],
          'detailUrl': message['detailUrl'],
          'status': false
        }
      ];
    }
    appBloc.auth.deviceState.save();
    appBloc.auth.updateAuthStatus();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("New Message"),
//        ));
        simpanMessage(appBloc, message);
        print('');
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) {
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("New Message Launc"),
//        ));

        if(appBloc.isLoadedLaunch == false){
          appBloc.isLoadedLaunch = true;
          simpanMessage(appBloc, message);
        }
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("New Message Resume"),
//        ));
        simpanMessage(appBloc, message);
//        _navigateToItemDetail(message);
      },
    );
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
            image: background,
            fit: BoxFit.cover,
          ),
        ),
        child: new SafeArea(
          child: new CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                new SliverAppBar(
                  expandedHeight: 250.0,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: new FlexibleSpaceBar(
                    background: new Container(
                      margin: const EdgeInsets.only(
                        top: 24.0,
                        right: 24.0,
                        left: 24.0,
                        bottom: 10.0,
                      ),
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      decoration: new BoxDecoration(
                        color: new Color(0xA0EEEEEE),
                      ),
                      child: Center(
                        child: Image(
                          image: _logoImage,
                          width: 300.0,
                        ),
                      ),
                    ),
                  )
                ),
                StreamBuilder(
                    stream: appBloc.auth.status,
                    builder: (context, snapshot) {
                      List<dynamic> childs = [];
                      if (appBloc.auth.deviceState.notif.runtimeType.toString() != 'Null'){
                        childs = appBloc.auth.deviceState.notif;
                      }
                      print('update anak');
                      print(appBloc.auth.deviceState.notif.runtimeType);
                      print(childs);
                      return
                        new Theme(
                            data: Theme.of(context).copyWith(primaryColor: Colors.white),
                            child: SliverList(
                                delegate:
                                new SliverChildBuilderDelegate(
                                      (context, index) =>
                                      Dismissible(
                                        // Each Dismissible must contain a Key. Keys allow Flutter to
                                        // uniquely identify Widgets.
                                          key: new ObjectKey(childs[index]),
                                          // We also need to provide a function that will tell our app
                                          // what to do after an item has been swiped away.
                                          onDismissed: (direction) {
                                            appBloc.auth.deviceState.attributes['notif'].removeAt(index);
                                            appBloc.auth.deviceState.save();
                                            appBloc.auth.updateAuthStatus();
                                          },
                                          // Show a red background as the item is swiped away
                                          background: Container(color: Colors.transparent),
                                          child: new InkWell(
                                            // When the child is tapped, show a snackbar
                                            onTap: () {
                                              appBloc.auth.deviceState.attributes['notif'][index]['status'] = true;
                                              appBloc.auth.deviceState.save();
                                              Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
                                                builder: (BuildContext context) => new NotifPage.edit(childs[index]['detailUrl']),
                                                fullscreenDialog: true,
                                              ));
                                            },
                                            // Our Custom Button!
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: 12.0,
                                                right: 24.0,
                                                left: 24.0,
                                                bottom: 10.0,
                                              ),
                                              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                                              decoration: new BoxDecoration(
                                                color: new Color(0xA0EEEEEE),
                                                border: Border(left: BorderSide(color: childs[index]['status'].toString() == 'false' ? Colors.red: Colors.black, width: 3.0))
                                              ),
                                              child: new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      new Text(childs[index]['title'].toString(),style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                                                    ],
                                                  ),
                                                  new Padding(padding: const EdgeInsets.only(top: 10.0)),
                                                  new Text(childs[index]['time'].toString()),
                                                  new Padding(padding: const EdgeInsets.only(top: 10.0)),
                                                  new Text(childs[index]['messsage'].toString()),
                                                ],
                                              ),
                                            ),
                                          )
                                          ),
                                  childCount: childs.length,
                                )
                        )
                      );
                    }
                ),
              ]
          )
        )
      ),
//      floatingActionButton: new FloatingActionButton(
//          elevation: 0.0,
//          child: new Icon(Icons.check),
//          backgroundColor: new Color(0xFFE57373),
//          onPressed: (){
//            if (appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<Map<String, String>>' || appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<dynamic>'){
//              appBloc.auth.deviceState.attributes['notif'].insert(0,
//                {
//                  'title': 'asd',
//                  'messsage': 'asdasdsadsd',
//                  'tanggal': '2018-01-01'
//                });
//            }
//            else{
//              appBloc.auth.deviceState.attributes['notif'] = [
//                {
//                  'title': 'asd',
//                  'messsage': 'asdasdsadsd',
//                  'tanggal': '2018-01-01'
//                }
//              ];
//            }
//            appBloc.auth.deviceState.save();
//            appBloc.auth.updateAuthStatus();
//          }
//      ),
    );
  }
}

class DismissDialogAction {
}
