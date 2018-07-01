import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'test.dart';

class StockPage extends StatefulWidget {
  static const String routeName = '/report-stock';

  @override
  _Schedulebility createState() => new _Schedulebility();
}

class _Schedulebility extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("List Header App"),
      ),
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
                child: new Text("Expandable List"),
                color: Colors.green,
                onPressed: () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                        new HeaderPage(title: "Expandable List")))),
            new Padding(padding: const EdgeInsets.only(top: 50.0)),
            new RaisedButton(
                child: new Text("Sticky Header List"),
                color: Colors.red,
                onPressed: () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                        new HeaderPage(title: "Sticky Header List")))),
          ],
        ),
      ),
    );
  }
}

class HeaderPage extends StatelessWidget {
  final title;

  const HeaderPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: title == 'Expandable List' ? ExpandableList() : StickyList(),
    );
  }
}

class ExpandableList extends StatelessWidget {
  final list = new List.generate(10, (i) => "Item ${i+1}");
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, i) => ExpansionTile2(
        title:
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text("Header ${i+1}"),
              new Text("Sub  Title ${i+1}" , style: new TextStyle(color: Colors.grey),)
            ],
          ),
        children: list
            .map((val) => new ListTile(
          title: new Text(val),
        ))
            .toList(),
      ),
      itemCount: 5,
    );
  }
}

class StickyList extends StatelessWidget {
  final list = new List.generate(10, (i) => "Item ${i+1}");
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, i) => new StickyHeader(
          header: new Container(
            height: 40.0,
            child: new Text("Header $i"),
            padding: const EdgeInsets.all(8.0),
          ),
          content: new Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: new Column(
                children: list
                    .map((val) => new ListTile(
                  title: new Text(val),
                ))
                    .toList()),
          )),
    );
  }
}