import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/forms/auth/register.form.dart';
import 'package:inka_msa/helpers/background_decoration.dart';
import 'package:inka_msa/pages/auth/login.page.dart';
import 'package:inka_msa/pages/static/terms_condition.page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/auth/register';

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AssetImage _logoImage = AssetImage('assets/images/logo.png');

  final RegisterForm _registerForm = RegisterForm();

  @override
  void dispose() {
    _registerForm.dispose();
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
                _buildLogo(context),
                _buildRegisterForm(context),
                _buildTermsAndConditions(context),
                _buildRegisterButton(context),
                _buildHasAccountBlock(context),
                _buildAppVersion(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Logo AksaraPay
  /// TODO: get logo from URL, based on partner data
  Widget _buildLogo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
      ),
      child: Center(
        child: Image(
          image: _logoImage,
          width: 150.0,
        ),
      ),
    );
  }

  /// Register Form with the box
  Widget _buildRegisterForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 18.0,
        top: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: const Color.fromRGBO(255, 255, 255, 0.7),
      ),
      child: Form(
        key: _registerForm.key,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _registerForm.errors,
          builder: (context, snapshot) {
            print("Has data: " + snapshot.hasData.toString());
            print("Error data: " + snapshot.data.toString());
            return Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Nama Lengkap',
                    errorText:
                        snapshot.hasData ? snapshot.data['name']?.join() : null,
                  ),
                  onSaved: (val) => _registerForm.fields['name'] = val,
                ),
                Container(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'No Handphone',
                    errorText: snapshot.hasData
                        ? snapshot.data['phoneNumber']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) => _registerForm.fields['phoneNumber'] = val,
                ),
                Container(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Email',
                    errorText: snapshot.hasData
                        ? snapshot.data['email']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) => _registerForm.fields['email'] = val,
                ),
                Container(height: 8.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Password',
                    errorText: snapshot.hasData
                        ? snapshot.data['password']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) => _registerForm.fields['password'] = val,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    final TextStyle _termsAndConditionTextStyle = Theme
        .of(context)
        .textTheme
        .caption
        .copyWith(fontSize: 11.0, color: Colors.grey.shade700);

    return Container(
      margin: const EdgeInsets.only(
        top: 8.0,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: _termsAndConditionTextStyle,
          children: [
            TextSpan(
              text: 'Dengan mendaftar, saya menyetujui ',
            ),
            TextSpan(
              text: 'Syarat dan Ketentuan',
              style: _termsAndConditionTextStyle.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator
                      .of(context)
                      .pushNamed(TermsAndConditionPage.routeName);
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      child: RaisedButton(
        child: Text('DAFTAR'),
        color: Theme.of(context).primaryColor,
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: () async {
          // save form
          _registerForm.key.currentState.save();

          // validate then submit
          if (_registerForm.key.currentState.validate()) {
            await _registerForm.submit(context);
          }
        },
      ),
    );
  }

  /// has account block
  Widget _buildHasAccountBlock(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.only(bottom: 24.0, top: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Sudah punya akun?',
            style: Theme.of(context).textTheme.body1.copyWith(
                  color: const Color.fromRGBO(75, 75, 75, 0.7),
                  fontStyle: FontStyle.italic,
                  fontSize: 13.0,
                ),
          ),
          new Container(
            width: 16.0,
          ),
          new OutlineButton(
            borderSide:
                new BorderSide(color: Theme.of(context).textTheme.body1.color),
            onPressed: () {
              Navigator.of(context).pushNamed(LoginPage.routeName);
            },
            child: new Text('MASUK'),
            highlightElevation: 0.0,
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    final AppBloc appBloc = AppBlocProvider.of(context);

    return new Align(
      alignment: Alignment.center,
      child: new Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
        ),
        child: new Text('Powered by AksaraPay v' + '',
            style: Theme.of(context).textTheme.caption),
      ),
    );
  }
}
