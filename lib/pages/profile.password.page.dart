import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:flutter/material.dart';
import 'package:inka_msa/forms/profile/change_password.dart';

class EditPasswordPage extends StatefulWidget {
  static const routeName = '/profile/edit-password';

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPasswordPage> {
  final ChangePasswordForm _changePhoneNumberForm = ChangePasswordForm();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _changePhoneNumberForm.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('diceluk');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Password'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildForgotPasswordForm(context),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 24.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Form(
        key: _changePhoneNumberForm.key,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _changePhoneNumberForm.errors,
          builder: (context, snapshot) {
//            print("Has data: " + snapshot.hasData.toString());
//            print("Error data: " + snapshot.data.toString());
            print(_changePhoneNumberForm.fields['name']);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                    initialValue:  _changePhoneNumberForm.fields['oldPassword'],
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Old Password',
                      errorText: snapshot.hasData
                          ? snapshot.data['oldPassword']?.join(', ')
                          : null,
                    ),
                    onSaved: (val) {
                      _changePhoneNumberForm.fields['oldPassword'] = val;
                    }
                ),
                TextFormField(
                  initialValue:  _changePhoneNumberForm.fields['newPassword'],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'New Password',
                    errorText: snapshot.hasData
                        ? snapshot.data['newPassword']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) =>
                  _changePhoneNumberForm.fields['newPassword'] = val,
                ),
                TextFormField(
                  initialValue:  _changePhoneNumberForm.fields['confirmNewPassword'],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Confirm New Password',
                    errorText: snapshot.hasData
                        ? snapshot.data['confirmNewPassword']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) =>
                  _changePhoneNumberForm.fields['confirmNewPassword'] = val,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 24.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: RaisedButton(
        child: Text('Saved'),
        color: Theme.of(context).primaryColor,
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: () async {
          // save form
          _changePhoneNumberForm.key.currentState.save();

          // validate then submit
          if (_changePhoneNumberForm.key.currentState.validate()) {
            try {
              await _changePhoneNumberForm.submit(context);
              _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Password Saved')));
            }
            catch(e){
            }
          }
        },
      ),
    );
  }
}
