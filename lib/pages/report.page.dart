import 'package:flutter/material.dart';
import 'package:inka_msa/pages/report/schedule.first.page.dart';
import 'package:inka_msa/pages/report/stock/stock.page.dart';
import 'package:inka_msa/pages/report/train.availability.page.dart';
import 'package:inka_msa/pages/report/train.reliability.page.dart';

class ReportPage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _ReportPageState createState() => new _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Report'),
      ),
      body: new Container(
        padding: new EdgeInsets.only(left: 15.0),
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text('Maintenance Schedule'),
              trailing: new Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushNamed(ScheduleFirstPage.routeName);
                }
            ),
            new Divider(),
            new ListTile(
              title: new Text('Component Stock'),
              trailing: new Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushNamed(StockComponentPage.routeName);
                }
            ),
            new Divider(),
            new ListTile(
              title: new Text('Train Availability'),
              trailing: new Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed(TrainAvailabilityPage.routeName);
              }
            ),
            new Divider(),
            new ListTile(
              title: new Text('Train Reliability'),
              trailing: new Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushNamed(TrainReliabilityPage.routeName);
                }
            ),
          ],
        ),
      ),
    );
  }
}
