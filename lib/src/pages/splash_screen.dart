import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/settings_repository.dart' as sett;
import '../repository/settings_repository.dart' as settingRepo;

import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    loadData();

  }

  void loadData() {
    _con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {
        try {
          if (currentUser.value.apiToken == null) {
            Navigator.of(context).pushReplacementNamed('/Login');
          } else {
            if(sett.deliveryAddress.value?.address == null)
            {
              Navigator.of(context).pushNamed('/DeliveryAddress');
            } else
              settingRepo.versionCheck(context);
        }} catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child:Image.asset(
                'assets/img/logo.png',
                width: 150,
                fit: BoxFit.cover,
              )),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
