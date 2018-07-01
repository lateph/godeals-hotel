import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/forms/auth/change_phone_number.form.dart';
import 'package:flutter/material.dart';
import 'package:inka_msa/forms/profile/edit_profile.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = '/profile/edit-profile';

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final EditProfileForm _changePhoneNumberForm = EditProfileForm();
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
    AppBloc appBloc = AppBlocProvider.of(context);
    _changePhoneNumberForm.fields['name'] = appBloc.auth.memberState.name;
    _changePhoneNumberForm.fields['email'] = appBloc.auth.memberState.email;
    print('diceluk');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Profile'),
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
                  initialValue:  _changePhoneNumberForm.fields['name'],
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Name',
                    errorText: snapshot.hasData
                        ? snapshot.data['name']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) {
                    _changePhoneNumberForm.fields['name'] = val;
                  }
                ),
                TextFormField(
                  initialValue:  _changePhoneNumberForm.fields['email'],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Email',
                    errorText: snapshot.hasData
                        ? snapshot.data['email']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) =>
                  _changePhoneNumberForm.fields['email'] = val,
                ),
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
        child: Text('Save'),
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
              _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(content: new Text('Profile Saved')));
            }
            catch(e){

            }
          }
        },
      ),
    );
  }
}
