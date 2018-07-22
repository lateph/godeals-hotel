import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inka_msa/config/style.config.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/helpers/rating.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AssetImage _logoImage = AssetImage('assets/images/hotel.jpg');
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
        decoration: BoxDecoration(
          color: Colors.blueGrey[50]
        ),
        child: new CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 185.0,
              elevation: 0.0,
              pinned: true,
              title: const Text('Godeals', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26.0),),
              floating: false,
              flexibleSpace: new FlexibleSpaceBar(
                background: new Container(
                  margin: const EdgeInsets.only(
                    top: 50.0,
                    right: 24.0,
                    left: 24.0,
                    bottom: 10.0,
                  ),
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildButtonHeader(context, Icons.local_offer, 'Active Bid', 20),
                        _buildButtonHeader(context, Icons.event_available, 'Deal', 0),
                        _buildButtonHeader(context, Icons.receipt, 'Invoice', 0),
                      ],
                    ),
                  ),
                ),
              )
            ),
            new SliverList(
                delegate: SliverChildListDelegate([
                  new Container(
                    child: new Text('Sugested Opportunity', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey, fontSize: 20.0),),
                    margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  )
                ])
            ),
            new StreamBuilder(
              stream: appBloc.auth.status,
              builder: (context, snapshot) {
                List<dynamic> childs = [1,2,3];
                return
                  SliverList(
                    delegate: new SliverChildBuilderDelegate(
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
//                                              appBloc.auth.deviceState.attributes['notif'][index]['status'] = true;
//                                              appBloc.auth.deviceState.save();
//                                              Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
//                                                builder: (BuildContext context) => new NotifPage.edit(childs[index]['detailUrl']),
//                                                fullscreenDialog: true,
//                                              ));
                          },
                          // Our Custom Button!
                          child: _buildCard(context, index),
                        )
                      ),
                    childCount: childs.length,
                  )
                );
              }
            ),
          ]
        )
      ),
      drawer: new Drawer(
          child: new ListView(
            children: <Widget> [
              new DrawerHeader(child: new Text('Header'),),
              new ListTile(
                title: new Text('First Menu Item'),
                onTap: () {},
              ),
              new ListTile(
                title: new Text('Second Menu Item'),
                onTap: () {},
              ),
              new Divider(),
              new ListTile(
                title: new Text('About'),
                onTap: () {},
              ),
            ],
          )
      ),
    );
  }


  Widget _buildButtonHeader(BuildContext context, IconData icon, String text, int count) {
    return new Column(
      children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(
                top: 10.0,
                right: 10.0,
                left: 10.0,
                bottom: 10.0,
              ),
              padding: const EdgeInsets.only(
                top: 10.0,
                right: 10.0,
                left: 10.0,
                bottom: 10.0,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 1.5),
                  borderRadius: BorderRadius.circular(13.0)
              ),
              child: Icon(icon, color: Colors.white,size: 50.0,),
            ),
            count > 0 ? new Positioned(  // draw a red marble
              top: 2.0,
              right: 2.0,
              child: new CircleAvatar(child: new Text(count.toString(), style: TextStyle(fontSize: 12.0, color: warnaHijau, fontWeight: FontWeight.w600),), radius: 12.0, backgroundColor: Colors.white,),
            ) : null
          ].where(notNull).toList(),
        ),
        new Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0),)
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
  Widget _buildCard(BuildContext context, index) {
    return _buildMainCard(context);
  }
  Widget _buildMainCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
//        right: 10.0,
//        left: 10.0,
        bottom: 0.0,
      ),
      padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
//      decoration: new BoxDecoration(
//          color: Colors.white,
//          borderRadius: BorderRadius.circular(5.0)
//      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(
                image: _logoImage,
                width: 80.0,
                height: 80.0,
              ),
              new Padding(padding: EdgeInsets.only(left: 10.0)),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text('4 hrs 15 mins Remaining', style: TextStyle(color: Colors.grey),),
                        ),
                        Icon(Icons.clear, color: Colors.grey,),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Text('Abdul Qodir', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textGrey, height: 0.6)),
                    new StarRating(
                      rating: 4.5,
                      color: Colors.orange,
                      onRatingChanged: (rating) => () => {

                      },
                    ),
                    Text('Check in / Check out date', style: TextStyle(color: Colors.grey, fontSize: 12.0, height: 1.5),),
                    Text('13 May 2018 / 18 May 2018', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),

                    Text('Number Of Rooms', style: TextStyle(color: Colors.grey, fontSize: 12.0, height: 1.5),),
                    Row(
                      children: <Widget>[
                        Text('5 Room', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),
                        new Container(
                          width: 1.0,
                          height: 12.0,
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: new BoxDecoration(
                              color: Colors.grey
                          ),
                        ),
                        Text('2 Person / Room', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Bid Now', style: TextStyle(fontWeight: FontWeight.w600, color: warnaHijau),),
                        Icon(Icons.chevron_right, color: warnaHijau,)
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          new Divider(color: Colors.grey),
        ],
      ),
    );
  }
  Widget _buildCanceledOnBidding(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        right: 10.0,
        left: 10.0,
        bottom: 0.0,
      ),
      padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(color: warnaOranye, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: IconButton(icon: new Icon(Icons.timer, color: warnaOranye,size: 65.0), padding: EdgeInsets.all(0.0)),
              ),
              new Padding(padding: EdgeInsets.only(left: 5.0)),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text('Canceled', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                          decoration: BoxDecoration(
                              color: warnaOranye,
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          padding: EdgeInsets.all(4.0),
                        ),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        Icon(Icons.access_time, color: Colors.grey,),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        new Expanded(
                          child: new Text('4 hrs 15 mins Remaining', style: TextStyle(color: Colors.grey),),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.grey),
                        new Expanded(
                            child: Text('Makka, Madinah', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textGrey))
                        )
                      ],
                    ),
                    Text('Start - End Reservation date', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                    Text('13 May 2018 - 18 May 2018 / 5 Days', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),
                  ],
                ),
              ),
            ],
          ),
          new Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total Room(s)', style: TextStyle(color: Colors.grey),),
                  Text('10 Rooms', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey, width: 1.0))
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Cancelation Reason', style: TextStyle(color: Colors.grey),),
                      Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ultrices ante et mollis scelerisque', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
  Widget _buildComplete(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        right: 10.0,
        left: 10.0,
        bottom: 0.0,
      ),
      padding: const EdgeInsets.only(top:10.0, bottom: 10.0, left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(color: warnaGolden, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0)
                ),
                child: IconButton(icon: new Icon(Icons.timer, color: warnaGolden,size: 65.0), padding: EdgeInsets.all(0.0)),
              ),
              new Padding(padding: EdgeInsets.only(left: 5.0)),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text('Completed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                          decoration: BoxDecoration(
                              color: warnaGolden,
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          padding: EdgeInsets.all(4.0),
                        ),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        Icon(Icons.access_time, color: Colors.grey,),
                        new Padding(padding: EdgeInsets.only(left: 5.0)),
                        new Expanded(
                          child: new Text('4 hrs 15 mins Remaining', style: TextStyle(color: Colors.grey),),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.grey),
                        new Expanded(
                            child: Text('Makka, Madinah', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: textGrey))
                        )
                      ],
                    ),
                    Text('Check in / Check out date', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                    Text('13 May 2018 / 18 May 2018', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),),
                    Text('2 Person / Room', style: TextStyle(fontWeight: FontWeight.w600, color: textGrey),)
                  ],
                ),
              ),
            ],
          ),
          new Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(Icons.hotel, color: textGrey, size: 30.0,),
              new Container(
                width: 1.0,
                height: 30.0,
                decoration: new BoxDecoration(
                    color: Colors.grey
                ),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total', style: TextStyle(color: Colors.grey),),
                  Text('10', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                ],
              ),
              new Container(
                width: 1.0,
                height: 30.0,
                decoration: new BoxDecoration(
                    color: Colors.grey
                ),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Confirmed', style: TextStyle(color: Colors.grey),),
                  Text('3', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600),)
                ],
              ),
              new Container(
                width: 1.0,
                height: 30.0,
                decoration: new BoxDecoration(
                    color: Colors.grey
                ),
              ),
              Text('30%', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600, fontSize: 22.0))
            ],
          ),
          new Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(left: 12.0, right: 20.0),
                child: Icon(Icons.monetization_on, color: textGrey, size: 30.0,),
              ),
              new Container(
                width: 1.0,
                margin: EdgeInsets.only(right: 20.0),
                height: 30.0,
                decoration: new BoxDecoration(
                    color: Colors.grey
                ),
              ),
              Text('150.000 SAR', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600, fontSize: 22.0))
            ],
          )
        ],
      ),
    );
  }
}

class DismissDialogAction {
}
