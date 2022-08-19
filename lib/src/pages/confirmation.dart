import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class ConfirmationWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  ConfirmationWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ConfirmationWidgetState createState() => _ConfirmationWidgetState();
}

class _ConfirmationWidgetState extends StateMVC<ConfirmationWidget> {
  CartController _con;

  _ConfirmationWidgetState() : super(CartController()) {
    _con = controller;
  }
  List<Cart> carts = <Cart>[];
  double total;
  double subTotal;
  TextEditingController code=new TextEditingController();
  @override
  void initState() {
   carts=widget.routeArgument.param;
   total=double.tryParse(widget.routeArgument.id);
   subTotal=double.tryParse(widget.routeArgument.heroTag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: Container(
          height: 220,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
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
                    Helper.getPrice(subTotal, context, style: Theme.of(context).textTheme.subtitle1)
                  ],
                ),
                SizedBox(height: 3),
                 Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        S.of(context).delivery_fee,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    if (carts[0].food.restaurant != null)
                      if (carts[0].food.restaurant.delivery_price_type == 'fixed')
                        Helper.getPrice(_con.carts[0].food.restaurant.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1)
                      else if (carts[0].food.restaurant.delivery_price_type == 'distance')
                        Helper.getDistancePrice(carts[0].food.restaurant.deliveryFee,
                            carts[0].food.restaurant.distanceGoogle.distance.value/1000, context,
                            style: Theme.of(context).textTheme.subtitle1)
                      else if (carts[0].food.restaurant.delivery_price_type == 'flexible' &&
                            carts[0].food.restaurant != null)
                          Helper.getTimePrice(
                              (carts[0].food.restaurant.distanceGoogle.duration.value/60),
                              (carts[0].food.restaurant.distanceGoogle.distance.value/1000), context,
                              style: Theme.of(context).textTheme.subtitle1,)
                        else
                          Helper.getPrice(0, context, style: Theme.of(context).textTheme.subtitle1)
                  ],
                ),
                SizedBox(height: 3),
                coupon!=null && coupon.id!=null
                    ?Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "${S.of(context).coupon} ",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Helper.getPrice( Helper.getPriceCoupon(_con.subTotal,_con.deliveryFee, coupon), context, style: Theme.of(context).textTheme.subtitle1),

                  ],
                )
                    :SizedBox(),
                Divider(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        S.of(context).total,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Helper.getPrice(total-Helper.getPriceCoupon(_con.subTotal,_con.deliveryFee, coupon), context, style: Theme.of(context).textTheme.headline6)
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/CashOnDelivery');
                    },
                    padding: EdgeInsets.symmetric(vertical: 14),
                    color: Theme.of(context).accentColor,
                    shape: StadiumBorder(),
                    child: Text(
                      S.of(context).confirm_payment,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),

        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();},
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).confirm_payment,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: orderReview(),
      ),
    );
  }

  Widget orderReview() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.transparent,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          child: Icon(
                        Icons.add_location,
                        color: Theme.of(context).accentColor,
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(S.of(context).delivery_address,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(deliveryAddress.value.address ?? "",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                        // SizedBox(height: 5),
                        // Container(
                        //   child: Text(deliveryAddress.value.description ?? "",
                        //       style:
                        //           TextStyle(color: Colors.grey, fontSize: 12)),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          child: Icon(
                            Icons.payment,
                            color: Theme.of(context).accentColor,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(S.of(context).payment_mode,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(S.of(context).cash_on_delivery,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          child: Icon(
                        Icons.shopping_bag,
                        color: Theme.of(context).accentColor,
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                            child: Text(S.of(context).order,
                                style: Theme.of(context).textTheme.headline6)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.only(left: 25.0),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: carts.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var cartItem = carts[i];

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                child: CachedNetworkImage(
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  imageUrl: cartItem.food.image.thumb,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/img/loading.gif',
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                                            cartItem.food.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context).textTheme.subtitle1,
                                          ),
                                          Wrap(
                                            children: List.generate(cartItem.extras.length, (index) {
                                              return Text(
                                                cartItem.extras.elementAt(index).name + ', ',
                                                style: Theme.of(context).textTheme.caption,
                                              );
                                            }),
                                          ),
                                          Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: 5,
                                            children: <Widget>[
                                               Helper.getPrice(cartItem.food.price, context,
                                                  style: Theme.of(context).textTheme.subtitle2),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),

                                  ],
                                ),
                              ),
                        Container(
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                        decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                        child:Text(' X ${cartItem.quantity.toStringAsFixed(0)} ',
                                  style: TextStyle(color: Theme.of(context).primaryColor)),
                        )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  // Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: Text(
                  //         S.of(context).subtotal,
                  //         style: Theme.of(context).textTheme.bodyText1,
                  //       ),
                  //     ),
                  //     Text(' ${subTotal}${setting.value?.defaultCurrency}',
                  //         style: Theme.of(context).textTheme.subtitle1),                    ],
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: Text(
                  //         S.of(context).delivery_fee,
                  //         style: Theme.of(context).textTheme.bodyText1,
                  //       ),
                  //     ),
                  //     if (Helper.canDelivery(carts[0].food.restaurant, carts: carts) &&carts[0].food.restaurant !=null)
                  //       if (carts[0].food.restaurant.delivery_price_type == 'fixed')
                  //         Helper.getPrice(
                  //             carts[0].food.restaurant.deliveryFee, context,
                  //             style:
                  //             Theme.of(context).textTheme.subtitle1)
                  //       else if (carts[0].food.restaurant.delivery_price_type == 'distance')
                  //         Helper.getDistancePrice(carts[0].food.restaurant.deliveryFee,
                  //             carts[0].food.restaurant.distanceGoogle.distance.value/1000, context,
                  //             style:
                  //             Theme.of(context).textTheme.subtitle1)
                  //       else if (carts[0].food.restaurant.delivery_price_type == 'flexible' )
                  //           Helper.getTimePrice(
                  //               (carts[0].food.restaurant.distanceGoogle.duration.value/60),
                  //               (carts[0].food.restaurant.distanceGoogle.distance.value/1000), context,
                  //               style: Theme.of(context).textTheme.subtitle1)
                  //         else
                  //           Helper.getPrice(0, context, style: Theme.of(context).textTheme.subtitle1)
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  //  Row(
                  //     children: <Widget>[
                  //       Expanded(
                  //         child: Text(S.of(context).total,
                  //           style: Theme.of(context).textTheme.bodyText1),
                  //       ),
                  //       Text('${total}${setting.value?.defaultCurrency}',
                  //           style: Theme.of(context).textTheme.subtitle1),
                  //     ],
                  //
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),

            Container(
              padding: const EdgeInsets.all(18),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, 2), blurRadius: 5.0)]),
              child: Row(
                children: [
                  Expanded(child: TextField(
                keyboardType: TextInputType.text,
                // onSubmitted: (String value) {
                //   _con.doApplyCoupon(value);
                // },
                cursorColor: Theme.of(context).accentColor,
                controller: code,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  suffixText: coupon?.valid == null ? '' : (coupon.valid ? S.of(context).validCouponCode : S.of(context).invalidCouponCode),
                  suffixStyle: Theme.of(context).textTheme.caption.merge(TextStyle(color: _con.getCouponIconColor())),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.confirmation_number,
                      color: _con.getCouponIconColor(),
                      size: 28,
                    ),
                  ),
                  hintText: S.of(context).haveCouponCode,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                ),
              ),
              ),

                  TextButton(
                    onPressed: ()=>_con.doApplyCoupon(code.text,carts[0].food.restaurant.id),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    child: Text(
                      "تطبيق",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
