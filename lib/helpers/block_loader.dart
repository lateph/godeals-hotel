import 'dart:async';

import 'package:flutter/material.dart';

Future<T> blockLoader<T>(BuildContext context, {bool isDummy: false}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String text = isDummy ? 'Dummy loading...' : 'Harap tunggu...';

      return new WillPopScope(
        child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new Container(
                height: 16.0,
              ),
              new Text(
                text,
                style: Theme.of(context).textTheme.body1.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        onWillPop: () {
          return new Future<bool>.value(false);
        },
      );
    },
  );
}
