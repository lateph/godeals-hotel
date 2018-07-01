import 'package:inka_msa/forms/auth/reset_password.form.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  static const String routeName = '/auth/reset-password';

  final String phoneNumber;

  ResetPasswordPage(this.phoneNumber, {Key key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ResetPasswordForm _resetPasswordForm = ResetPasswordForm();

  @override
  void dispose() {
    _resetPasswordForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildInstruction(context),
            _buildResetPasswordForm(context),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction(BuildContext context) {
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
          text: 'Kode pengubahan password telah dikirimkan ke no ',
          style: Theme.of(context).textTheme.body1,
          children: <TextSpan>[
            TextSpan(
              text: widget.phoneNumber,
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
            ),
            TextSpan(
                text:
                    '. Masukkan kode tersebut ke kolom di bawah ini, lalu diikuti dengan password baru.'),
          ],
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 24.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Form(
        key: _resetPasswordForm.key,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _resetPasswordForm.errors,
          builder: (context, snapshot) {
            print("Has data: " + snapshot.hasData.toString());
            print("Error data: " + snapshot.data.toString());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Kode Password Sementara',
                    errorText: snapshot.hasData
                        ? snapshot.data['code']?.join(', ')
                        : null,
                  ),
                  maxLength: 10,
                  onSaved: (val) => _resetPasswordForm.fields['code'] = val,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Password Baru',
                    errorText: snapshot.hasData
                        ? snapshot.data['newPassword']?.join(', ')
                        : null,
                  ),
                  onSaved: (val) =>
                      _resetPasswordForm.fields['newPassword'] = val,
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
        child: Text('KIRIM'),
        color: Theme.of(context).primaryColor,
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
        onPressed: () async {
          // save form
          _resetPasswordForm.key.currentState.save();

          // validate then submit
          if (_resetPasswordForm.key.currentState.validate()) {
            _resetPasswordForm.fields['phoneNumber'] = widget.phoneNumber;
            await _resetPasswordForm.submit(context);
          }
        },
      ),
    );
  }
}
