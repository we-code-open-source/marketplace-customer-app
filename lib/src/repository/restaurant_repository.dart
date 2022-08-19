import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/repository/settings_repository.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/filter.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/user_repository.dart';

ValueNotifier<int> statusCode = new ValueNotifier(200);

Future<Stream<Restaurant>> getNearRestaurants(
    Address myLocation, Address areaLocation) async {
  print(myLocation.toMap());
  Uri uri = Helper.getUri('api/restaurants');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '20';
  _queryParams['search'] =
      'featured:1;closed:0;is_restaurant:${isRestaurant.value}';
  _queryParams['searchFields'] = 'featured:=;closed:=;is_restaurant:=';
  _queryParams['myLon'] = myLocation.longitude.toString();
  _queryParams['myLat'] = myLocation.latitude.toString();
  _queryParams['areaLon'] = areaLocation.longitude.toString();
  _queryParams['areaLat'] = areaLocation.latitude.toString();

  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200) {
      statusCode.value = 200;
      statusCode.notifyListeners();
    }else if (streamedRest.statusCode == 404) {
      statusCode.value = 404;
      statusCode.notifyListeners();
    } else if (streamedRest.statusCode == 500) {
      statusCode.value = 500;
      statusCode.notifyListeners();
    }
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => data)
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getPopularRestaurants(Address myLocation) async {
  Uri uri = Helper.getUri('api/restaurants');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '20';
  _queryParams['search'] = 'closed:0;is_restaurant:${isRestaurant.value}';
  _queryParams['searchFields'] = 'closed:=;is_restaurant:=';
  _queryParams['myLon'] = myLocation.longitude.toString();
  _queryParams['myLat'] = myLocation.latitude.toString();

  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    if (streamedRest.statusCode == 200) {
      statusCode.value = 200;
      statusCode.notifyListeners();
    }else if (streamedRest.statusCode == 404) {
      statusCode.value = 404;
      statusCode.notifyListeners();
    } else if (streamedRest.statusCode == 500) {
      statusCode.value = 500;
      statusCode.notifyListeners();
    }
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => data)
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> searchRestaurants(
    String search, Address address) async {
  Uri uri = Helper.getUri('api/restaurants');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'closed:0;name:$search';
  _queryParams['searchFields'] = 'closed:=;name:like';
  _queryParams['searchJoin'] = 'and';

  _queryParams['myLon'] = address.longitude.toString();
  _queryParams['myLat'] = address.latitude.toString();
  _queryParams['areaLon'] = address.longitude.toString();
  _queryParams['areaLat'] = address.latitude.toString();

  uri = uri.replace(queryParameters: _queryParams);
  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => data)
        .expand((data) => (data as List))
        .map((data) {
      return Restaurant.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Restaurant>> getRestaurant(String id, Address address) async {
  Uri uri = Helper.getUri('api/restaurants/$id');
  Map<String, dynamic> _queryParams = {};

  _queryParams['myLon'] = address.longitude.toString();
  _queryParams['myLat'] = address.latitude.toString();
  _queryParams['areaLon'] = address.longitude.toString();
  _queryParams['areaLat'] = address.latitude.toString();

  _queryParams['with'] = 'users';
  uri = uri.replace(queryParameters: _queryParams);

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    print("+++++++++getRestaurant+++++++++++++");
    print(uri);
    streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => print(data));
    print("++++++++++++++++++++++");
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => Restaurant.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Restaurant.fromJSON({}));
  }
}

Future<Stream<Review>> getRestaurantReviews(String id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews?with=user&search=restaurant_id:$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Stream<Review>> getRecentReviews() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Review> addRestaurantReview(Review review, Restaurant restaurant) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}restaurant_reviews';
  final client = new http.Client();
  review.user = currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofRestaurantToMap(restaurant)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Review.fromJSON({});
  }
}

Future<Review> addDriverReview(Review review, User driver) async {
  User user = currentUser.value;
  final String _apiToken = 'api_token=${user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}driver_reviews?$_apiToken';
  final client = new http.Client();
  review.user = user;
  print(json.encode(review.ofDriverToMap(driver)));
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        'driver_id': driver.id,
        'review': review.review,
        'rate': review.rate,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Review.fromJSON({});
  }
}
