import 'package:flutter/cupertino.dart';

class Shop {
  final String id, name, image;
  final List<ShopItem> items;

  Shop({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.items,
  });

  Shop.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData["id"],
        name = jsonData["name"],
        image = jsonData["image"],
        items = (jsonData["items"] as List<dynamic>)
            .map((e) => ShopItem.fromJson(e))
            .toList();
}

class ShopItem {
  final name, image, price, discountPrice;

  ShopItem({
    @required this.name,
    @required this.image,
    @required this.price,
    this.discountPrice,
  });

  ShopItem.fromJson(Map<String, dynamic> jsonData)
      : name = jsonData["name"],
        image = jsonData["image"],
        price = jsonData["price"],
        discountPrice = jsonData["discountPrice"];
}
