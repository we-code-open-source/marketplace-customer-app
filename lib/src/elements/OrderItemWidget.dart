import 'package:flutter/material.dart';
import '../controllers/tracking_controller.dart';
import '../models/order_noti.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/route_argument.dart';
import 'FoodOrderItemWidget.dart';

class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  final Order order;
  final ValueChanged<void> onAdded;
  final ValueChanged<void> onCanceled;

  OrderItemWidget(
      {Key key, this.expanded, this.order, this.onAdded, this.onCanceled})
      : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends StateMVC<OrderItemWidget> {
  TrackingController _con;

  _OrderItemWidgetState() : super(TrackingController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrderNotification(id: widget.order.id);
    _con.listenForOrder(orderId: widget.order.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: widget.order.active ? 1 : 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 14),
                padding: EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title:
                        Text('${S.of(context).order_id}: #${widget.order.id}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Helper.getPrice(
                            Helper.getTotalOrdersPrice(widget.order), context,
                            style: Theme.of(context).textTheme.headline4),
                        Text(
                          '${S.of(context).cash_on_delivery}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    children: <Widget>[
                      Column(
                          children: List.generate(
                        widget.order.foodOrders.length,
                        (indexFood) {
                          return FoodOrderItemWidget(
                              heroTag: 'mywidget.orders',
                              order: widget.order,
                              foodOrder:
                                  widget.order.foodOrders.elementAt(indexFood));
                        },
                      )),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).delivery_fee,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(
                                    Helper.getDeliveryOrdersPrice(widget.order),
                                    context,
                                    style:
                                        Theme.of(context).textTheme.headline4)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).total,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(
                                    Helper.getTotalOrdersPrice(widget.order),
                                    context,
                                    style:
                                        Theme.of(context).textTheme.headline4),
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
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Tracking',
                            arguments: RouteArgument(id: widget.order.id));
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text(S.of(context).view)],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    widget.order.reOrder()
                        ? FlatButton(
                            onPressed: () {
                              widget.onAdded(widget.order);
                            },
                            textColor: Theme.of(context).hintColor,
                            child: Wrap(
                              children: <Widget>[Text(S.of(context).re_order)],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 0),
                          )
                        : SizedBox(),
                    widget.order.canCancelOrder()
                        ? FlatButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: Wrap(
                                      spacing: 10,
                                      children: <Widget>[
                                        Icon(Icons.report,
                                            color: Colors.orange),
                                        Text(
                                          S.of(context).confirmation,
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                    content: Text(S
                                        .of(context)
                                        .areYouSureYouWantToCancelThisOrder),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 25),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: new Text(
                                          S.of(context).yes,
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor),
                                        ),
                                        onPressed: () {
                                          widget.onCanceled(widget.order);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: new Text(
                                          S.of(context).close,
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            textColor: Theme.of(context).hintColor,
                            child: Wrap(
                              children: <Widget>[
                                Text(S.of(context).cancel + " ")
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
        _con.order != null || _con.orderStatus.isNotEmpty
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 28,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: widget.order.active
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
                            OrderNotification.fromJson(_docs[0].data());
                        _con.OrderStateCustom(
                            orderNotification.order_status_id.toString());
                        print('${_con.stateOrder}');
                      }
                      return _docs.length == 0
                          ? Text(
                              widget.order.active
                                  ? '${widget.order.orderStatus.status}'
                                  : S.of(context).canceled,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.caption.merge(
                                  TextStyle(
                                      height: 1,
                                      color: Theme.of(context).primaryColor)),
                            )
                          : Text(
                              widget.order.active
                                  ? '${_con.stateOrder}'
                                  : S.of(context).canceled,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.caption.merge(
                                  TextStyle(
                                      height: 1,
                                      color: Theme.of(context).primaryColor)),
                            );
                    } else {
                      return Text(
                        _con.order.active
                            ? '${widget.order.orderStatus.status}'
                            : S.of(context).canceled,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.caption.merge(
                            TextStyle(
                                height: 1,
                                color: Theme.of(context).primaryColor)),
                      );
                    }
                  },
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 28,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: widget.order.active
                        ? Theme.of(context).accentColor
                        : Colors.redAccent),
                alignment: AlignmentDirectional.center,
                child: Text(
                  widget.order.active
                      ? '${widget.order.orderStatus.status}'
                      : S.of(context).canceled,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(
                      height: 1, color: Theme.of(context).primaryColor)),
                ),
              )
      ],
    );
  }
}
