import 'package:firebase_messaging/firebase_messaging.dart';
// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/pages/auth/login.page.dart';
import 'package:inka_msa/pages/home.page.dart';
import 'package:inka_msa/pages/profile.page.dart';
import 'package:inka_msa/pages/report.page.dart';

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    Widget child,
    TickerProvider vsync,
  }) : _icon = icon,
        _color = color,
        _title = title,
        _child = child,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final Widget _child;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: _child,
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class NewPage extends StatelessWidget {
  final String title;
  NewPage(this.title);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new Text('test')
      ),
    );
  }
}


class MainPage extends StatefulWidget {
  static const String routeName = '/material/bottom_navigation';

  @override
  _BottomNavigationDemoState createState() => new _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<MainPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: const Icon(Icons.home),
          title: 'home',
          color: Colors.deepPurple,
          vsync: this,
          child: new HomePage()
      ),
      new NavigationIconView(
        icon: const Icon(Icons.receipt),
        title: 'Report',
        color: Colors.teal,
        vsync: this,
        child: new ReportPage()
      ),
      new NavigationIconView(
        icon: const Icon(Icons.account_circle),
        title: 'Account',
        color: Colors.indigo,
        vsync: this,
        child: new ProfilePage()
      ),
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  void simpanMessage (AppBloc appBloc, message) {
    print(appBloc.auth.deviceState.attributes['notif'].runtimeType.toString());
    if (appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<Map<String, String>>' || appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<dynamic>' || appBloc.auth.deviceState.attributes['notif'].runtimeType.toString() == 'List<Map<String, dynamic>>'){
      appBloc.auth.deviceState.attributes['notif'].insert(0,
          {
            'title': message['title'],
            'messsage': message['message'],
            'time': message['time'],
            'detailUrl': message['detailUrl']
          }
      );
    }
    else{
      appBloc.auth.deviceState.attributes['notif'] = [
        {
          'title': message['title'],
          'messsage': message['message'],
          'time': message['time'],
          'detailUrl': message['detailUrl']
        }
      ];
    }
    appBloc.auth.deviceState.save();
    appBloc.auth.updateAuthStatus();
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("New Message"),
        ));
        print("onMessage: $message");
        simpanMessage(appBloc, message);
//        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("New Message Launc"),
        ));
        print("onLaunch: $message");
        simpanMessage(appBloc, message);
//        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("New Message Resume"),
        ));
        simpanMessage(appBloc, message);
//        _navigateToItemDetail(message);
      },
    );

    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      body: new Center(
          child: _buildTransitionsStack()
      ),
      bottomNavigationBar:  new Theme(data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
          canvasColor: new Color(0xFF303030),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
//          primaryColor: new Color(0xFF00d754),
          textTheme: Theme
              .of(context)
              .textTheme
              .copyWith(caption: new TextStyle(color: Colors.white))), child: botNavBar),
    );
  }
}