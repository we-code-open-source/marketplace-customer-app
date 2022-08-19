import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import '../models/confirm_reset_code.dart';
import '../models/reset_password.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import '../repository/settings_repository.dart';

ValueNotifier<User> currentUser = new ValueNotifier(User());
ValueNotifier<int> numOfReq = new ValueNotifier(0);
ValueNotifier<int> statusCode = new ValueNotifier(0);

Future<User> login(User user) async {
  print("++++++++++++++++++++");
  print(user.toMap());
  print("++++++++++++++++++++");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}login';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
  return currentUser.value;
}
Future<bool> checkPhoneRegister(String phone) async {
  numOfReq.value++;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}register?phone_number=$phone';
  final client = new http.Client();
  final response = await client.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'},
  );
  print(response.body);
  print(response.statusCode);

  if (response.statusCode == 200) {
    statusCode.value = 200;
    return true;
  } else if (response.statusCode == 422) {
    statusCode.value = 422;
    return false;
  }if (response.statusCode == 400) {
    statusCode.value = 400;
    return false;
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}
Future<String> ConfirmRegister(ConfirmResetCode confirmResetCode) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}confirm_register';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json', HttpHeaders.acceptHeader: 'application/json'},
    body: json.encode(confirmResetCode.toMap()),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['token'];
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<User> register(User user) async {
  print("++++++++++++++++++++");
  print(user.toMap());
  print("++++++++++++++++++++");
  final String url = '${GlobalConfiguration().getValue('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
  return currentUser.value;
}
Future<bool> checkPhoneResetPassword(String phone) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}reset_password?phone_number=$phone';
  final client = new http.Client();
  final response = await client.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',},
  );
  print(response.statusCode);
    if (response.statusCode == 200) {
      statusCode.value = 200;
      return true;
    } else if (response.statusCode == 422) {
      statusCode.value = 422;
      return false;
    }if (response.statusCode == 400) {
      statusCode.value = 400;
      return false;
    } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}
Future<String> ConfirmResetVerificationCode(ConfirmResetCode confirmResetCode) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}confirm_reset_code';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(confirmResetCode.toMap()),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['token'];
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}
Future<bool> resetPassword(ResetPassword resetPassword) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}reset_password';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(resetPassword.toMap()),
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)['data'];
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }
}

Future<void> logout(deviceToken) async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}logout?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json'},
      body: json.encode({
        'device_token': deviceToken,
      })
  );
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    currentUser.value = new User();
    deliveryAddress.value = new Address();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    await prefs.remove('delivery_address');
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
    throw new Exception(response.body);
  }

}

void setCurrentUser(jsonString) async {
  try {
    if (json.decode(jsonString)['data'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: jsonString).toString());
    throw new Exception(e);
  }
}

Future<void> setCreditCard(CreditCard creditCard) async {
  if (creditCard != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credit_card', json.encode(creditCard.toMap()));
  }
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
    currentUser.value = User.fromJSON(json.decode(await prefs.get('current_user')));
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}

Future<CreditCard> getCreditCard() async {
  CreditCard _creditCard = new CreditCard();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credit_card')) {
    _creditCard = CreditCard.fromJSON(json.decode(await prefs.get('credit_card')));
  }
  return _creditCard;
}

Future<User> update(User user) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}users/${currentUser.value.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  return currentUser.value;
}

Future<Stream<Address>> getAddresses() async {
  User _user = currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken&search=user_id:${_user.id}&searchFields=user_id:=&orderBy=updated_at&sortedBy=desc';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
print(url);
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Address.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Stream.value(new Address.fromJSON({}));
  }
}

Future<Address> addAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> updateAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(address.toMap()),
    );
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }
}

Future<Address> removeDeliveryAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  try {
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Address.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url));
    return new Address.fromJSON({});
  }

}
