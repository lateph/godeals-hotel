import 'package:inka_msa/forms/auth/login.form.dart';
import 'package:inka_msa/helpers/background_decoration.dart';
import 'package:inka_msa/pages/auth/forgot_password.page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/auth/login';

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginForm _loginForm = LoginForm();

  final AssetImage _logoImage = AssetImage('assets/images/msa.png');
  final AssetImage _logoImage2 = AssetImage('assets/images/logo_outline.png');
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) {
//        print("onMessage: $message");
////        _showItemDialog(message);
//      },
//      onLaunch: (Map<String, dynamic> message) {
//        print("onLaunch: $message");
////        _navigateToItemDetail(message);
//      },
//      onResume: (Map<String, dynamic> message) {
//        print("onResume: $message");
////        _navigateToItemDetail(message);
//      },
    );
  }

  @override
  void dispose() {
    _loginForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: new Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: backgroundDecoration(context),
          child: new SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    right: 24.0,
                    left: 24.0,
                    bottom: 10.0,
                  ),
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  decoration: new BoxDecoration(
                    color: new Color(0x80EEEEEE),
                  ),
                  child: Center(
                    child: Image(
                      image: _logoImage,
                      width: 300.0,
                    ),
                  ),
                ),
                _buildLoginForm(context),
                _buildLoginButton(context),
                new Container(
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 24.0,
                  ),
                  child: Center(
                    child: Image(
                      image: _logoImage2,
                      width: 150.0,
                    ),
                  ),
                )
//                _buildForgotPasswordButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 16.0,
      ),
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 24.0,
        top: 0.0,
      ),
      decoration: BoxDecoration(
//        border: Border.all(
//          color: Colors.grey.shade300,
//        ),
      ),
      child: Form(
        key: _loginForm.key,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _loginForm.errors,
          builder: (context, snapshot) {
            print("Has data: " + snapshot.hasData.toString());
            print("Error data: " + snapshot.data.toString());
            return Container(
               padding: const EdgeInsets.only(left:10.0, right: 10.0),
               child: Column(
                  children: <Widget>[
                    new Theme(
                        data: Theme.of(context).copyWith(hintColor: Colors.white),
                        child: new Stack(
                            children: <Widget>[
                              new Container(
                                height: 43.0,
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(40.0),
                                    color: Colors.white
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 40.0, top: 12.0, right: 12.0, bottom: 12.0),
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.white,style: BorderStyle.none),
                                    borderRadius: new BorderRadius.circular(40.0),
                                  ),
                                  isDense: true,
                                  hintText: 'Username',
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelStyle: new TextStyle(color: Colors.white, decorationColor: Colors.white),
                                  errorStyle: new TextStyle(color: Colors.black),
                                  errorText: snapshot.hasData
                                      ? snapshot.data['username']?.join(', ')
                                      : null,
                                ),
                                onSaved: (val) => _loginForm.fields['username'] = val,
                              )
                            ]
                        )
                    ),
                    Container(height: 8.0),
                    new Theme(
                        data: Theme.of(context).copyWith(hintColor: Colors.white),
                        child: new Stack(
                            children: <Widget>[
                              new Container(
                                height: 43.0,
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.circular(40.0),
                                    color: Colors.white
                                ),
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 40.0, top: 12.0, right: 12.0, bottom: 12.0),
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(color: Colors.white,style: BorderStyle.none),
                                    borderRadius: new BorderRadius.circular(40.0),
                                  ),
                                  isDense: true,
                                  hintStyle: new TextStyle(color: Colors.grey),
                                  labelStyle: new TextStyle(color: Colors.white, decorationColor: Colors.white),
                                  errorStyle: new TextStyle(color: Colors.black),
                                  hintText: 'Password',
                                  errorText: snapshot.hasData
                                      ? snapshot.data['password']?.join(', ')
                                      : null,
                                ),
                                onSaved: (val) => _loginForm.fields['password'] = val,
                              ),
                            ]
                        )
                    )
                  ],
                )
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        border: new Border.all(style: BorderStyle.solid, color: new Color(0x99FFFFFF), width: 2.0),
        borderRadius: new BorderRadius.circular(20.0),
        color: new Color(0x99000000)
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 45.0
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: RaisedButton(
        child: Text('LOGIN' , style: new TextStyle(color: new Color(0x99FFFFFF))),
        color: new Color(0x00000000),
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: () async {
          // save form
          _loginForm.key.currentState.save();

          // validate then submit
          if (_loginForm.key.currentState.validate()) {
            await _loginForm.submit(context);
          }
        },
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 64.0,
        bottom: 24.0,
      ),
      child: Align(
        alignment: Alignment.center,
        child: FlatButton(
          child: Text(
            'Lupa Password',
            style: Theme.of(context).textTheme.body1.copyWith(
                  color: Colors.red.shade800,
                ),
          ),
          onPressed: () {
            // save form
            Navigator.of(context).pushNamed(ForgotPasswordPage.routeName);
          },
        ),
      ),
    );
  }
}
