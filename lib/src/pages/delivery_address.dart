
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/PermissionDeniedWidget.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/data_empty.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../models/route_argument.dart';

class DeliveryAddressWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryAddressWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryAddressesWidgetState createState() => _DeliveryAddressesWidgetState();
}

class _DeliveryAddressesWidgetState extends StateMVC<DeliveryAddressWidget> {
  DeliveryAddressesController _con;

  _DeliveryAddressesWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 8.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          S.of(context).delivery_addresses,
          style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3,color: Colors.white)),
        ),

      ),
      floatingActionButton: currentUser.value.apiToken == null
          ?SizedBox()
           :FloatingActionButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/AddAddress');
              },
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              )),
          //: SizedBox(height: 0),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : _con.loading
      ?CircularLoadingWidget(height: 500,)
      :RefreshIndicator(
        onRefresh: _con.refreshAddresses,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _con.addresses.isEmpty
                  ? DataEmpty(
                title: S.of(context).no_address,
                description:
                S.of(context).To_add_a_new_address,
                image: "assets/img/address.svg",

              )
                  :  ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 25),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: _con.addresses.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 25);
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _con.changeDeliveryAddress(_con.addresses.elementAt(index)).then((value) {
                        Navigator.of(context).pushNamed('/Pages', arguments: 1);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).focusColor),
                          child: Icon(
                            Icons.place,
                            color: Theme.of(context).primaryColor,
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 15),
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _con.addresses.elementAt(index).address,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).focusColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
