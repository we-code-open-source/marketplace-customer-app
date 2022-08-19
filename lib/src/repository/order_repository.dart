import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_repository.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Order>> getOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}orders?${_apiToken}with=user;deliveryCoupon;restaurantCoupon;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id};for_restaurants:${isRestaurant.value}&searchFields=user.id:=;for_restaurants:=&orderBy=id&sortedBy=desc';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Order.fromJSON(data);
  });
}
Future<Stream<QuerySnapshot>> getUserDriver(String userId) async {
  return await FirebaseFirestore.instance
      .collection("driver")
      .where('driver_id' , isEqualTo: userId)
  //.orderBy('time', descending: true)
      .snapshots();
}

Future<Stream<QuerySnapshot>> getOrderNotification(id) async {
  return await FirebaseFirestore.instance
      .collection("current_orders")
      .where('id',
      isEqualTo: id)
      .snapshots();
}

Future<Stream<Order>> getOrder(orderId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders/$orderId?${_apiToken}with=user;deliveryCoupon;restaurantCoupon;driver;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;deliveryAddress;payment';
  print('======================================');
  print(url);
  print('===================================');
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}orders?${_apiToken}with=user;foodOrders;foodOrders.food;foodOrders.extras;orderStatus;payment&search=user.id:${_user.id};for_restaurants:${isRestaurant.value}&searchFields=user.id:=;for_restaurants:=&orderBy=updated_at&sortedBy=desc&limit=3';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return Order.fromJSON(data);
  });
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
    return OrderStatus.fromJSON(data);
  });
}

Future<Order> addOrder(Order order, Payment payment) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Order();
  }
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
  order.payment = payment;
  print('+++++++++++++++++++++order++++++++++++++++++++++++++++');
  print(order.toMap());
  print('+++++++++++++++++++++++order++++++++++++++++++++++++++');

  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}orders?$_apiToken';
  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  print('++++++++++++++++++++++++Url+++++++++++++++++++++++++');
  print(url);
  print('+++++++++++++++++++++++++++++++++++++++++++++++++');
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(params),
  );
  print(response.body);
  print(response.statusCode);
  return Order.fromJSON(json.decode(response.body)['data']);
}

Future<Order> cancelOrder(Order order) async {
  print(order.toMap());
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}orders/${order.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(order.cancelMap()),
  );
  print(response.body);
  if (response.statusCode == 200) {
    return Order.fromJSON(json.decode(response.body)['data']);
  } else {
    throw new Exception(response.body);
  }
}
