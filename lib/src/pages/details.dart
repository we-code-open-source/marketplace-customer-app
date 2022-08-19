import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import 'menu_list.dart';
import 'restaurant.dart';

class DetailsWidget extends StatefulWidget {
  RouteArgument routeArgument;
  dynamic currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage;

  DetailsWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  RestaurantController _con;

  _DetailsWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  initState() {
    _selectTab(widget.currentTab);
    super.initState();
  }

  @override
  void didUpdateWidget(DetailsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          _con.listenForRestaurant(id: widget.routeArgument.param).then((value) {
            setState(() {
              _con.restaurant = value as Restaurant;
              print(_con.restaurant.toMap());
              widget.currentPage = MenuWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(param: _con.restaurant));
            });
          });
          break;
        case 1:

              widget.currentPage = RestaurantWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(param: _con.restaurant));

          break;

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        bottomNavigationBar: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                onPressed: () {
                  this._selectTab(0);
                },
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: StadiumBorder(),
                color: Theme.of(context).accentColor,
                child: Wrap(
                  spacing: 10,
                  children: [
                    Icon(Icons.restaurant, color: Theme.of(context).primaryColor),
                    Text(
                      S.of(context).menu,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.store,
                  size: widget.currentTab == 1 ? 28 : 24,
                  color: widget.currentTab == 1 ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                ),
                onPressed: () {
                  this._selectTab(1);
                },
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.chat,
              //     size: widget.currentTab == 1 ? 28 : 24,
              //     color: widget.currentTab == 1 ? Theme.of(context).accentColor : Theme.of(context).focusColor,
              //   ),
              //   onPressed: () {
              //     this._selectTab(1);
              //   },
              // ),
              // IconButton(
              //   icon: Icon(
              //     Icons.directions,
              //     size: widget.currentTab == 2 ? 28 : 24,
              //     color: widget.currentTab == 2 ? Theme.of(context).accentColor : Theme.of(context).focusColor,
              //   ),
              //   onPressed: () {
              //     this._selectTab(2);
              //   },
              // ),

            ],
          ),
        ),
        body: widget.currentPage ?? CircularLoadingWidget(height: 400));
  }
}
