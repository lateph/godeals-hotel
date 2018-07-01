import 'package:flutter/material.dart';
import 'package:inka_msa/bloc/app.bloc.dart';
import 'package:inka_msa/pages/profile.edit.page.dart';
import 'package:inka_msa/pages/profile.password.page.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final AssetImage _logoImage = AssetImage('assets/images/msa.png');
  AssetImage background = AssetImage('assets/images/home.jpg');

  void _select(String choice) async {
    AppBloc appBloc = AppBlocProvider.of(context);
    // Causes the app to rebuild with the new _selectedChoice.
    if(choice == 'Logout'){
      await appBloc.auth.logout(context);
    }
    if(choice == 'EditProfile'){
      Navigator.of(context).pushNamed(EditProfilePage.routeName);
    }
    if(choice == 'ChangePassword'){
      Navigator.of(context).pushNamed(EditPasswordPage.routeName);
    }
  }


  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = AppBlocProvider.of(context);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Profile"),
        actions: <Widget>[
          new PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: _select,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                    value: 'EditProfile',
                    child: const ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit Profile')
                    )
                ),
                const PopupMenuItem<String>(
                    value: 'ChangePassword',
                    child: const ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text('ChangePassword')
                    )
                ),
                const PopupMenuDivider(), // ignore: list_element_type_not_assignable, https://github.com/flutter/flutter/issues/5771
                const PopupMenuItem<String>(
                    value: 'Logout',
                    child: const ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Logout')
                    )
                )
              ]
          ),
        ],
      ),
      body: new SafeArea(
        child: new CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 250.0,
              pinned: false,
//              title: new Text("Go Deals"),
              flexibleSpace: new FlexibleSpaceBar(
//              title: const Text("Order Summary"),
//              background: new Image.asset("images/restaurant.jpg",fit: BoxFit.cover),
//              centerTitle: true,
                  background: new Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: background,
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                          const Color.fromRGBO(255, 255, 255, 0.7),
                          BlendMode.luminosity,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 0.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(
                            top: 24.0,
                            bottom: 24.0,
                          ),
                          child: Center(
                            child: new Container(
                              height: 150.0,
                              width: 150.0,
                              padding: const EdgeInsets.all(20.0),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(200.0)
                              ),
                              child: Image(
                                image: _logoImage,
                                width: 150.0,
                              ),
                            )

                          ),
                        ),
//                        new Text("nama"),
//                        new Text("email")
                      ],
                    ),
                  )
              ),
            ),
            StreamBuilder(
              stream: appBloc.auth.status,
              builder: (context, snapshot) {
                return SliverList(delegate:
                new SliverChildListDelegate([
                  new Divider(),
                  new ListTile(
                    title: new Text(appBloc.auth.memberState.name),
                    leading: new Icon(Icons.account_circle),
//                    trailing: new Icon(Icons.chevron_right),
                  ),
                  new Divider(),
                  new ListTile(
                    title: new Text(appBloc.auth.memberState.email),
                    leading: new Icon(Icons.email),
//                    trailing: new Icon(Icons.chevron_right),
                  ),
                ]));
              }
            ),
          ],
        )
      )
    );
  }
}