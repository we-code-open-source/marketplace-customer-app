import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/distance_price.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/GalleryCarouselWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/ShoppingCartFloatButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

class RestaurantWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  RestaurantWidget({Key key, this.parentScaffoldKey, this.routeArgument})
      : super(key: key);

  @override
  _RestaurantWidgetState createState() {
    return _RestaurantWidgetState();
  }
}

class _RestaurantWidgetState extends StateMVC<RestaurantWidget> {
  RestaurantController _con;

  _RestaurantWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.restaurant = widget.routeArgument.param as Restaurant;
    _con.listenForGalleries(_con.restaurant.id);
    _con.listenForFeaturedFoods(_con.restaurant.id);
    _con.listenForRestaurantReviews(id: _con.restaurant.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        body: RefreshIndicator(
          onRefresh: _con.refreshRestaurant,
          child: _con.restaurant == null
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor:
                              Theme.of(context).accentColor.withOpacity(0.9),
                          expandedHeight: 300,
                          elevation: 0,
//                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                          automaticallyImplyLeading: false,
                          leading: new IconButton(
                            icon: new Icon(Icons.arrow_back,
                                color: Theme.of(context).primaryColor),
                            onPressed: () => Navigator.of(context)
                                .pushNamed('/Pages', arguments: 1),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Hero(
                              tag: (widget?.routeArgument?.heroTag ?? '') +
                                  _con.restaurant.id,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _con.restaurant.image.url,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, left: 20, bottom: 10, top: 25),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.restaurant?.name ?? '',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 32,
                                      child: Chip(
                                        padding: EdgeInsets.all(0),
                                        label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(_con.restaurant.rate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor))),
                                            Icon(
                                              Icons.star_border,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: _con.restaurant.closed
                                            ? Colors.grey
                                            : Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: _con.restaurant.closed
                                        ? Text(
                                            S.of(context).closed,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          )
                                        : Text(
                                            S.of(context).open,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(child: SizedBox(height: 0)),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color:
                                            Helper.canDelivery(_con.restaurant)
                                                ? Colors.green
                                                : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Text(
                                      "${Helper.getTime(_con.restaurant.distanceGoogle.duration.value / 60)} ${S.of(context).minute}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color:
                                            Helper.canDelivery(_con.restaurant)
                                                ? Colors.green
                                                : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: _con.restaurant.delivery_price_type == 'distance' &&
                                            _con.restaurant != null
                                        ? Helper.getDistancePrice(
                                            _con.restaurant.deliveryFee, _con.restaurant.distanceGoogle.distance.value / 1000, context,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)))
                                        : _con.restaurant.delivery_price_type == 'fixed' &&
                                                _con.restaurant != null
                                            ? Helper.getPrice(_con.restaurant.deliveryFee, context,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .merge(TextStyle(color: Theme.of(context).primaryColor)))
                                            : _con.restaurant.delivery_price_type == 'flexible' && _con.restaurant != null
                                                ? Helper.getTimePrice((_con.restaurant.distanceGoogle.duration.value / 60), (_con.restaurant.distanceGoogle.distance.value / 1000), context, style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)))
                                                : Container(),
                                  ),
                                  SizedBox(width: 20),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Helper.applyHtml(
                                    context, _con.restaurant.description),
                              ),
                              ImageThumbCarouselWidget(
                                  galleriesList: _con.galleries),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ListTile(
                                  dense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  leading: Icon(
                                    Icons.stars,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    S.of(context).information,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Helper.applyHtml(
                                    context, _con.restaurant.information),
                              ),
                              _con.featuredFoods.isEmpty
                                  ? SizedBox(height: 0)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.restaurant,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).featured_foods,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                    ),
                              _con.featuredFoods.isEmpty
                                  ? SizedBox(height: 0)
                                  : ListView.separated(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: _con.featuredFoods.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(height: 10);
                                      },
                                      itemBuilder: (context, index) {
                                        return FoodItemWidget(
                                          heroTag: 'details_featured_food',
                                          food: _con.featuredFoods
                                              .elementAt(index),
                                        );
                                      },
                                    ),

                              ///chat with restaurant command
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 20, vertical: 20),
                              //   margin: const EdgeInsets.symmetric(vertical: 5),
                              //   color: Theme
                              //       .of(context)
                              //       .primaryColor,
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     children: <Widget>[
                              //       Expanded(
                              //         child: Text(
                              //           currentUser.value.apiToken != null
                              //               ? S
                              //               .of(context)
                              //               .forMoreDetailsPleaseChatWithOurManagers
                              //               : S
                              //               .of(context)
                              //               .signinToChatWithOurManagers,
                              //           overflow: TextOverflow.ellipsis,
                              //           maxLines: 3,
                              //           style: Theme
                              //               .of(context)
                              //               .textTheme
                              //               .bodyText1,
                              //         ),
                              //       ),
                              //       SizedBox(width: 10),
                              //       SizedBox(
                              //         width: 42,
                              //         height: 42,
                              //         child: FlatButton(
                              //           padding: EdgeInsets.all(0),
                              //           disabledColor: Theme
                              //               .of(context)
                              //               .focusColor
                              //               .withOpacity(0.5),
                              //           onPressed:
                              //           currentUser.value.apiToken != null
                              //               ? () {
                              //             Navigator.of(context).pushNamed(
                              //                 '/Chat',
                              //                 arguments: RouteArgument(
                              //                     param: new Conversation(
                              //                         _con.restaurant.users.map((e) {
                              //                           e.image = _con
                              //                               .restaurant
                              //                               .image;
                              //                           return e;
                              //                         }).toList(),
                              //                         name: _con.restaurant.name)));
                              //           }
                              //               : null,
                              //           child: Icon(
                              //             Icons.chat,
                              //             color: Theme
                              //                 .of(context)
                              //                 .primaryColor,
                              //             size: 24,
                              //           ),
                              //           color: Theme
                              //               .of(context)
                              //               .accentColor
                              //               .withOpacity(0.9),
                              //           shape: StadiumBorder(),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        _con.restaurant.address ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          launch('https://www.google.com/maps/dir/?api=1&destination=' +
                                              _con.restaurant.latitude
                                                  .toString() +
                                              ',' +
                                              _con.restaurant.longitude
                                                  .toString() +
                                              '&travelmode=driving&dir_action=navigate');
                                        },
                                        child: Icon(
                                          Icons.directions,
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        '${_con.restaurant.phone} \n${_con.restaurant.mobile}',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          launch(
                                              "tel:${_con.restaurant.mobile}");
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: Theme.of(context).primaryColor,
                                          size: 24,
                                        ),
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.9),
                                        shape: StadiumBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // SizedBox(height: 30),
                              // Container(
                              //   color: Colors.white,
                              //   child: ExpansionTile(
                              //     backgroundColor: Colors.white,
                              //     leading: Icon(Icons.delivery_dining),
                              //     title: Text("delivery prices"),
                              //     children: [
                              //       Container(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 10, vertical: 5),
                              //         color: Theme.of(context).primaryColor,
                              //         child: ListTile(
                              //           title: Text('delivery pricing method'),
                              //           trailing: Container(
                              //             padding: EdgeInsets.all(8),
                              //             decoration: BoxDecoration(
                              //               color: Colors.green,
                              //               borderRadius:
                              //                   BorderRadius.circular(50),
                              //             ),
                              //             child: Text(
                              //               _con.restaurant
                              //                       .deliveryPriceTypeArString() ??
                              //                   ' ',
                              //               style: Theme.of(context)
                              //                   .textTheme
                              //                   .headline4
                              //                   .merge(TextStyle(
                              //                       color: Theme.of(context)
                              //                           .primaryColor)),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Divider(
                              //           color: Colors.grey.shade300,
                              //           indent: 16,
                              //           endIndent: 16),
                              //       _con.restaurant.delivery_price_type ==
                              //               'fixed'
                              //           ? Container(
                              //               padding: const EdgeInsets.symmetric(
                              //                   horizontal: 10, vertical: 5),
                              //               margin: const EdgeInsets.symmetric(
                              //                   vertical: 5),
                              //               color:
                              //                   Theme.of(context).primaryColor,
                              //               child: ListTile(
                              //                 title: Text('سعر التوصيل'),
                              //                 trailing: Text(
                              //                   _con.restaurant.deliveryFee
                              //                               .toString() +
                              //                           ' دينار ' ??
                              //                       ' ',
                              //                   style: Theme.of(context)
                              //                       .textTheme
                              //                       .headline4,
                              //                 ),
                              //               ),
                              //             )
                              //           : Container(),
                              //       _con.restaurant.delivery_price_type ==
                              //                   'distance' &&
                              //               _con.restaurant.deliveryFee != null
                              //           ? getDistancePrices(List.from(
                              //                   _con.restaurant.deliveryFee)
                              //               .map((element) =>
                              //                   DistancePrice.fromJSON(element))
                              //               .toSet()
                              //               .toList())
                              //           : Container(),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 100),
                              _con.reviews.isEmpty
                                  ? SizedBox(height: 5)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.recent_actors,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          S.of(context).what_they_say,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                    ),
                              _con.reviews.isEmpty
                                  ? SizedBox(height: 5)
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: ReviewsListWidget(
                                          reviewsList: _con.reviews),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 32,
                      left: 20,
                      child: ShoppingCartFloatButtonWidget(
                          iconColor: Theme.of(context).primaryColor,
                          labelColor: Theme.of(context).hintColor,
                          routeArgument: RouteArgument(
                              id: '0',
                              param: _con.restaurant.id,
                              heroTag: 'home_slide')),
                    ),
                  ],
                ),
        ));
  }

  Widget getDistancePrices(List<DistancePrice> distancePrices) {
    return Column(
        children: distancePrices.map((DistancePrice distancePrice) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Theme.of(context).primaryColor,
        child: ListTile(
          title: Text(distancePrice.from.toString() +
              ' - ' +
              distancePrice.to.toString() +
              ' كم '),
          trailing: Text(
            distancePrice.price.toString() + ' دينار ' ?? ' ',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      );
    }).toList());
  }
}
