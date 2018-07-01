import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/forms/auth/verify_device.form.dart';
import 'package:flutter/material.dart';

class VerifyDevicePage extends StatefulWidget {
  static const String routeName = '/auth/verify-device';

  @override
  _VerifyDevicePageState createState() => new _VerifyDevicePageState();
}

class _VerifyDevicePageState extends State<VerifyDevicePage> {
  final VerifyDeviceForm _verifyDeviceForm = VerifyDeviceForm();

  @override
  void dispose() {
    _verifyDeviceForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifikasi Perangkat'),
        leading: null,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildInstructionText(context),
            _buildCodeInput(context),
            _buildSubmitButton(context),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 24.0,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        softWrap: true,
        text: TextSpan(
          text:
              'Anda terdeteksi menggunakan perangkat baru, sehingga harus melakukan verifikasi. Kode verifikasi telah dikirimkan ke no handphone [',
          style: Theme.of(context).textTheme.body1.copyWith(),
          children: <TextSpan>[
            TextSpan(
              text: appBloc.auth.memberState.attributes['phoneNumber'],
              style: Theme.of(context).textTheme.body1.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextSpan(text: ']. Masukkan 6 digit kode pada form bawah ini.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: _verifyDeviceForm.errors,
            builder: (context, snapshot) {
              print("Has data: " + snapshot.hasData.toString());
              print("Error data: " + snapshot.data.toString());

              if (snapshot.hasData && snapshot.data['code'] != null) {
                return Text(
                  snapshot.data['code']?.join(),
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).errorColor,
                      ),
                );
              } else {
                return Container();
              }
            },
          ),
          Container(
            child: Form(
              key: _verifyDeviceForm.key,
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                onSaved: (val) => _verifyDeviceForm.fields['code'] = val,
              ),
            ),
            constraints: new BoxConstraints(
              maxWidth: 80.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 24.0,
      ),
      child: RaisedButton(
        onPressed: () async {
          _verifyDeviceForm.key.currentState.save();

          if (_verifyDeviceForm.key.currentState.validate()) {
            await _verifyDeviceForm.submit(context);
          }
        },
        child: Text('KIRIM'),
        color: Theme.of(context).primaryColor,
        textTheme: ButtonTextTheme.primary,
        elevation: 0.0,
        highlightElevation: 0.0,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);

    return Container(
      margin: const EdgeInsets.only(
        top: 100.0,
        bottom: 24.0,
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlineButton(
            child: Text('Kirim Ulang'),
            textColor: Colors.red.shade700,
            highlightedBorderColor: Colors.red.shade700,
            borderSide: BorderSide(
              color: Colors.red.shade700,
            ),
            onPressed: () async {
              await _verifyDeviceForm.resend(context);
            },
            highlightElevation: 0.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 70.0,
            ),
            alignment: Alignment.center,
            child: FlatButton(
              child: Text('Keluar'),
              textColor: Colors.red.shade500,
              onPressed: () async {
                await appBloc.auth.logout(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
