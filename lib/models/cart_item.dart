import 'package:flutter/material.dart';

class CartItem {
  String id;
  int count;
  final String productId;
  final String name;
  String price;
  final String image;
  String dateOfPurchase;
  String shopId;

  double get total => double.parse(price) * count;

  CartItem(
      {@required this.count,
      @required this.productId,
      @required this.name,
      @required this.price,
      @required this.image,
      @required this.dateOfPurchase});

  CartItem.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData["_id"],
        count = jsonData["count"],
        productId = jsonData["productId"],
        name = jsonData["name"],
        price = jsonData["price"],
        image = jsonData["image"],
        dateOfPurchase = jsonData["date"],
        shopId = jsonData["shopId"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = {};

    jsonData["productId"] = productId;
    jsonData["name"] = name;
    jsonData["price"] = price;
    jsonData["count"] = count;
    jsonData["image"] = image;
    jsonData["date"] = dateOfPurchase;
    jsonData["shopId"] = shopId;

    return jsonData;
  }
}
