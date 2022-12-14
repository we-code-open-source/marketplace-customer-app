import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class SettingsController extends ControllerMVC {
  CreditCard creditCard = new CreditCard();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  OverlayEntry loader;

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  void showLoader() {
    loader = Helper.overlayLoader(state.context);
    Overlay.of(state.context).insert(loader);
  }

  void hideLoader() {
    loader = Helper.overlayLoader(state.context);
    Helper.hideLoader(loader);
  }
  void update(User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).profile_settings_updated_successfully),
      ));
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).payment_settings_updated_successfully),
      ));
    });
  }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }
}
