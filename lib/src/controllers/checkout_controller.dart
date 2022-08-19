import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';
import '../helpers/helper.dart';
import '../models/distance_price.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment payment;
  CreditCard creditCard = new CreditCard();
  bool loading = true;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    setState(() {});
  }
  @override
  void onLoadingCartDone() {
    if (payment != null){
      addOrder(carts);
    }
      super.onLoadingCartDone();
    }

  void addOrder(List<Cart> carts,) async {
print(carts[0].toMap());
    Order _order = new Order();
    _order.foodOrders = [];
    _order.tax = carts[0].food.restaurant.defaultTax;
      if (carts[0].food.restaurant.delivery_price_type == 'fixed') {
        _order.deliveryFee = carts[0].food.restaurant.deliveryFee.toDouble();
      }
      else if (carts[0].food.restaurant.delivery_price_type == 'distance')
        _order.deliveryFee = Helper.getDistancePriceDouble(carts[0].food.restaurant.deliveryFee,
            carts[0].food.restaurant.distanceGoogle.distance
                .value / 1000);
      else if (carts[0].food.restaurant.delivery_price_type == 'flexible')
        _order.deliveryFee = Helper.getTimePriceDouble(carts[0].food.restaurant.distanceGoogle.duration
            .value / 60, carts[0].food.restaurant.distanceGoogle.distance
                .value / 1000);
       else
        _order.deliveryFee = carts[0].food.restaurant.deliveryFee;

      _order.deliveryFee = payment.method == 'Pay on Pickup' ? 0
          :  _order.deliveryFee;
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;
    _order.deliveryCouponId =coupon.onDeliveryFee!=null&&coupon.onDeliveryFee?int.tryParse(coupon.id):null;
    _order.deliveryCouponValue = coupon.onDeliveryFee!=null&&coupon.onDeliveryFee?Helper.getCouponVul(_order.deliveryFee ,coupon):0.0;
    _order.restaurantCouponId =coupon.restaurantId!=null&&coupon.restaurantId==carts[0].food.restaurant.id?int.tryParse(coupon.id):null;
    _order.restaurantCouponValue = coupon.restaurantId!=null&&coupon.restaurantId==carts[0].food.restaurant.id?Helper.getCouponVul(subTotal ,coupon):0;
    _order.deliveryAddress = settingRepo.deliveryAddress.value;
    carts.forEach((_cart) {
      FoodOrder _foodOrder = new FoodOrder();
      _foodOrder.quantity = _cart.quantity;
      _foodOrder.price = _cart.food.price;
      _foodOrder.food = _cart.food;
      _foodOrder.extras = _cart.extras;
      _order.foodOrders.add(_foodOrder);
    });
    orderRepo.addOrder(_order, this.payment).then((value) {
      if (value is Order) {
        setState(() {
          loading = false;
          coupon= new Coupon.fromJSON({});
          Navigator.of(state.context).pushNamed('/Tracking',
              arguments: RouteArgument(id: value.id));

        });
      }
    });
  }
  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).payment_card_updated_successfully),
      ));
    });
  }

}
