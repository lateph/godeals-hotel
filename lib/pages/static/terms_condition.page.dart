import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatefulWidget {
  static const String routeName = '/static/terms-condition';

  @override
  _TermsAndConditionPageState createState() => new _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Terms and Condition Page'),
      ),
    );
  }
}
