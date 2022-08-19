import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/order_status_local.dart';
import '../repository/user_repository.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../repository/order_repository.dart';

class TrackingController extends ControllerMVC {
  Order order;
  List<OrderStatus> orderStatus = <OrderStatus>[];
  OrderStatusLocalList orderStatusLocalList;

  GlobalKey<ScaffoldState> scaffoldKey;
  Stream<QuerySnapshot> OrderNoti;
  bool check = false;
  dynamic driver;
  String stateOrder;

  TrackingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    orderStatusLocalList = new OrderStatusLocalList();
  }

  listenForOrderNotification({id}) async {
    getOrderNotification(id).then((snapshots) {
      setState(() {
        OrderNoti = snapshots;
      });
    });
  }

  listenForDriver() async {
    getUserDriver(currentUser.value.id).then((snapshots) {
      setState(() {
        driver = snapshots;
      });
    });
  }

  void listenForOrder({String orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
      });
    }, onError: (a) {
      print(a);
    }, onDone: () {
      listenForOrderStatus();
      sortOrderState(order.orderStatus);
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void sortOrderState(orderStatusId) {
    print(orderStatusId);
    int index = 0;
    orderStatusLocalList.list.forEach((item) {
      if (orderStatusId == '10') orderStatusId = '40';
      if (item.id == orderStatusId) {
        index = item.index;
      }
    });
    orderStatusLocalList.list.forEach((item) {
      if (orderStatusId == '10') orderStatusId = '40';
      if (index >= item.index) {
        item.check = true;
      } else
        item.check = false;
    });
  }

  void OrderStateCustom(orderStatusId) {
    print(orderStatusId);
    orderStatusLocalList.list.forEach((item) {
      if (orderStatusId == '10') orderStatusId = '40';
      if (item.id == orderStatusId) {
        stateOrder = item.status;
      }
    });
  }

  void listenForOrderStatus() async {
    final Stream<OrderStatus> stream = await getOrderStatus();
    stream.listen((OrderStatus _orderStatus) {
      setState(() {
        orderStatus.add(_orderStatus);
      });
    }, onError: (a) {}, onDone: () {});
  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _orderStatusSteps = [];
    this.orderStatusLocalList.list.forEach((OrderStatusLocal _orderStatus) {
      if (!order.showOrderStateWithOutCancel(_orderStatus))
        _orderStatusSteps.add(Step(
          state: StepState.complete,
          title: Text(
            _orderStatus.status,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(
              width: double.infinity,
              child: Text(
                '${Helper.skipHtml(order.hint)}',
              )),
          isActive: _orderStatus.check,
        ));
    });
    return _orderStatusSteps;
  }

  Future<void> refreshOrder() async {
    order = new Order();
    listenForOrder(message: S.of(state.context).tracking_refreshed_successfuly);
  }

  void doCancelOrder() {
    cancelOrder(this.order).then((value) {
      setState(() {
        this.order.active = false;
      });
    }).catchError((e) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e),
      ));
    }).whenComplete(() {
      orderStatus = [];
      listenForOrderStatus();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(
            S.of(state.context).orderThisorderidHasBeenCanceled(this.order.id)),
      ));
    });
  }

  bool canCancelOrder(Order order) {
    return order.active == true && order.orderStatus.id == 1;
  }
}
