import 'package:inka_msa/forms/auth/change_phone_number.form.dart';
import 'package:flutter/material.dart';

class ChangePhoneNumberPage extends StatefulWidget {
  static const routeName = '/auth/change-phone-number';

  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  final ChangePhoneNumberForm _changePhoneNumberForm = ChangePhoneNumberForm();

  @override
  void dispose() {
    _changePhoneNumberForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah No Handphone'),
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
              'Pengubahan no handphone berarti mengubah data utama member, sehingga login berikutnya akan menggunakan no handphone baru. Kode verifikasi baru akan dikirim ke no handphone tersebut.',
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
        key: _changePhoneNumberForm.key,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: _changePhoneNumberForm.errors,
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
              onSaved: (val) =>
                  _changePhoneNumberForm.fields['phoneNumber'] = val,
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
          _changePhoneNumberForm.key.currentState.save();

          // validate then submit
          if (_changePhoneNumberForm.key.currentState.validate()) {
            await _changePhoneNumberForm.submit(context);
          }
        },
      ),
    );
  }
}
