import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends ControllerMVC with ChangeNotifier {
  List<model.Address> addresses = <model.Address>[];
  model.Address address = new model.Address();
  GlobalKey<ScaffoldState> scaffoldKey;
  Cart cart;
  GlobalKey<FormState> addressFormKey;
  bool isDefault = false;
  bool loading = true;
  OverlayEntry loader;
  DeliveryAddressesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    addressFormKey = new GlobalKey<FormState>();
    listenForAddresses();
    listenForCart();
  }
  void defaultAddress() async {
    setState(()=>isDefault = !isDefault);
    address.isDefault=isDefault;
  }
  void listenForAddresses({String message}) async {
    try{
      loading=true;
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      print(a);

    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }catch(e){
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(e),
      ));
    }finally{
      loading=false;
    }
    }
  /// Create new Item in address
  void addNewAddress() async {
    loader = Helper.overlayLoader(state.context);

    try {
      if (addressFormKey.currentState.validate()) {
        addressFormKey.currentState.save();
        Overlay.of(state.context).insert(loader);
        await userRepo.addAddress(address).then((value) {
          if (value != null) {
            setState(() {
              this.addresses.insert(0, value);
            });
            changeDeliveryAddress(addresses.elementAt(0)).then((value) {
              Navigator.of(state.context).pushNamed('/Pages', arguments: 1);
            });

            ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
              content: Text(S.of(state.context).new_address_added_successfully),
            ));
            listenForAddresses();
          }
        }
        );
      }
    } catch (e) {
      loader.remove();
      print(e.toString());
    }
    finally{
      Helper.hideLoader(loader);
    }
  }
  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      cart = _cart;
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(message: S.of(state.context).addresses_refreshed_successfuly);
  }

  Future<void> changeDeliveryAddress(model.Address address) async {
    await settingRepo.changeCurrentLocation(address);
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  Future<void> changeDeliveryAddressToCurrentLocation() async {
    model.Address _address = await settingRepo.setCurrentLocation();
    setState(() {
      settingRepo.deliveryAddress.value = _address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {

      setState(() {
        this.addresses.insert(0, value);
      });
      changeDeliveryAddress(addresses.elementAt(0)).then((value) {
        Navigator.of(state.context).pushNamed('/Pages', arguments: 1);
      });
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).new_address_added_successfully),
      ));
    });
  }

  void chooseDeliveryAddress(model.Address address) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {});
      addresses.clear();
      listenForAddresses(message: S.of(state.context).the_address_updated_successfully);
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).delivery_address_removed_successfully),
      ));
    });
  }
}
