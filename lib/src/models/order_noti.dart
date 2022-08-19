class OrderNotification {
  String restaurantId;
  int createdAt;
  String id;
  int order_status_id;

  OrderNotification({this.restaurantId, this.id, this.order_status_id});

  OrderNotification.fromJson(Map<String, dynamic> json) {
   createdAt = json['created_at'] != null ? json['created_at'] : 0;
    order_status_id = json['order_status_id'] != null ? json['order_status_id'] : 0;
   restaurantId = json['restaurantId'] != null ? json['restaurantId'] : "";
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['order_status_id'] = this.order_status_id;

    return data;
  }
}
