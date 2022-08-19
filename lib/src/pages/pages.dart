import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/sabek_icons.dart';
import '../repository/settings_repository.dart';

import '../elements/DrawerWidget.dart';
import '../elements/FilterWidget.dart';
import '../models/route_argument.dart';
import '../pages/home.dart';
import '../pages/orders.dart';
import 'messages.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 1;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      bottomIndex.value = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage =
              OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage =
              HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;

        case 2:
          widget.currentPage = MessagesWidget(
              parentScaffoldKey: widget
                  .scaffoldKey); //FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: DrawerWidget(),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
        currentIndex: widget.currentTab,
        onTap: (int i) {
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(SabekIcons.fast_food),
            label: '',
          ),
          BottomNavigationBarItem(
              label: '',
              icon: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 40,
                        offset: Offset(0, 15)),
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 13,
                        offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(SabekIcons.home,
                    size: MediaQuery.of(context).size.width * 0.05,
                    color: Theme.of(context).primaryColor),
              )),
          BottomNavigationBarItem(
            icon: new Icon(SabekIcons.messenger),
            label: '',
          ),
        ],
      ),
    );
  }
}
