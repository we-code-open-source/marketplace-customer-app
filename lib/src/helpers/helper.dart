import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/src/models/coupon.dart';
import 'package:food_delivery_app/src/models/distance_price.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';

import '../../generated/l10n.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/cart.dart';
import '../models/food_order.dart';
import '../models/order.dart';
import '../models/restaurant.dart';
import '../repository/settings_repository.dart';
import 'app_config.dart' as config;
import 'custom_trace.dart';

class Helper {
  BuildContext context;
  DateTime currentBackPressTime;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static double getDoubleData(Map<String, dynamic> data) {
    return (data['data'] as double) ?? 0;
  }

  static bool getBoolData(Map<String, dynamic> data) {
    return (data['data'] as bool) ?? false;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static Future<bool> checkInternetConnectivity() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      // print('Mobile');
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // print('Wifi');
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      print('No Connection');
      return false;
    } else {
      return false;
    }
  }

  static Future<Marker> getMarker(Restaurant res) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(res.id),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: res.name,
            snippet: '${res.distanceGoogle.distance.value / 1000}  km',
            onTap: () {
              print(CustomTrace(StackTrace.current, message: 'Info Window'));
            }),
        position:
            LatLng(double.parse(res.latitude), double.parse(res.longitude)));

    return marker;
  }

  static Future<Marker> getMyPositionMarker(double latitude, double longitude,
      {String lable}) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        infoWindow: InfoWindow(
          title: lable ?? 'مكاني',
        ),
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static Widget getPrice(myPrice, BuildContext context,
      {TextStyle style, String zeroPlaceholder = '-'}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (myPrice == 0) {
        return Text(zeroPlaceholder,
            style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: setting.value?.defaultCurrency,
                style: style == null
                    ? Theme.of(context).textTheme.subtitle1.merge(
                          TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .fontSize -
                                  6),
                        )
                    : style.merge(TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: style.fontSize - 6)),
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(
                              setting.value?.currencyDecimalDigits) ??
                          '',
                      style: style ?? Theme.of(context).textTheme.subtitle1),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(
                        setting.value?.currencyDecimalDigits) ??
                    '',
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                    text: setting.value?.defaultCurrency,
                    style: style == null
                        ? Theme.of(context).textTheme.subtitle1.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .fontSize -
                                      6),
                            )
                        : style.merge(TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: style.fontSize - 6)),
                  ),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    total *= foodOrder.quantity;
    return total;
  }

  static double getOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    return total;
  }

  static double getTaxOrder(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) {
      total += getTotalOrderPrice(foodOrder);
    });
    return order.tax * total / 100;
  }

  static double getSubTotalOrdersPrice(Order order) {
    double subtotal = 0;
    order.foodOrders.forEach((foodOrder) {
      subtotal += getTotalOrderPrice(foodOrder);
    });
    if(order.restaurantCouponValue!=0.0&&order.restaurantCouponValue!=null)
      subtotal -= order.restaurantCouponValue;
    return subtotal;
  }

  static double getDeliveryOrdersPrice(Order order) {
    double deliveryFee = 0;
    if(order.deliveryCouponValue!=0.0&&order.deliveryCouponValue!=null){
      deliveryFee= order.deliveryFee-order.deliveryCouponValue;
    return deliveryFee;
  }else return order.deliveryFee;
}
  static double getTotalOrdersPrice(Order order) {
    double total = 0;
    order.foodOrders.forEach((foodOrder) {
      total += getTotalOrderPrice(foodOrder);
    });
   total += order.deliveryFee;
    total += order.tax * total / 100;
    if(order.restaurantCouponValue!=0.0&&order.restaurantCouponValue!=null)
      total -= order.restaurantCouponValue;
    if(order.deliveryCouponValue!=0.0&&order.deliveryCouponValue!=null)
      total -= order.deliveryCouponValue;
    return total;
  }

  static String getDistance(double distance, String unit) {
    String _unit = setting.value.distanceUnit;
    if (_unit == 'km') {
      distance *= 1.60934;
    }
    return distance != null ? distance.toStringAsFixed(2) + " " + unit : "";
  }

  static bool canDelivery(Restaurant _restaurant, {List<Cart> carts}) {

    bool _can = true;
    String _unit = setting.value.distanceUnit;
    double _deliveryRange = _restaurant.deliveryRange;
    double _distance = _restaurant.distanceGoogle.distance.value / 1000;
    carts?.forEach((Cart _cart) {
      _can &= _cart.food.deliverable;
    });

    if (_unit == 'km') {
      _deliveryRange /= 1.60934;
    }
    if (_distance == 0 && !deliveryAddress.value.isUnknown()) {
      _distance = sqrt(pow(
              69.1 *
                  (double.parse(_restaurant.latitude) -
                      deliveryAddress.value.latitude),
              2) +
          pow(
              69.1 *
                  (deliveryAddress.value.longitude -
                      double.parse(_restaurant.longitude)) *
                  cos(double.parse(_restaurant.latitude) / 57.3),
              2));
    }
    _can &= _restaurant.availableForDelivery &&
        (_distance < _deliveryRange) &&
        !deliveryAddress.value.isUnknown();
    return _can;
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static Html applyHtml(context, String html, {TextStyle style}) {
    return Html(
      data: html ?? '',
      style: {
        "*": Style(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          color: Theme.of(context).hintColor,
          fontSize: FontSize(16.0),
          display: Display.INLINE_BLOCK,
          width: config.App(context).appWidth(100),
        ),
        "h4,h5,h6": Style(
          fontSize: FontSize(18.0),
        ),
        "h1,h2,h3": Style(
          fontSize: FontSize.xLarge,
        ),
        "br": Style(
          height: 0,
        ),
        "p": Style(
          fontSize: FontSize(16.0),
        )
      },
    );
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader?.remove();
      } catch (e) {}
    });
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static double getDistanceKmDouble(double distance) {
    String _unit = setting.value.distanceUnit;
    distance *= 1.60934;
    return distance;
  }

  static priceCheck(myPrice, {minimumPrice = true}) {
    if(myPrice!=0) {
      String str = myPrice.toStringAsFixed(2);
      var arr = str.split('.');
      if (int.tryParse(arr[1]) == 0) {
        arr[1] = '0';
        myPrice = double.tryParse(arr[0] + '.' + arr[1]);
      } else if (int.tryParse(arr[1]) <= 25) {
        arr[1] = '25';
        myPrice = double.tryParse(arr[0] + '.' + arr[1]);
      } else if (int.tryParse(arr[1]) <= 50) {
        arr[1] = '50';
        myPrice = double.tryParse(arr[0] + '.' + arr[1]);
      } else if (int.tryParse(arr[1]) <= 75) {
        arr[1] = '75';
        myPrice = double.tryParse(arr[0] + '.' + arr[1]);
      } else {
        arr[1] = '00';
        arr[0] = (int.tryParse(arr[0]) + 1).toString();

        myPrice = double.tryParse(arr[0] + '.' + arr[1]);
      }
      if (myPrice < double.tryParse(setting.value.minimum_price)&&minimumPrice)
        myPrice = double.tryParse(setting.value.minimum_price);
      return myPrice;
    }else return myPrice;
  }

  static getDistancePrice(
      List distancePriceList, double distance, BuildContext context,
      {TextStyle style}) {
    List<DistancePrice> distancePrices;
    distancePrices = List.from(distancePriceList)
        .map((element) => DistancePrice.fromJSON(element))
        .toSet()
        .toList();

    var myPrice = 0.0;
    distancePrices.forEach((distancePrice) {
      print(distance.toString() +
          "  " +
          distancePrice.from.toString() +
          "  " +
          distancePrice.to.toString());
      if (distance >= distancePrice.from && distance <= distancePrice.to) {
        myPrice = distancePrice.price;
      }
    });
    myPrice = priceCheck(myPrice);
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (myPrice == 0) {
        return Text('-', style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: setting.value?.defaultCurrency,
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(
                              setting.value?.currencyDecimalDigits) ??
                          '',
                      style: style ?? Theme.of(context).textTheme.subtitle1),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(
                        setting.value?.currencyDecimalDigits) ??
                    '',
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                      text: setting.value?.defaultCurrency,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: style != null
                              ? style.fontSize - 4
                              : Theme.of(context).textTheme.subtitle1.fontSize -
                                  4)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static getTimePrice(double time, double distance, BuildContext context,
      {TextStyle style}) {
    print("time : $time distance : $distance");
    var myPrice = 0.0;
    double price_per_minute = double.tryParse(setting.value.price_per_minute);
    double price_per_km = double.tryParse(setting.value.price_per_km);
    double mainPrice = double.tryParse(setting.value.initial_price);
    myPrice = mainPrice + (price_per_minute * time) + (price_per_km * distance);
    myPrice = priceCheck(myPrice);

    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (myPrice == 0) {
        return Text('-', style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: setting.value?.defaultCurrency,
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(
                              setting.value?.currencyDecimalDigits) ??
                          '',
                      style: style ?? Theme.of(context).textTheme.subtitle1),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(
                        setting.value?.currencyDecimalDigits) ??
                    myPrice.toStringAsFixed(2),
                style: style ?? Theme.of(context).textTheme.subtitle1,
                children: <TextSpan>[
                  TextSpan(
                      text: setting.value?.defaultCurrency,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: style != null
                              ? style.fontSize - 4
                              : Theme.of(context).textTheme.subtitle1.fontSize -
                                  4)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }
  static getTotalPriceAfterCoupon(totalPrice,Coupon coupon, BuildContext context,
      {TextStyle style}) {

    try {
      if(coupon.discountType=='percent') {
        totalPrice = totalPrice-(totalPrice * (coupon.discount / 100));
      }
      else if(coupon.discountType=='fixed') {
        totalPrice = totalPrice -coupon.discount;
      }

      return totalPrice;
    } catch (e) {

    }}
  static getCouponVul( price,Coupon coupon) {

    try {
      if(coupon.discountType=='percent') {
         price = price * (coupon.discount / 100);
      }
      else if(coupon.discountType=='fixed') {
        price = price - coupon.discount;
      }

      return price;
    } catch (e) {

    }}
  static getDeliveryPriceAfterCoupon( deliveryPrice,Coupon coupon) {
    if (coupon != null) {
      if (coupon.discountType == 'percent') {
        coupon.onDeliveryFee
            ? deliveryPrice =
            deliveryPrice - (deliveryPrice * (coupon.discount / 100))
            : deliveryPrice;
      }
      else if (coupon.discountType == 'fixed') {
        coupon.onDeliveryFee
            ? deliveryPrice = deliveryPrice - (deliveryPrice - coupon.discount)
            : deliveryPrice;
      }

      return deliveryPrice;
    } else
      return deliveryPrice;
  }

  static getPriceCoupon( subTotal,deliveryPrice,Coupon coupon) {
    double total=0;
      if(coupon.restaurantId!=null&&coupon.foodsIds.isEmpty&&coupon.onDeliveryFee!=null&&coupon.onDeliveryFee) {
        if (coupon.discountType == 'percent') {
          deliveryPrice =
          (deliveryPrice * (coupon.discount / 100));
          subTotal = (subTotal * (coupon.discount / 100));
          total = deliveryPrice + subTotal;
        }
        else if (coupon.discountType == 'fixed') {
          deliveryPrice = deliveryPrice - coupon.discount;
          subTotal = subTotal - coupon.discount;
          total = deliveryPrice + subTotal;
        }
      }else if(coupon.restaurantId!=null){
        if (coupon.discountType == 'percent') {
          subTotal = (subTotal * (coupon.discount / 100));
          total =  subTotal;
        }
        else if (coupon.discountType == 'fixed') {
          subTotal = subTotal - coupon.discount;
          total = subTotal;
        }
      }else if(coupon.onDeliveryFee!=null&&coupon.onDeliveryFee){
        if (coupon.discountType == 'percent') {
          deliveryPrice =
          (deliveryPrice * (coupon.discount / 100));

          total = deliveryPrice;
          print('total=$total');
        }
        else if (coupon.discountType == 'fixed') {
          deliveryPrice = deliveryPrice - coupon.discount;
          total = deliveryPrice ;
        }
      }
      return priceCheck(total,minimumPrice: false);

  }
  static getTime(time) {
    String str = time.toStringAsFixed(1);
    var arr = str.split('.');
    if (int.tryParse(arr[1]) == 0) {
      time = double.tryParse(arr[0]);
    } else {
      arr[0] = (int.tryParse(arr[0]) + 1).toString();
      time = int.tryParse(arr[0]);
    }
    return time;
  }

  static getDistancePriceDouble(List distancePriceList, double distance) {
    List<DistancePrice> distancePrices;
    distancePrices = List.from(distancePriceList)
        .map((element) => DistancePrice.fromJSON(element))
        .toSet()
        .toList();

    var myPrice = 0.0;
    distancePrices.forEach((distancePrice) {
      if (distance >= distancePrice.from && distance <= distancePrice.to) {
        myPrice = distancePrice.price;
      }
    });
    myPrice = priceCheck(myPrice);
    try {
      return myPrice;
    } catch (e) {
      return 0.0;
    }
  }

  static getTimePriceDouble(double time, double distance) {
    try {
      var myPrice = 0.0;
      double price_per_minute = double.tryParse(setting.value.price_per_minute);
      double price_per_km = double.tryParse(setting.value.price_per_km);
      double mainPrice = double.tryParse(setting.value.initial_price);
      myPrice =
          mainPrice + (price_per_minute * time) + (price_per_km * distance);

      myPrice = priceCheck(myPrice);

      return myPrice;
    } catch (e) {
      return 0.0;
    }
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(GlobalConfiguration().getValue('base_url')).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(GlobalConfiguration().getValue('base_url')).scheme,
        host: Uri.parse(GlobalConfiguration().getValue('base_url')).host,
        port: Uri.parse(GlobalConfiguration().getValue('base_url')).port,
        path: _path + path);
    return uri;
  }

  Color getColorFromHex(String hex) {
    if (hex.contains('#')) {
      return Color(int.parse(hex.replaceAll("#", "0xFF")));
    } else {
      return Color(int.parse("0xFF" + hex));
    }
  }

  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  static AlignmentDirectional getAlignmentDirectional(
      String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  Future<bool> onWillPop() {
    // DateTime now = DateTime.now();
    // if (currentBackPressTime == null ||
    //     now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    //   currentBackPressTime = now;
    //   Fluttertoast.showToast(msg: S.of(context).tapAgainToLeave);
    //   return Future.value(false);
    // }

      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  String trans(String text) {
    switch (text) {
      case "App\\Notifications\\StatusChangedOrder":
        return S.of(context).order_status_changed;
      case "App\\Notifications\\NewOrder":
        return S.of(context).new_order_from_client;
      case "km":
        return S.of(context).km;
      case "mi":
        return S.of(context).mi;
      default:
        return "";
    }
  }
}
