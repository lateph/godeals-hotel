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
import 'package:inka_msa/pages/report/stock/stock.filter.page.dart';
import 'package:inka_msa/pages/report/train.availability.model.dart';
import 'package:intl/intl.dart';
import 'test.dart';

class Dessert {
  Dessert (value) {
    this.trainSetId = value['trainSetId'];
    this.trainCarId = value['trainCarId'];
    this.trainSetNumber = value['trainSetNumber'];
    this.trainSetName = value['trainSetName'];
    this.trainCarNumber = value['trainCarNumber'];
    this.trainCarName = value['trainCarName'];

    this.totalMinute = value['totalMinute'].toString();
    this.totalDay = value['totalDay'].toString();
    this.scheduledMinutes = value['scheduledMinutes'].toString();
    this.scheduledPercentage = value['scheduledPercentage'].toString();
    this.unscheduledMinutes = value['unscheduledMinutes'].toString();
    this.unscheduledPercentage = value['unscheduledPercentage'].toString();
    this.overallMinutes = value['overallMinutes'].toString();
    this.overallPercentage = value['overallPercentage'].toString();
    this.isGood = value['isGood'];

  }

  int trainSetId;
  int trainCarId;
  String trainSetNumber;
  String trainSetName;
  String trainCarNumber;
  String trainCarName;

  String totalMinute;
  String totalDay;
  String scheduledMinutes;
  String scheduledPercentage;
  String unscheduledMinutes;
  String unscheduledPercentage;
  String overallMinutes;
  String overallPercentage;
  bool isGood;

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
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: dessert.trainCarName != null ? <Widget>[
                        new Text("Tran Set Name"),
                        new Text("Tran Car Name"),
                      ] : <Widget>[
                        new Text("Tran Set Name"),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  dessert.trainCarName != null ? <Widget>[
                        new Text(dessert.trainSetName, style: new TextStyle(color: Colors.grey)),
                        new Text(dessert.trainCarName, style: new TextStyle(color: Colors.grey)),
                      ] : <Widget>[
                        new Text(dessert.trainSetName, style: new TextStyle(color: Colors.grey)),
                      ],
                    ),
                    new Padding(padding: const EdgeInsets.only(top: 10.0)),
                    new Text("Life Time"),
                    new Text("${dessert.totalMinute} minutes (${dessert.totalDay} days)", style: new TextStyle(color: Colors.grey)),
                    new Padding(padding: const EdgeInsets.only(top: 10.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          width: 110.0,
                          child: new Text("Scheduled"),
                        ),
                        new Text('${dessert.scheduledMinutes} mins - ${dessert.scheduledPercentage}%', style: new TextStyle(color: Colors.grey)),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          width: 110.0,
                          child: new Text("Unscheduled"),
                        ),
                        new Text('${dessert.unscheduledMinutes} mins - ${dessert.unscheduledPercentage}%', style: new TextStyle(color: Colors.grey)),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          width: 110.0,
                          child: new Text("Available"),
                        ),
                        new Text('${dessert.overallMinutes} mins - ${dessert.overallPercentage}%', style: new TextStyle(color: Colors.grey)),
                      ],
                    )
                  ],
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

class StockComponentPage extends StatefulWidget {
  static const String routeName = '/report-stock';

  @override
  _StockComponent createState() => new _StockComponent();
}

class _StockComponent extends State<StockComponentPage> {
  int _rowsPerPage = 10;
  int _sortColumnIndex;
  bool _sortAscending = true;
  dynamic listTrainSet;
  List<dynamic> list = [];
  final DessertDataSource _dessertsDataSource = new DessertDataSource();
  SearchModel searchModel = new SearchModel( new DateTime.utc(new DateTime.now().year, 1, 1), new DateTime.now(), ''  , 'trainCar');

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
        Api.routes[ApiRoute.componentStock],
        data: {
          "date" : new DateFormat('y-MM-dd').format(searchModel.dateFrom),
          "locationId" : searchModel.trainSetId
        },
        options: Options(
          contentType: ContentType.JSON,
          headers: {
            'Authorization': appBloc.auth.deviceState.bearer,
          },
        ),
      );
      setState(() {
        list = response.data['data'][0]['children'];
      });
//      _dessertsDataSource.loadJSON(response.data['data']);
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
        Api.routes[ApiRoute.locations],
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
          title: const Text('Stock Component'),
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
        body: new ListView.builder(
            itemBuilder: (context, i) =>  _buildex(context, list[i]),
            itemCount: list.length
        )
    );
  }
//
  Widget _buildex(BuildContext context, obj) {
    List<dynamic> childs = obj['children'];
    print(childs);
    return new  ExpansionTile2(
        title:
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("(${obj['component_code']}) - ${obj['component_name']} [${obj['measurement_technical']}] "),
            new Text("${obj['freeStock']} Free, ${obj['usedStock']} Used, ${obj['replacedStock']} Replaced" , style: new TextStyle(color: Colors.grey),)
          ],
        ),
        children: childs
            .map((val) => _buildex(context, val))
            .toList()
    );
  }
}