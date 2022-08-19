import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/order_noti.dart';
import '../models/conversation.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../controllers/tracking_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodOrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class TrackingWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  TrackingWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends StateMVC<TrackingWidget>
    with SingleTickerProviderStateMixin {
  TrackingController _con;
  Completer<GoogleMapController> mapController = Completer();
  BitmapDescriptor icon;
  Set<Marker> _markers = Set<Marker>();
  List<User> drivers = new List();
  User driver;
  TabController _tabController;
  int _tabIndex = 0;

  _TrackingWidgetState() : super(TrackingController()) {
    _con = controller;
  }

  int driver_time;
  double driver_lat;
  double driver_lng;

  @override
  void initState() {
    _con.listenForDriver();
    _con.listenForOrder(orderId: widget.routeArgument.id);
    _con.listenForOrderNotification(id: widget.routeArgument.id);
    _tabController =
        TabController(length: 3, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    getIcon();
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() async {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
      if (_tabController.index == 2) {
        if ((_con.order.driver_id != 'null') && _con.order.showDriveOnMap()) {
        driver = _con.order.driver;
        CollectionReference reference =
            await FirebaseFirestore.instance.collection("drivers");
        reference.doc(driver.id).get().then((value) => setState(() {
              driver_time = value["last_access"];
              driver_lat = value["latitude"];
              driver_lng = value["longitude"];
              print(value.data());
              print(value['last_access']);
              print(value.data());

              _markers.removeWhere((m) => m.markerId.value == driver.id);
              _markers.add(Marker(
                  markerId: MarkerId(driver.id),
                  position: LatLng(driver_lat, driver_lng),
                  infoWindow: InfoWindow(
                    title: driver.name,
                    snippet: timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(driver_time),
                        locale: 'ar'),
                  ),
                  icon: icon));
              moveCameraToDriver();
            }));
        //chats.
        reference.doc(driver.id).snapshots().listen((value) {
          setState(() {
            driver_time = value["last_access"];
            driver_lat = value["latitude"];
            driver_lng = value["longitude"];
            print(value.data());
            print(value['latitude']);
            print(value.data());

            _markers.removeWhere((m) => m.markerId.value == driver.id);
            _markers.add(Marker(
                markerId: MarkerId(driver.id),
                position: LatLng(driver_lat, driver_lng),
                infoWindow: InfoWindow(
                  title: driver.name,
                  snippet: timeago.format(
                      DateTime.fromMillisecondsSinceEpoch(driver_time),
                      locale: 'ar'),
                ),
                icon: icon));
            moveCameraToDriver();
          });
        });

        Helper.getMyPositionMarker(_con.order.deliveryAddress.latitude,
                _con.order.deliveryAddress.longitude,
                lable: 'مكان التوصيل')
            .then((marker) {
          setState(() {
            _markers.add(marker);
          });
        });
        Helper.getMyPositionMarker(
                double.parse(_con.order.foodOrders[0].food.restaurant.latitude),
                double.parse(
                    _con.order.foodOrders[0].food.restaurant.longitude),
                lable: _con.order.foodOrders[0].food.restaurant.name)
            .then((marker) {
          setState(() {
            _markers.add(marker);
          });
        });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: _con.order == null || _con.orderStatus.isEmpty
            ? SizedBox()
            : _con.order.orderStatus.key == 'delivered'
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 135,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.15),
                              offset: Offset(0, -2),
                              blurRadius: 5.0)
                        ]),
                    child: _con.order == null || _con.orderStatus.isEmpty
                        ? SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                  S
                                      .of(context)
                                      .how_would_you_rate_this_restaurant,
                                  style: Theme.of(context).textTheme.subtitle1),
                              Text(
                                  S
                                      .of(context)
                                      .click_on_the_stars_below_to_leave_comments,
                                  style: Theme.of(context).textTheme.caption),
                              SizedBox(height: 5),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/Reviews',
                                      arguments: RouteArgument(
                                          id: _con.order.id,
                                          heroTag: "restaurant_reviews"));
                                },
                                padding: EdgeInsets.symmetric(vertical: 5),
                                shape: StadiumBorder(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: Helper.getStarsList(
                                      double.parse(_con.order.foodOrders[0].food
                                          .restaurant.rate),
                                      size: 35),
                                ),
                              ),
                            ],
                          ))
                : SizedBox(height: 0),
        body: _con.order == null || _con.orderStatus.isEmpty
            ? CircularLoadingWidget(height: 500)
            : CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  snap: true,
                  floating: true,
                  centerTitle: true,
                  title: Text(
                    S.of(context).orderDetails,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .merge(TextStyle(letterSpacing: 1.3)),
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  bottom: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.symmetric(horizontal: 15),
                      unselectedLabelColor: Theme.of(context).accentColor,
                      labelColor: Theme.of(context).primaryColor,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).accentColor),
                      tabs: [
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                    width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(S.of(context).details),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                    width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(S.of(context).tracking_order),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                    width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(S.of(context).driver),
                            ),
                          ),
                        ),
                      ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Offstage(
                      offstage: 0 != _tabIndex,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            Opacity(
                              opacity: _con.order.active ? 1 : 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 14),
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.9),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.1),
                                            blurRadius: 5,
                                            offset: Offset(0, 2)),
                                      ],
                                    ),
                                    child: Theme(
                                      data: theme,
                                      child: ExpansionTile(
                                        initiallyExpanded: true,
                                        title: Text(
                                            '${S.of(context).order_id}: #${_con.order.id}'),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Helper.getPrice(
                                                Helper.getTotalOrdersPrice(
                                                    _con.order),
                                                context,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4),
                                            Text(
                                              '${S.of(context).cash_on_delivery}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            )
                                          ],
                                        ),
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    '${S.of(context).you_can_contact}  ${_con.order.foodOrders[0].food.restaurant.name}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 42,
                                                  height: 42,
                                                  child: FlatButton(
                                                    padding: EdgeInsets.all(0),
                                                    disabledColor:
                                                        Theme.of(context)
                                                            .focusColor
                                                            .withOpacity(0.5),
                                                    onPressed:
                                                        currentUser.value
                                                                    .apiToken !=
                                                                null
                                                            ? () {
                                                                Navigator.of(context).pushNamed(
                                                                    '/Chat',
                                                                    arguments: RouteArgument(
                                                                        param: new Conversation(
                                                                            _con.order.foodOrders[0].food.restaurant.users.map((e) {
                                                                              e.image = _con.order.foodOrders[0].food.restaurant.image;
                                                                              return e;
                                                                            }).toList(),
                                                                            name: _con.order.foodOrders[0].food.restaurant.name)));
                                                              }
                                                            : null,
                                                    child: Icon(
                                                      Icons.chat,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 24,
                                                    ),
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.9),
                                                    shape: StadiumBorder(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                              children: List.generate(
                                            _con.order.foodOrders.length,
                                            (indexFood) {
                                              return FoodOrderItemWidget(
                                                  heroTag: 'my_order',
                                                  order: _con.order,
                                                  foodOrder: _con
                                                      .order.foodOrders
                                                      .elementAt(indexFood));
                                            },
                                          )),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .delivery_fee,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                    Helper.getPrice(
                                                        Helper
                                                            .getDeliveryOrdersPrice(
                                                                _con.order),
                                                        context,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4)
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        S.of(context).subtotal,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                    Helper.getPrice(
                                                        Helper
                                                            .getSubTotalOrdersPrice(
                                                                _con.order),
                                                        context,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1)
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Text(
                                                        S.of(context).total,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                    Helper.getPrice(
                                                        Helper
                                                            .getTotalOrdersPrice(
                                                                _con.order),
                                                        context,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      children: <Widget>[
                                        _con.order.canCancelOrder()
                                            ? FlatButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      // return object of type Dialog
                                                      return AlertDialog(
                                                        title: Wrap(
                                                          spacing: 10,
                                                          children: <Widget>[
                                                            Icon(Icons.report,
                                                                color: Colors
                                                                    .orange),
                                                            Text(
                                                              S
                                                                  .of(context)
                                                                  .confirmation,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Text(S
                                                            .of(context)
                                                            .areYouSureYouWantToCancelThisOrder),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        30,
                                                                    vertical:
                                                                        25),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: new Text(
                                                              S.of(context).yes,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor),
                                                            ),
                                                            onPressed: () {
                                                              _con.doCancelOrder();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: new Text(
                                                              S
                                                                  .of(context)
                                                                  .close,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                textColor:
                                                    Theme.of(context).hintColor,
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Text(
                                                        S
                                                                .of(context)
                                                                .cancelOrder +
                                                            " ",
                                                        style: TextStyle(
                                                            height: 1.3)),
                                                    Icon(Icons.clear)
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 28,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: _con.order.active
                                      ? Theme.of(context).accentColor
                                      : Colors.redAccent),
                              alignment: AlignmentDirectional.center,
                              child: StreamBuilder(
                                stream: _con.OrderNoti,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var _docs = snapshot.data.documents;
                                    print('length : ${_docs.length}');
                                    if (_docs.length != 0) {
                                      OrderNotification orderNotification =
                                          OrderNotification.fromJson(
                                              _docs[0].data());
                                      _con.OrderStateCustom(orderNotification
                                          .order_status_id
                                          .toString());
                                      print('${_con.stateOrder}');
                                    }
                                    return _docs.length == 0
                                        ? Text(
                                            _con.order.active
                                                ? '${_con.order.orderStatus.status}'
                                                : S.of(context).canceled,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    height: 1,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          )
                                        : Text(
                                            _con.order.active
                                                ? '${_con.stateOrder}'
                                                : S.of(context).canceled,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    height: 1,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          );
                                  } else {
                                    return Text(
                                      _con.order.active
                                          ? '${_con.order.orderStatus.status}'
                                          : S.of(context).canceled,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(
                                              height: 1,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                        offstage: 1 != _tabIndex,
                        child: _con.order.orderStatus.id == '80'
                            ? Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Center(
                                  child: Text(
                                    "لقد تم توصيل هذا الطلب",
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                ),
                              )
                            : StreamBuilder(
                                stream: _con.OrderNoti,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var _docs = snapshot.data.documents;
                                    print('length : ${_docs.length}');
                                    print('length : ${_docs.length}');
                                    return ListView.separated(
                                        itemCount: _docs.length,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 7);
                                        },
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, index) {
                                          OrderNotification orderNotification =
                                              OrderNotification.fromJson(
                                                  _docs[index].data());
                                          _con.sortOrderState(orderNotification
                                              .order_status_id
                                              .toString());
                                          return !_con.order.showOrderState(
                                                      orderNotification
                                                          .order_status_id
                                                          .toString()) &&
                                                  !(_con.order.orderStatus.id
                                                          .toString() ==
                                                      '120')
                                              ? Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2,
                                                  child: Center(
                                                    child: Text(
                                                      "لقد تم الغاء هذا الطلب",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline2,
                                                    ),
                                                  ),
                                                )
                                              : _con.order.orderStatus.id
                                                          .toString() ==
                                                      '120'
                                                  ? Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                      child: Center(
                                                        child: Text(
                                                          _con.order.reason,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline2,
                                                        ),
                                                      ),
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        _con.order.processingTime !=
                                                                    null &&
                                                                _con.order
                                                                    .canShowProcessingTime()
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(16),
                                                                child: Container(
                                                                    height: 50,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).accentColor),
                                                                    child: Center(
                                                                        child: Text('${S.of(context).processing_time}${_con.order.processingTime.toString()} ${S.of(context).minute}',
                                                                            style: Theme.of(context).textTheme.caption.merge(
                                                                                  TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
                                                                                )))))
                                                            : SizedBox(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: Theme(
                                                            data: ThemeData(
                                                              primaryColor: Theme
                                                                      .of(context)
                                                                  .accentColor,
                                                            ),
                                                            child: Stepper(
                                                              physics:
                                                                  ClampingScrollPhysics(),
                                                              controlsBuilder: (BuildContext
                                                                      context,
                                                                  {VoidCallback
                                                                      onStepContinue,
                                                                  VoidCallback
                                                                      onStepCancel}) {
                                                                return SizedBox(
                                                                    height: 0);
                                                              },
                                                              steps: _con
                                                                  .getTrackingSteps(
                                                                      context),
                                                              currentStep: 0,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 30)
                                                      ],
                                                    );
                                        });
                                  } else {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Center(
                                        child: Text(
                                          "لقد تم الغاء هذا الطلب",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )),
                    Offstage(
                      offstage: 2 != _tabIndex,
                      child: Center(
                        child: driver != null
                            ? Column(
                                children: [
                                  SizedBox(height: 20),
                                  Container(
                                    height: 500.0,
                                    child: Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: <Widget>[
                                        GoogleMap(
                                          myLocationEnabled: true,
                                          mapType: MapType.normal,
                                          initialCameraPosition: CameraPosition(
                                            target: (driver_lng != null &&
                                                    driver_lat != null)
                                                ? LatLng(driver_lat, driver_lng)
                                                : LatLng(32.222, 13.333),
                                            zoom: 14,
                                          ),
                                          markers: _markers,
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            mapController.complete(controller);
                                          },
                                        ),
                                        Container(
                                          width: 350,
                                          height: 60,
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 10,
                                              bottom: 10),
                                          margin: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15,
                                              bottom: 15),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .focusColor
                                                      .withOpacity(0.1),
                                                  blurRadius: 15,
                                                  offset: Offset(0, 5)),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  child: driver != null
                                                      ? Text(
                                                          driver.name +
                                                              "\n" +
                                                              '${S.of(context).last_seen}  ${driver_time != null ? timeago.format(DateTime.fromMillisecondsSinceEpoch(driver_time), locale: 'ar') : ""}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        )
                                                      : Text('')),
                                              SizedBox(width: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, left: 4.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: FlatButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      moveCameraToDriver();
                                                    },
                                                    child: Icon(
                                                      Icons.my_location,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 20,
                                                    ),
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.9),
                                                    shape: StadiumBorder(),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, left: 4.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: FlatButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      launch("tel:" +
                                                          '0' +
                                                          driver.phone_number);
                                                    },
                                                    child: Icon(
                                                      Icons.call,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 20,
                                                    ),
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.9),
                                                    shape: StadiumBorder(),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0, left: 4.0),
                                                child: SizedBox(
                                                  width: 32,
                                                  height: 32,
                                                  child: FlatButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: currentUser.value
                                                                .apiToken !=
                                                            null
                                                        ? () {
                                                            drivers.add(driver);
                                                            Navigator.of(context).pushNamed(
                                                                '/Chat',
                                                                arguments: RouteArgument(
                                                                    param: new Conversation(
                                                                        drivers.map((e) {
                                                                          e.image =
                                                                              driver.image;
                                                                          return e;
                                                                        }).toList(),
                                                                        name: driver.name)));
                                                          }
                                                        : null,
                                                    child: Icon(
                                                      Icons.chat,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 20,
                                                    ),
                                                    color: Theme.of(context)
                                                        .accentColor
                                                        .withOpacity(0.9),
                                                    shape: StadiumBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Icon(
                                      Icons.directions_car,
                                      size: 120,
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.7),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      S.of(context).driver_not_available,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ]),
                )
              ]));
  }

  void getIcon() async {
    icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.5),
        'assets/img/google-maps-car-icon.png');
  }

  moveCameraToDriver() {
    if (driver_lat != null && driver_lng != null) {
      mapController.future.then((value) {
        value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(driver_lat, driver_lng),
          zoom: 16,
        )));
      });
    }
  }
}
