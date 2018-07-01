import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/forms/auth/verify_member.form.dart';
import 'package:inka_msa/pages/auth/change_phone_number.page.dart';
import 'package:flutter/material.dart';

class VerifyMemberPage extends StatefulWidget {
  static const String routeName = '/auth/verify-member';

  @override
  _VerifyMemberPageState createState() => new _VerifyMemberPageState();
}

class _VerifyMemberPageState extends State<VerifyMemberPage> {
  final VerifyMemberForm _verifyMemberForm = VerifyMemberForm();

  @override
  void dispose() {
    _verifyMemberForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifikasi Member'),
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
          text: 'Kode verifikasi telah dikirimkan ke no handphone [',
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
            stream: _verifyMemberForm.errors,
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
              key: _verifyMemberForm.key,
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                onSaved: (val) => _verifyMemberForm.fields['code'] = val,
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
          _verifyMemberForm.key.currentState.save();

          if (_verifyMemberForm.key.currentState.validate()) {
            await _verifyMemberForm.submit(context);
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
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlineButton(
                child: Text('Ubah No Handphone'),
                textColor: Colors.grey.shade500,
                highlightedBorderColor: Colors.grey.shade500,
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                ),
                onPressed: () {
                  Navigator
                      .of(context)
                      .pushNamed(ChangePhoneNumberPage.routeName);
                },
                highlightElevation: 0.0,
              ),
              OutlineButton(
                child: Text('Kirim Ulang'),
                textColor: Colors.red.shade700,
                highlightedBorderColor: Colors.red.shade700,
                borderSide: BorderSide(
                  color: Colors.red.shade700,
                ),
                onPressed: () async {
                  await _verifyMemberForm.resend(context);
                },
                highlightElevation: 0.0,
              ),
            ],
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
