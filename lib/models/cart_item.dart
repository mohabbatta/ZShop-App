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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = {};

    jsonData["productId"] = productId;
    jsonData["name"] = name;
    jsonData["price"] = price;
    jsonData["image"] = image;
    jsonData["date"] = dateOfPurchase;

    return jsonData;
  }
}
