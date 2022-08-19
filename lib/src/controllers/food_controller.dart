import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/order.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import 'package:food_delivery_app/src/repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/extra.dart';
import '../models/favorite.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';
import '../repository/food_repository.dart';

class FoodController extends ControllerMVC {
  Food food;
  List<Order> orders = <Order>[];
 bool loading=false;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  FoodController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  ///Order
  void listenForOrders({String message}) async {
    try {
      setState(() {
        loading=true;
      });
      final Stream<Order> stream = await getOrders();
      stream.listen((Order _order) {
        setState(() {
          orders.add(_order);
        });
      }, onError: (e) {
        print(e);
      }, onDone: () {
        if (message != null) {
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(
              SnackBar(
                content: Text(message),
              ));
        }
      });
    } catch (e) {

    } finally {
      setState(() {
        loading=false;
      });
    }
  }

  void doCancelOrder(Order order) {
    order.orderStatus.id='110';
    order.active=false;
    cancelOrder(order).then((value) {
      setState(() {
        order.active = false;
      });
    }).catchError((e) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e),
      ));
    }).whenComplete(() {
      //refreshOrders();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content:
            Text(S.of(state.context).orderThisorderidHasBeenCanceled(order.id)),
      ));
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(state.context).order_refreshed_successfuly);
  }

  ///EndOrder
  void listenForFood({String foodId, String message}) async {
    final Stream<Food> stream = await getFood(foodId);
    stream.listen((Food _food) {
      setState(() => food = _food);
    }, onError: (a) {
      print(a);

    }, onDone: () {
      calculateTotal();
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForFavorite({String foodId}) async {
    final Stream<Favorite> stream = await isFavoriteFood(foodId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameRestaurants(Food food) {
    if (this.carts.isNotEmpty) {
      return this.carts[0].food?.restaurant?.id == food.restaurant?.id;
    }
    return true;
  }

  void addToCart(Food food, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.food = food;
    _newCart.extras = food.extras.where((element) => element.checked).toList();
    _newCart.quantity = this.quantity;
    // if food exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity += this.quantity;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_food_was_added_to_cart),
        ));
        Navigator.of(state.context).pushNamed('/Details',
            arguments: RouteArgument(
                id: '0', param: food.restaurant.id, heroTag: 'menu_tab'));
      });
    } else {
      // the food doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_food_was_added_to_cart),
        ));
        Navigator.of(state.context).pushNamed('/Details',
            arguments: RouteArgument(
                id: '0', param: food.restaurant.id, heroTag: 'menu_tab'));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  void addToFavorite(Food food) async {
    var _favorite = new Favorite();
    _favorite.food = food;
    _favorite.extras = food.extras.where((Extra _extra) {
      return _extra.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).thisFoodWasAddedToFavorite),
      ));
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).thisFoodWasRemovedFromFavorites),
      ));
    });
  }

  Future<void> refreshFood() async {
    var _id = food.id;
    food = new Food();
    listenForFavorite(foodId: _id);
    listenForFood(
        foodId: _id, message: S.of(state.context).foodRefreshedSuccessfuly);
  }

  void calculateTotal() {
    total = food?.price ?? 0;
    food?.extras?.forEach((extra) {
      total += extra.checked ? extra.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
