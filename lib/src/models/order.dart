import 'coupon.dart';

import '../helpers/custom_trace.dart';
import '../models/address.dart';
import '../models/food_order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';

class Order {
  String id;
  String driver_id;
  List<FoodOrder> foodOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  String hint;
  String reason;
  int processingTime;
  int deliveryCouponId;
  int restaurantCouponId;
  double deliveryCouponValue;
  double restaurantCouponValue;
  bool active;
  DateTime dateTime;
  User user;
  User driver;
  Coupon restaurantCoupon;
  Coupon deliveryCoupon;
  Payment payment;
  Address deliveryAddress;

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      driver_id = jsonMap['driver_id'].toString();
      processingTime = jsonMap['processing_time']!= null ? jsonMap['processing_time'] : null;
      deliveryCouponId = jsonMap['delivery_coupon_id']!= null ? jsonMap['delivery_coupon_id'] : null;
      restaurantCouponId = jsonMap['restaurant_coupon_id']!= null ? jsonMap['restaurant_coupon_id'] : null;
      deliveryCouponValue = jsonMap['delivery_coupon_value'] != null ? jsonMap['delivery_coupon_value'].toDouble() : 0.0;
      restaurantCouponValue = jsonMap['restaurant_coupon_value'] != null ? jsonMap['restaurant_coupon_value'].toDouble() : 0.0;
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
      hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';
      reason = jsonMap['reason'] != null ? jsonMap['reason'].toString() : '';
      active = jsonMap['active'] ?? false;
      orderStatus = jsonMap['order_status'] != null ? OrderStatus.fromJSON(jsonMap['order_status']) : OrderStatus.fromJSON({});
      dateTime = DateTime.parse(jsonMap['updated_at']);
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : User.fromJSON({});
      driver = jsonMap['driver'] != null
          ? User.fromJSON(jsonMap['driver'])
          : User.fromJSON({});
      restaurantCoupon = jsonMap['restaurant_coupon'] != null
          ? Coupon.fromJSON(jsonMap['restaurant_coupon'])
          : Coupon.fromJSON({});
      deliveryCoupon = jsonMap['delivery_coupon'] != null
          ? Coupon.fromJSON(jsonMap['delivery_coupon'])
          : Coupon.fromJSON({});
      deliveryAddress = jsonMap['delivery_address'] != null ? Address.fromJSON(jsonMap['delivery_address']) : Address.fromJSON({});
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : Payment.fromJSON({});
      foodOrders = jsonMap['food_orders'] != null ? List.from(jsonMap['food_orders']).map((element) => FoodOrder.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      driver_id = '';
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      reason = '';
      active = false;
      orderStatus = OrderStatus.fromJSON({});
      dateTime = DateTime(0);
      user = User.fromJSON({});
      driver = User.fromJSON({});
      payment = Payment.fromJSON({});
      deliveryAddress = Address.fromJSON({});
      foodOrders = [];
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["delivery_coupon_id"] = deliveryCouponId;
    map["delivery_coupon_value"] = deliveryCouponValue;
    map["restaurant_coupon_id"] = restaurantCouponId;
    map["restaurant_coupon_value"] = restaurantCouponValue;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map['hint'] = hint;
    map["delivery_fee"] = deliveryFee;
    map["foods"] = foodOrders?.map((element) => element.toMap())?.toList();
    map["payment"] = payment?.toMap();
    if (!deliveryAddress.isUnknown()) {
      map["delivery_address_id"] = deliveryAddress?.id;
    }
    return map;
  }

  Map cancelMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = '110';
    map["active"] = false;
    return map;
  }

  bool canCancelOrder() {
    return this.orderStatus.key== 'order_received' ||
        this.orderStatus.key== 'waiting_for_restaurant';// 1 for order received status
  }
  bool reOrder() {
    return this.orderStatus.id== '80';// 1 for order received status
  }
  bool canShowProcessingTime() {
    return this.orderStatus.key== 'accepted_from_restaurant' ||
     this.orderStatus.key== 'driver_assigned' ||
     this.orderStatus.key== 'driver_arrived_restaurant' ||
     this.orderStatus.key== 'driver_pick_up' ||
        this.orderStatus.key== 'waiting_for_drivers';// 1 for order received status
  }
  bool showDriveOnMap() {
    return this.orderStatus.key== 'driver_assigned' ||
     this.orderStatus.key== 'driver_arrived_restaurant' ||
        this.orderStatus.key== 'driver_pick_up' ||
        this.orderStatus.key== 'on_the_way' ||
        this.orderStatus.key== 'driver_arrived' ;// 1 for order received status
  }
  bool showOrderState(id) {
    return id== '1' ||
        id== '10' ||
        id== '20' ||
        id== '40' ||
        id== '45' ||
        id== '50' ||
        id== '60' ||
        id== '30' ||
        id== '70' ||
        id== '80' ;// 1 for order received status
  }
  bool showOrderStateWithOutCancel(orderstatus) {
    return orderstatus.key== 'canceled_restaurant_did_not_accept' ||
        orderstatus.key== 'canceled_from_customer' ||
        orderstatus.key== 'canceled_no_drivers_available' ||
        orderstatus.key== 'canceled_from_restaurant' ||
        orderstatus.key== 'canceled_from_driver' ||
        orderstatus.key== 'canceled_from_company' ;// 1 for order received status
  }
}
