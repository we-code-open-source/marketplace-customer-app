import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/confirm_dialog_view.dart';
import 'package:food_delivery_app/src/repository/settings_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Restaurant restaurant;
  String heroTag;

  CardWidget({Key key, this.restaurant, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/Details',
            arguments: RouteArgument(
              id: '0',
              param: restaurant.id,
              heroTag: heroTag,
            ));
      },
      child: Container(
        width: 292,
        margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image of the card
            Stack(
              fit: StackFit.loose,
              alignment: AlignmentDirectional.bottomStart,
              children: <Widget>[
                Hero(
                  tag: this.heroTag + restaurant.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: restaurant.image.url,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                          color: restaurant.closed ? Colors.grey : Colors.green,
                          borderRadius: BorderRadius.circular(24)),
                      child: restaurant.closed
                          ? Text(
                              S.of(context).closed,
                              style: Theme.of(context).textTheme.caption.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            )
                          : Text(
                              S.of(context).open,
                              style: Theme.of(context).textTheme.caption.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          restaurant.name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          Helper.skipHtml(restaurant.description),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: Helper.getStarsList(
                              double.parse(restaurant.rate)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            launch(
                                'https://www.google.com/maps/dir/?api=1&destination=' +
                                    restaurant.latitude.toString() +
                                    ',' +
                                    restaurant.longitude.toString() +
                                    '&travelmode=driving&dir_action=navigate');
                          },
                          child: Icon(Icons.directions,
                              color: Theme.of(context).primaryColor),
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        restaurant.distanceGoogle.distance.value > 0
                            ? Text(
                                '${(restaurant.distanceGoogle.distance.value / 1000).toStringAsFixed(2)} ${S.of(context).km}',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              )
                            : SizedBox(height: 0),
                        restaurant.distanceGoogle.duration.value > 0
                            ? Text(
                                '${Helper.getTime(restaurant.distanceGoogle.duration.value / 60)} ${S.of(context).minute}',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              )
                            : SizedBox(height: 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            restaurant.distanceGoogle.duration.value > 0 &&
                    restaurant.distanceGoogle.distance.value > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isRestaurant.value == 1
                            ? ' ${S.of(context).delivery_price}  : ${Helper.getTimePriceDouble(restaurant.distanceGoogle.duration.value / 60, restaurant.distanceGoogle.distance.value / 1000)} د.ل'
                            : ' ${S.of(context).delivery_price}  : ${Helper.getTimePriceDouble(restaurant.distanceGoogle.duration.value / 60, restaurant.distanceGoogle.distance.value / 1000)} د.ل',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      IconButton(
                        icon: new Icon(Icons.info,
                            color: Theme.of(context).hintColor),
                        onPressed: () async {
                          await showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmDialogView(
                                  title: S.of(context).delivery_fee,
                                  description:
                                      'السعر الاساسي: ${setting.value.initial_price} دينار \n سعر مسافة التوصيل: المسافة بالكيلو × قيمة الكيلو = * دينار\n سعر مسافة التوصيل: ${(restaurant.distanceGoogle.distance.value / 1000).toStringAsFixed(2)} × ${setting.value.price_per_km} =${double.tryParse(((restaurant.distanceGoogle.distance.value / 1000).toStringAsFixed(2))) * (double.tryParse(setting.value.price_per_km))} دينار\n سعر وقت التوصيل: الوقت بالدقائق × قيمة الدقيقة = * دينار \n سعر وقت التوصيل: ${(restaurant.distanceGoogle.duration.value / 60).toStringAsFixed(0)} × ${setting.value.price_per_minute} = ${double.tryParse((restaurant.distanceGoogle.duration.value / 60).toStringAsFixed(0)) * (double.tryParse(setting.value.price_per_minute))} دينار \n  الاجمالي ${Helper.getTimePriceDouble(restaurant.distanceGoogle.duration.value / 60, restaurant.distanceGoogle.distance.value / 1000)} دينار',
                                  leftButtonText: S.of(context).close,
                                );
                              });
                        },
                      ),
                    ],
                  )
                : SizedBox(height: 0)
          ],
        ),
      ),
    );
  }
}
