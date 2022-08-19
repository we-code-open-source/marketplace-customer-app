import 'dart:async';

import 'package:flutter/material.dart';
import '../models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;


  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          coupon = _cart.food.applyCoupon(coupon);
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);

    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
          onLoadingCartDone();
      }
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }

    });
  }

  void onLoadingCartDone() {}

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);

    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(state.context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).the_food_was_removed_from_your_cart(_cart.food.name)),
      ));
    });
  }

  void calculateSubtotal() async {
    double cartPrice = 0;
    subTotal = 0;
    carts.forEach((cart) {
      cartPrice = cart.food.price;
      cart.extras.forEach((element) {
        cartPrice += element.price;
      });
      cartPrice *= cart.quantity;
      subTotal += cartPrice;
    });
    if (Helper.canDelivery(carts[0].food.restaurant, carts: carts)) {

    if (carts[0].food.restaurant.delivery_price_type == 'fixed') {
      deliveryFee = carts[0].food.restaurant.deliveryFee.toDouble();
    } else if (carts[0].food.restaurant.delivery_price_type == 'distance')
      deliveryFee = Helper.getDistancePriceDouble(carts[0].food.restaurant.deliveryFee,
          carts[0].food.restaurant.distanceGoogle.distance
              .value / 1000);
    else if (carts[0].food.restaurant.delivery_price_type == 'flexible')
      deliveryFee = Helper.getTimePriceDouble(carts[0].food.restaurant.distanceGoogle.duration
          .value / 60, carts[0].food.restaurant.distanceGoogle.distance
          .value / 1000);
    else
      deliveryFee = carts[0].food.restaurant.deliveryFee;
  }
    taxAmount = (subTotal + deliveryFee) * carts[0].food.restaurant.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }

  void doApplyCoupon(String code,String res, {String message}) async {
   coupon = new Coupon.fromJSON({});
    if(code.isNotEmpty){
    final Stream<Coupon> stream = await verifyCoupon(code,res);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      print(a);

    }, onDone: () {
      coupon.id==null?
       ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
         content: Text("الكوبون الذي ادخلته غير صحيح"),
       ))
          :coupon.valid!=null&&coupon.valid
          ? ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
        content: Text("تم تنفيذ الكوبون بنجاج علي هذه الطلبية اكد الدفع الان"),
      ))
      : ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
        content: Text("هذا الكوبون غير صالح"),
      ));

      listenForCarts();

    });
  }else  ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
      content: Text("الرجاء عدم ترك حقل الكوبون فارغا"),
    ));
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }
  void goCheckout(BuildContext context) {
      if (carts[0].food.restaurant.closed) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_restaurant_is_closed_),
        ));
      } else {
        Navigator.of(context).pushNamed('/Confirmation',
            arguments: RouteArgument(
              id: total.toStringAsFixed(2),
              heroTag: subTotal.toStringAsFixed(2),
              param: carts,
            ));
       // Navigator.of(context).pushNamed('/DeliveryPickup');
      }
    }
 // }

  Color getCouponIconColor() {
    print(coupon.toMap());
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(state.context).focusColor.withOpacity(0.7);
  }

}
