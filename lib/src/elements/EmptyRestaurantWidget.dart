import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class EmptyRestaurantWidget extends StatefulWidget {
  EmptyRestaurantWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyNotificationsWidgetState createState() => _EmptyNotificationsWidgetState();
}

class _EmptyNotificationsWidgetState extends State<EmptyRestaurantWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App(context).appHeight(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/img/driver.png',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 15),
              Text(
                S.of(context).We_have_not_reached_your_area_yet,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
              ),
              SizedBox(height: 10),
              Opacity(
                opacity: 0.4,
                child: Text(
                  S.of(context).but_we_are_still_working_on_expanding_our_service,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              SizedBox(height: 50),
               FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/DeliveryAddresses');
                      },
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      color: Theme.of(context).hintColor,
                      shape: StadiumBorder(),
                      child: Text(
                        S.of(context).change_address,
                        style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                    )

            ],
          ),
        ),
      ],
    );
  }
}
