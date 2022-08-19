import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/repository/settings_repository.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';

class CartBottomDetailsWidget extends StatelessWidget {
  const CartBottomDetailsWidget({
    Key key,
    @required CartController con,
  })  : _con = con,
        super(key: key);

  final CartController _con;

  @override
  Widget build(BuildContext context) {
    return _con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.15),
                      offset: Offset(0, -2),
                      blurRadius: 5.0)
                ]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).subtotal,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.subTotal, context,
                          style: Theme.of(context).textTheme.subtitle1,
                          zeroPlaceholder: '0')
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).delivery_fee,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      if (Helper.canDelivery(_con.carts[0].food.restaurant,
                              carts: _con.carts) &&
                          _con.carts[0].food.restaurant != null)
                        if (_con.carts[0].food.restaurant.delivery_price_type ==
                            'fixed')
                          Helper.getPrice(
                              _con.carts[0].food.restaurant.deliveryFee, context,
                              style: Theme.of(context).textTheme.subtitle1)
                        else if (_con.carts[0].food.restaurant.delivery_price_type ==
                            'distance')
                          Helper.getDistancePrice(
                              _con.carts[0].food.restaurant.deliveryFee,
                              _con.carts[0].food.restaurant.distanceGoogle.distance.value /
                                  1000,
                              context,
                              style: Theme.of(context).textTheme.subtitle1)
                        else if (_con.carts[0].food.restaurant.delivery_price_type ==
                            'flexible')
                          Helper.getTimePrice(
                            (_con.carts[0].food.restaurant.distanceGoogle
                                    .duration.value /
                                60),
                            (_con.carts[0].food.restaurant.distanceGoogle
                                    .distance.value /
                                1000),
                            context,
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        else
                          Helper.getPrice(0, context,
                              style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${S.of(context).total}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.total, context,
                          style: Theme.of(context).textTheme.headline4,
                          zeroPlaceholder: 'Free'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: () {
                            if (_con.total <=
                                double.tryParse(setting.value.ordersMaximum)) {
                              _con.goCheckout(context);
                            } else {
                              ScaffoldMessenger.of(
                                      _con.scaffoldKey?.currentContext)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'يجب ان يكون قيمة طلب اقل من 100 دينار'),
                              ));
                            }
                          },
                          disabledColor:
                              Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: !_con.carts[0].food.restaurant.closed
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor.withOpacity(0.5),
                          shape: StadiumBorder(),
                          child: Text(
                            S.of(context).checkout,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }
}
