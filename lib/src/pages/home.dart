import 'package:flutter/material.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/EmptyRestaurantWidget.dart';
import '../repository/restaurant_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/CardWidget.dart';
import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/HomeSliderWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: _con.loading.value
          ? CircularLoadingWidget(
              height: 500,
            )
          : _con.length.value == 0
              ? EmptyRestaurantWidget()
              : RefreshIndicator(
                  onRefresh: _con.refreshHome,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                          settingsRepo.setting.value.homeSections.length,
                          (index) {
                        String _homeSection = settingsRepo
                            .setting.value.homeSections
                            .elementAt(index);
                        switch (_homeSection) {
                          case 'slider':
                            return HomeSliderWidget(slides: _con.slides);
                          case 'search':
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SearchBarWidget(
                                onClickFilter: (event) {
                                  widget.parentScaffoldKey.currentState
                                      .openEndDrawer();
                                },
                              ),
                            );
                          case 'top_restaurants_heading':
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          settingsRepo.isRestaurant.value == 1
                                              ? S
                                                  .of(context)
                                                  .featured_Restaurants
                                              : S.of(context).featured_Stores,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (settingsRepo
                                          .deliveryAddress.value?.address !=
                                      null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        S.of(context).near_to +
                                            " " +
                                            (settingsRepo.deliveryAddress.value
                                                ?.address),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          case 'top_restaurants':
                            return CardsCarouselWidget(
                              restaurantsList: _con.topRestaurants,
                              heroTag: 'home_top_restaurants',
                            );
                          case 'list_restaurants_heading':
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          settingsRepo.isRestaurant.value == 1
                                              ? S.of(context).nearby_restaurants
                                              : S.of(context).nearby_stores,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (settingsRepo
                                          .deliveryAddress.value?.address !=
                                      null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        S.of(context).near_to +
                                            " " +
                                            (settingsRepo.deliveryAddress.value
                                                ?.address),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          case 'list_restaurants':
                            return ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.popularRestaurants.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                return CardWidget(
                                    restaurant: _con.popularRestaurants
                                        .elementAt(index),
                                    heroTag: 'home_list_restaurants');
                              },
                            );
                          case 'trending_week_heading':
                            return ListTile(
                              dense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              leading: Icon(
                                Icons.trending_up,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).trending_this_week,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                S
                                    .of(context)
                                    .clickOnTheFoodToGetMoreDetailsAboutIt,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            );
                          case 'trending_week':
                            return FoodsCarouselWidget(
                                foodsList: _con.trendingFoods,
                                heroTag: 'home_food_carousel');
                          case 'categories_heading':
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.category,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).food_categories,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            );
                          case 'categories':
                            return CategoriesCarouselWidget(
                              categories: _con.categories,
                            );
                          case 'popular_heading':
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: ListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.trending_up,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).most_popular,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            );
                          case 'popular':
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GridWidget(
                                restaurantsList: _con.popularRestaurants,
                                heroTag: 'home_restaurants',
                              ),
                            );
                          case 'recent_reviews_heading':
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                leading: Icon(
                                  Icons.recent_actors,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).recent_reviews,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            );
                          case 'recent_reviews':
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ReviewsListWidget(
                                  reviewsList: _con.recentReviews),
                            );
                          default:
                            return SizedBox(height: 0);
                        }
                      }),
                    ),
                  ),
                ),
    );
  }
}
