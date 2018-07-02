import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/rendering.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/config/api.config.dart';
import 'package:inka_msa/helpers/block_loader.dart';
import 'package:inka_msa/helpers/paginated_data_table.dart';
import 'package:inka_msa/pages/report/schedule.filter.dart';
import 'package:inka_msa/pages/report/schedule.model.dart';
import 'package:intl/intl.dart';

class Dessert {
  Dessert (value) {
    this.trainCarName = value['trainCarName'];
    this.scheduledFrom = value['scheduledFrom'];
    this.scheduledTo = value['scheduledTo'];
    this.maintenanceType = value['maintenanceType'];
    this.status = value['status'];

    this.taskList = value['taskList'];
    this.progressInformation = value['progressInformation'];
    this.additionalInformation = value['additionalInformation'];


  }

  String trainCarName;
  String scheduledFrom;
  String scheduledTo;
  String maintenanceType;
  String status;

  List<dynamic> taskList;
  dynamic progressInformation;
  dynamic additionalInformation;

  bool selected = false;
}

class DessertDataSource extends DataTableSource {
  final List<Dessert> _desserts = <Dessert>[];

  void _sort<T>(Comparable<T> getField(Dessert d), bool ascending) {
    _desserts.sort((Dessert a, Dessert b) {
      if (!ascending) {
        final Dessert c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  loadJSON (dynamic data ) {
    _desserts.clear();
    for (var value in data) {
      _desserts.add(new Dessert(value) );
      notifyListeners();
    }
  }


  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _desserts.length)
      return null;
    final Dessert dessert = _desserts[index];


    return new DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          new DataCell(new Container(
            padding: const EdgeInsets.all(5.0),
            child: new Card(
              elevation: 3.0,
              child: new Container(
                decoration: new BoxDecoration(
                    border: Border(left: BorderSide(color: dessert.status == 'On Progress' ? Colors.orange : dessert.status == 'Created' ? Colors.blue : Colors.green, width: 3.0))
                ),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text("Train Car Name"),
                        new Text("Schedule Type"),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:<Widget>[
                        new Text(dessert.trainCarName, style: new TextStyle(color: Colors.grey)),
                        new Text(dessert.maintenanceType, style: new TextStyle(color: Colors.grey)),
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
                        new Text(dessert.scheduledFrom, style: new TextStyle(color: Colors.grey)),
                        new Text(dessert.scheduledTo, style: new TextStyle(color: Colors.grey)),
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
                        new Text(dessert.status, style: new TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ]..addAll(_buildTaskList(dessert)),
                ),
                padding: const EdgeInsets.all(10.0),
              ),
            ),
          )),
        ]
    );
//    }
//    else {
//      return new DataRow.byIndex(
//          index: index,
//          cells: <DataCell>[
//            new DataCell(new Text('[${dessert.trainSetNumber}] ${dessert.trainSetName} - [${dessert.trainCarNumber}] ${dessert.trainCarName}')),
//          ]
//      );
//    }
  }

  @override
  int get rowCount => _desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class SchedulePage extends StatefulWidget {
  static const String routeName = '/report-schedule';
  SearchModel searchModel;
  SchedulePage.edit(this.searchModel);

  @override
  _Schedulebility createState() {
//    if (weighEntryToEdit != null) {
//      return new WeightEntryDialogState(weighEntryToEdit.dateTime,
//          weighEntryToEdit.weight, weighEntryToEdit.note);
//    } else {
//      return new WeightEntryDialogState(
//          new DateTime.now(), initialWeight, null);
//    }
    return new _Schedulebility(searchModel);
  }
}

class _Schedulebility extends State<SchedulePage> {
  _Schedulebility(this.searchModel);
  int _rowsPerPage = 10;
  int _sortColumnIndex;
  bool _sortAscending = true;
  dynamic listTrainSet;
  final DessertDataSource _dessertsDataSource = new DessertDataSource();
  SearchModel searchModel = new SearchModel(new DateTime.now(), new DateTime.now(), ''  , '', '');

  void _sort<T>(Comparable<T> getField(Dessert d), int columnIndex, bool ascending) {
    _dessertsDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void initState() {
    super.initState();
    resend(context);
    getTrainSet(context);
  }

  Future<Null> resend(BuildContext context) async {
    blockLoader(context);
    final AppBloc appBloc = AppBlocProvider.of(context);
    try {
      Response response = await appBloc.app.api.post(
        Api.routes[ApiRoute.schedule],
        data: {
          "dateFrom" : new DateFormat('y-MM-dd').format(searchModel.dateFrom),
          "dateTo" : new DateFormat('y-MM-dd').format(searchModel.dateTo),
          "trainSetId" : searchModel.trainSetId,
          "status" : searchModel.status,
          "action" : searchModel.action,
        },
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      _dessertsDataSource.loadJSON(response.data['data']);
      print(response.data['data']);
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

  Future<Null> getTrainSet(BuildContext context) async {
    blockLoader(context);

    final AppBloc appBloc = AppBlocProvider.of(context);
    try {
      Response response = await appBloc.app.api.get(
        Api.routes[ApiRoute.trainSet],
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      listTrainSet = response.data['data'];
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

  _editEntry(context) {
    Navigator
        .of(context)
        .push(
      new MaterialPageRoute<SearchModel>(
        builder: (BuildContext context) {
          return new WeightEntryDialog.edit(searchModel, listTrainSet);
        },
        fullscreenDialog: true,
      ),
    )
        .then((newSave) {
      if (newSave != null) {
        setState(() => searchModel = newSave);
        resend(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: const Text('Maintenance Schedule'),
            actions: <Widget>[
              // action button
              new IconButton(
                icon: new Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _editEntry(context);
//                  resend(context);
                  });
                },
              ),
            ]
        ),
        body: new Column(
          children: <Widget>[
            new Expanded(
                child: new MyPaginatedDataTable(
                    header: const Text(''),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (int value) { setState(() { _rowsPerPage = value; }); },
                    columns: <DataColumn>[
                      new DataColumn(
                          label: const Text('Dessert (100g serving)'),
                          onSort: (int columnIndex, bool ascending) => _sort<String>((Dessert d) => d.scheduledTo, columnIndex, ascending)
                      ),
                    ],
                    source: _dessertsDataSource
                )
            )
          ],
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