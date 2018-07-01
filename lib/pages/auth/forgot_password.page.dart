import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/forms/auth/forgot_password.form.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String routeName = '/auth/forgot-password';

  @override
  _ForgotPasswordPageState createState() => new _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ForgotPasswordForm _forgotPasswordForm = ForgotPasswordForm();

  @override
  void dispose() {
    _forgotPasswordForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildInstructionText(context),
            _buildForgotPasswordForm(context),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);

    return Container(
      margin: const EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        softWrap: true,
        text: TextSpan(
          text:
              'Masukkan no handphone yang anda gunakan untuk mendaftar di ${appBloc
              .app
              .name}. SMS berisi kode password sementara akan dikirimkan ke nomer anda.',
          style: Theme.of(context).textTheme.body1,
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
        key: _forgotPasswordForm.key,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _forgotPasswordForm.errors,
          builder: (context, snapshot) {
            print("Has data: " + snapshot.hasData.toString());
            print("Error data: " + snapshot.data.toString());
            return TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'No Handphone',
                errorText: snapshot.hasData
                    ? snapshot.data['phoneNumber']?.join(', ')
                    : null,
              ),
              onSaved: (val) => _forgotPasswordForm.fields['phoneNumber'] = val,
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
        child: Text('KIRIM'),
        color: Theme.of(context).primaryColor,
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: () async {
          // save form
          _forgotPasswordForm.key.currentState.save();

          // validate then submit
          if (_forgotPasswordForm.key.currentState.validate()) {
            await _forgotPasswordForm.submit(context);
          }
        },
      ),
    );
  }
}
