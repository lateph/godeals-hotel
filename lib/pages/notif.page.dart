import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/pages/profile.edit.page.dart';
import 'package:inka_msa/pages/profile.password.page.dart';
import 'package:inka_msa/helpers/block_loader.dart';

import 'package:dio/dio.dart';

class NotifPage extends StatefulWidget {
  static const String routeName = '/detail-notif';
  final String url;

  NotifPage.edit(this.url);

  @override
  _NotifPageState createState() {
    return new _NotifPageState(url);
  }
}


class Dessert {
  load (value) {
    this.trainCarName = value['trainCarName'];
    this.scheduledFrom = value['scheduledFrom'];
    this.scheduledTo = value['scheduledTo'];
    this.maintenanceType = value['maintenanceType'];
    this.status = value['status'];

    this.taskList = value['taskList'];
    this.progressInformation = value['progressInformation'];
    this.additionalInformation = value['additionalInformation'];
  }

  String trainCarName = '';
  String scheduledFrom= '';
  String scheduledTo= '';
  String maintenanceType= '';
  String status= '';

  List<dynamic> taskList = [];
  dynamic progressInformation;
  dynamic additionalInformation;

  bool selected = false;
}

class _NotifPageState extends State<NotifPage> {
  final AssetImage _logoImage = AssetImage('assets/images/msa.png');
  AssetImage background = AssetImage('assets/images/home.jpg');
  String url;
  Dessert data = new Dessert();

  _NotifPageState(this.url);

  @override
  void initState() {
    super.initState();
    getTrainSet(context);
  }

  void _select(String choice) async {
    AppBloc appBloc = AppBlocProvider.of(context);
    // Causes the app to rebuild with the new _selectedChoice.
    if(choice == 'Logout'){
      await appBloc.auth.logout(context);
    }
    if(choice == 'EditProfile'){
      Navigator.of(context).pushNamed(EditProfilePage.routeName);
    }
    if(choice == 'ChangePassword'){
      Navigator.of(context).pushNamed(EditPasswordPage.routeName);
    }
  }

  Future<Null> getTrainSet(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);
    try {
      Response response = await appBloc.app.api.get(
        url,
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      setState(() {
        data.load(response.data['data']);
      });
//      data = response.data['data'];
    } on DioError catch (e) {
      // on 400 error
      if (e.response != null) {
        print(e.response.data.toString());
      } else {
        print(e.message);
        print("Please check your internet connection");
      }
    }

    // pop the loader
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Notif'),
          elevation: 0.0,
        ),
        body: new SafeArea(
            child: new Card(
              elevation: 0.0,
              child: new Container(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text("Tran Car Name"),
                        new Text("Schedule Type"),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text(data.trainCarName, style: new TextStyle(color: Colors.grey)),
                        new Text(data.maintenanceType, style: new TextStyle(color: Colors.grey)),
                      ],
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 10.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text("Scheduled from"),
                        new Text("Scheduled to"),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text(data.scheduledFrom, style: new TextStyle(color: Colors.grey)),
                        new Text(data.scheduledTo, style: new TextStyle(color: Colors.grey)),
                      ],
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 10.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text("Status"),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text(data.status, style: new TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ]
                    ..addAll(_buildTaskList(data)),
                ),
                padding: const EdgeInsets.all(10.0),
              ),
            )
        )
    );
  }
}

List<Widget> _buildTaskList(Dessert dessert) {
  final List<Widget> taskList = new List<Widget>();

  if(dessert.taskList.length > 0) {
    taskList.add(
      new Padding(padding: const EdgeInsets.only(top: 10.0)),
    );
    taskList.add(
      new Text('Task List', style: new TextStyle(fontWeight: FontWeight.bold),),
    );

    for (var value in dessert.taskList) {
      taskList.add(new Divider());
      taskList.add(new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
          new Text(value['taskName']),
          new Text(value['status'], style: new  TextStyle(color: value['status'].toString() == 'Undone' ? Colors.red : Colors.green),),
        ],
      ));


      if( (value['startedAt'].runtimeType.toString() != 'Null' && value['startedAt'].toString() != '')  || (value['finishedAt'].runtimeType.toString() != 'Null' && value['finishedAt'].toString() != '')) {
        taskList.add(new Padding(padding: const EdgeInsets.only(top: 10.0)),);

        if(value['startedAt'].runtimeType.toString() != 'Null' && value['startedAt'].toString() != ''){
          taskList.add(new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              new Container(
                child: new Text('Started At'),
                width: 120.0,
              ),
              new Text(value['startedAt']),
            ],
          ));
        }

        if(value['finishedAt'].runtimeType.toString() != 'Null' && value['finishedAt'].toString() != ''){
          taskList.add(new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:<Widget>[
              new Container(
                child: new Text('Finished At'),
                width: 120.0,
              ),
              new Text(value['finishedAt']),
            ],
          ));
        }

      }

      List<dynamic> tools = value['tools'];

      if (tools.length > 0){
        taskList.add(new Padding(padding: const EdgeInsets.only(top: 10.0)),);
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:<Widget>[
            new Text("Tools"),
          ],
        ));
        int counter = 1;
        for (var vt in tools) {
          taskList.add(new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              new Text('${counter}. ${vt.toString()}'),
            ],
          ));
          counter++;
        }
      }
    }

    if(dessert.progressInformation.runtimeType.toString() == '_InternalLinkedHashMap<String, dynamic>'){
      taskList.add(
        new Padding(padding: const EdgeInsets.only(top: 10.0)),
      );
      taskList.add(new Divider());
      taskList.add(
        new Text('Progress Information', style: new TextStyle(fontWeight: FontWeight.bold),),
      );
      taskList.add(
        new Padding(padding: const EdgeInsets.only(top: 10.0)),
      );


      if(dessert.progressInformation['startedAt'].toString() != '') {
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Started At'),
              width: 120.0,
            ),
            new Text(dessert.progressInformation['startedAt']),
          ],
        ));
      }

      if(dessert.progressInformation['finishedAt'].runtimeType.toString() != 'Null' && dessert.progressInformation['finishedAt'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Finished At'),
              width: 120.0,
            ),
            new Text(dessert.progressInformation['finishedAt']),
          ],
        ));
      }

      if(dessert.progressInformation['notes'].runtimeType.toString() != 'Null' && dessert.progressInformation['notes'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Note'),
              width: 120.0,
            ),
            new Text(dessert.progressInformation['notes']),
          ],
        ));
      }
    }

    if(dessert.additionalInformation.runtimeType.toString() == '_InternalLinkedHashMap<String, dynamic>'){
      taskList.add(
        new Padding(padding: const EdgeInsets.only(top: 10.0)),
      );
      taskList.add(new Divider());
      taskList.add(
        new Text('Additional Information', style: new TextStyle(fontWeight: FontWeight.bold),),
      );
      taskList.add(
        new Padding(padding: const EdgeInsets.only(top: 10.0)),
      );

      if(dessert.additionalInformation['problemDate'].runtimeType.toString() != 'Null' && dessert.additionalInformation['problemDate'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Problem Date'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['problemDate']),
              width: 150.0,
            )
          ],
        ));
      }

      if(dessert.additionalInformation['possibleCause'].runtimeType.toString() != 'Null' && dessert.additionalInformation['possibleCause'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Possible Cause'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['possibleCause']),
              width: 150.0,
            )

          ],
        ));
      }

      if(dessert.additionalInformation['possibleCauseDescription'].runtimeType.toString() != 'Null' && dessert.additionalInformation['possibleCauseDescription'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Possible Description'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['possibleCauseDescription']),
              width: 150.0,
            )
          ],
        ));
      }

      if(dessert.additionalInformation['priority'].runtimeType.toString() != 'Null' && dessert.additionalInformation['priority'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Priority'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['priority']),
              width: 150.0,
            )
          ],
        ));
      }

      if(dessert.additionalInformation['tdlsAct'].runtimeType.toString() != 'Null' && dessert.additionalInformation['tdlsAct'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('TDLS Act'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['tdlsAct']),
              width: 150.0,
            )
          ],
        ));
      }

      if(dessert.additionalInformation['tdlsResult'].runtimeType.toString() != 'Null' && dessert.additionalInformation['tdlsResult'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('TDLS Result'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['tdlsResult']),
              width: 150.0,
            )
          ],
        ));
      }

      if(dessert.additionalInformation['tdlsStatus'].runtimeType.toString() != 'Null' && dessert.additionalInformation['tdlsStatus'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('TDLS Status'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['tdlsStatus']),
              width: 150.0,
            )

          ],
        ));
      }

      if(dessert.additionalInformation['reporter'].runtimeType.toString() != 'Null' && dessert.additionalInformation['reporter'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Reporter'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['reporter']),
              width: 150.0,
            )
          ],
        ));
      }

      if(dessert.additionalInformation['additionalDescription'].runtimeType.toString() != 'Null' && dessert.additionalInformation['additionalDescription'].toString() != ''){
        taskList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Container(
              child: new Text('Additional Description'),
              width: 150.0,
            ),
            new Container(
              child: new Text(dessert.additionalInformation['additionalDescription']),
              width: 150.0,
            )
          ],
        ));
      }
    }
  }

  return taskList;
}