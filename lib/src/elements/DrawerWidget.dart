import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../helpers/sabek_icons.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  FirebaseMessaging _firebaseMessaging=FirebaseMessaging();

  _DrawerWidgetState() : super(ProfileController()) {}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.apiToken != null ? Navigator.of(context).pushNamed('/Profile') : Navigator.of(context).pushNamed('/Login');
            },
            child: currentUser.value.apiToken != null
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    accountName: Text(
                      currentUser.value.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    accountEmail: Text(
                      '',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: NetworkImage(currentUser.value.image.thumb),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          SabekIcons.user1,
                          size: 32,
                          color: Theme.of(context).accentColor.withOpacity(1),
                        ),
                        SizedBox(width: 30),
                        Text(
                          S.of(context).guest,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 1);
            },
            leading: Icon(
              SabekIcons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Notification');
            },
            leading: Icon(
              SabekIcons.bell1,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).notifications,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              SabekIcons.fast_food,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).my_orders,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/DeliveryAddresses');
            },
            leading: Icon(
              SabekIcons.location,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).addresses,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Favorites');
            },
            leading: Icon(
              SabekIcons.favorite,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).favorite_foods,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              SabekIcons.messenger,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).messages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              S.of(context).application_preferences,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              SabekIcons.information,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).help__support,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context).pushReplacementNamed('/Login');
              }
            },
            leading: Icon(
              SabekIcons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).settings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              SabekIcons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                setBrightness(Brightness.light);
                setting.value.brightness.value = Brightness.light;
              } else {
                setting.value.brightness.value = Brightness.dark;
                setBrightness(Brightness.dark);
              }
              setting.notifyListeners();
            },
            leading: Icon(
              SabekIcons.night_mode,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                _firebaseMessaging.getToken().then((String _deviceToken) {
                  logout(_deviceToken).then((value) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Login', (Route<dynamic> route) => false);
                  });
                }).catchError((e) {
                  print('Notification not configured');
                });
              }else Navigator.of(context).pushNamed('/Login');
            },
            leading: Icon(
              SabekIcons.logout,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              currentUser.value.apiToken != null ? S.of(context).log_out : S.of(context).login,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),


          setting.value.enableVersion
              ? ListTile(
                  dense: true,
                  title: Text(
                    S.of(context).version + " " + (Platform.isIOS
                        ?setting.value.appVersionIOS:setting.value.appVersionAndroid),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: Icon(
                    Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
