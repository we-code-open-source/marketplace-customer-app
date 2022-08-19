import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/confirm_reset_code.dart';
import '../models/reset_password.dart';
import '../models/route_argument.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../repository/settings_repository.dart' as sett;
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart' as m;
import '../models/address.dart' as a;
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  m.User user = new m.User();
  ConfirmResetCode confirmResetCode= new ConfirmResetCode();
  ResetPassword resetPass= new ResetPassword();
  List<a.Address> addresses = <a.Address>[];
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;
  final codeController = TextEditingController();
  String phone="";

  GlobalKey<FormState> codeFormKey ;
  String vId;
  String smsCode;
  FirebaseAuth firebaseAuth;
  int counter = 60;
  Timer _timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (counter == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            counter--;
          });
        }
      },
    );
  }
  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });
    firebaseAuth = FirebaseAuth.instance;
    codeFormKey = GlobalKey<FormState>();
  }
  void login() async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.login(user).then((value) {
        if ( value != null && value.apiToken!=null) {
          if(sett.deliveryAddress.value?.address == null)
          {sett.isRestaurant.value = 1;
            Navigator.of(state.context).pushNamed('/DeliveryAddress');
          } else{
            sett.isRestaurant.value = 1;
            Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 1);
        }}
      }).catchError((e) {
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).wrong_phone_or_password),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
  void reSendCode(phone) {
    print(repository.numOfReq.value);
    counter = 60;
    if(repository.numOfReq.value<3){
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();

      Overlay.of(state.context).insert(loader);
      repository.checkPhoneRegister(phone).then((value) {
        if (value != null && value == true) {
          startTimer();
          ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
            content: Text('تم ارسال الرسالة بنجاح'),
          ));
        } else {
          loader.remove();
          ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
            content: Text("هنالك مشكلة في الشبكة"),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });

  }else ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
      content: Text("حاول في وقت أخر"),
    ));
  }
  void checkPhoneRegister() {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.checkPhoneRegister(user.phone_number).then((value) {
        if (repository.statusCode.value==200 && value == true) {
          Navigator.of(state.context).pushNamed('/code',arguments: RouteArgument(
              id: '0',
              param: {
                'title':S.of(state.context).verification_code ,
                'type': 'register',
                'phone':user.phone_number
              }));
        }   else if (repository.statusCode.value==422 && value == false){
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_phone_account_exists),
        ));
      } else if (repository.statusCode.value==400 && value == false){
      loader.remove();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).code_not_send),
      ));
    }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void confirmRegister() {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
      confirmResetCode.code=codeController.text;
      Overlay.of(state.context).insert(loader);
      repository.ConfirmRegister(confirmResetCode).then((value) {
        if (value != null ) {
          Navigator.of(state.context).pushReplacementNamed('/SignUp',arguments: RouteArgument(
              id: '0',
              param: {
                'token':value,
                'phone':confirmResetCode.phone_number
              }));
        } else {
          loader.remove();
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text("code not sending"),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
  }
  void register() async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.register(user).then((value) async {
        if (value != null && value.apiToken != null) {
          if(sett.deliveryAddress.value?.address == null)
            {
              sett.isRestaurant.value = 1;
              Navigator.of(state.context).pushNamed('/AddAddress');
            } else {
            sett.isRestaurant.value = 1;
            Navigator.of(state.context).pushReplacementNamed(
                '/Pages', arguments: 1);
          }} else {
          ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
            content: Text(S.of(state.context).wrong_phone_or_password),
          ));
        }
      }).catchError((e) {
        loader?.remove();
        ScaffoldMessenger.of(state.context).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_phone_account_exists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
  Future<void> listenOTP() async {
    await SmsAutoFill().listenForCode;
  }
  void checkPhoneResetPassword() {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.checkPhoneResetPassword(user.phone_number).then((value) async {
        if (repository.statusCode.value==200 && value == true) {
          Navigator.of(state.context).pushNamed('/code',arguments: RouteArgument(
              id: '0',
              param: {
                'title':S.of(state.context).verification_code ,
                'type': 'pass',
                'phone':user.phone_number
              }));
        }   else if (repository.statusCode.value==422 && value == false){
          loader.remove();
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text(S.of(state.context).phone_number_not_found),
          ));
        } else if (repository.statusCode.value==400 && value == false){
          loader.remove();
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text(S.of(state.context).code_not_send),
          ));
        }      }).catchError((e) {
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).phone_number_not_found),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
  void confirmReset() {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
      confirmResetCode.code=codeController.text;
      Overlay.of(state.context).insert(loader);
      repository.ConfirmResetVerificationCode(confirmResetCode).then((value) {
        if (value != null ) {
          Navigator.of(state.context).pushReplacementNamed('/ResetPassword',arguments: RouteArgument(
              id: '0',
              param: {
                'token':value
              }));
        } else {
          loader.remove();
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text("code not sending"),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });

  }
  void resetPassword() {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.resetPassword(resetPass).then((value) {
        if (value != null && value) {

          Navigator.of(state.context).pushReplacementNamed('/Login');
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text(S.of(state.context).reset_password_success),
          ));
        } else {
          loader.remove();
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text("Error"),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }
}
