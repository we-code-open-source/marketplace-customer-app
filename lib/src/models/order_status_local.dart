class OrderStatusLocal {
  String id;
  String status;
  String key;
  int index;
  bool check;

  OrderStatusLocal(this.id, this.status, this.key, this.index, this.check);
}

class OrderStatusLocalList {
  List<OrderStatusLocal> list = [
    new OrderStatusLocal("1", 'تم استلام طلبك', 'order_received', 1, true),
    new OrderStatusLocal(
        "20", 'في انتظار موافقة المطعم', 'waiting_for_restaurant', 2, false),
    new OrderStatusLocal("30", 'تم قبول طلبك من قبل المطعم',
        'accepted_from_restaurant', 3, false),
    // new OrderStatusLocal(
    //     "10", 'طلبك قيد التحضير', 'waiting_for_drivers', 4, false),
    new OrderStatusLocal("40", 'السائق في طريقه للمطعم', 'driver_assigned', 4, false),
    new OrderStatusLocal("45", 'السائق وصل للمطعم', 'driver_arrived_restaurant', 5, false),
    new OrderStatusLocal(
        "50", 'السائق استلم طلبك من المطعم', 'driver_pick_up', 6, false),
    new OrderStatusLocal("60", 'السائق في طريق', 'on_the_way', 7, false),
    new OrderStatusLocal(
        "70", 'السائق قد وصل المكان المحدد للزبون', 'driver_arrived', 8, false),
    new OrderStatusLocal(
        "80", 'تم تسليم الطلب للزبون بنجاح', 'delivered', 9, false),
  ];
}
