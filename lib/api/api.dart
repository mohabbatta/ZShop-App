import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/shop.dart';

class Api {
  static String serverIP = '127.0.0.1';

  static int _lastId = 0;

  static List<Shop> _shops = [
    Shop(
        id: "1",
        name: 'Carrefour',
        image: 'assets/images/carrefour.jpg',
        items: [
          ShopItem(
            name: 'Juhayana Full Cream Milk',
            price: '15.70',
            image: 'assets/images/juhayna.jpg_480Wx480H',
          ),
          ShopItem(
            name: 'Heinz Tomato Paste',
            price: '10.75',
            image: 'assets/images/Heinz.jpg_480Wx480H',
          ),
          ShopItem(
            name: 'Nestle Quality Street Chocolate',
            price: '170',
            discountPrice: '145.95',
            image:
                'assets/images/Nestle Quality Street Chocolate.jpg_480Wx480H',
          ),
        ]),
    Shop(
        id: '2',
        name: 'Hyperone',
        image: 'assets/images/hyperone.png',
        items: [
          ShopItem(
            name: 'Pampers',
            price: '160',
            image: 'assets/images/Pampers.jpg_480Wx480H',
          ),
          ShopItem(
            name: 'Heinz Tomato Paste',
            price: '12',
            image: 'assets/images/Heinz.jpg_480Wx480H',
          ),
        ]),
    Shop(
        id: '3',
        name: 'Spinneys',
        image: 'assets/images/spinneys.png',
        items: [
          ShopItem(
            name: 'Pampers',
            price: '160.01',
            image: 'assets/images/Pampers.jpg_480Wx480H',
          ),
          ShopItem(
            name: 'Heinz Tomato Paste',
            price: '11',
            image: 'assets/images/Heinz.jpg_480Wx480H',
          ),
        ]),
  ];

  static List<CartItem> _items = [];

  static Future<List<Product>> fetchProducts() async {
    http.Response response = await http.get('http://${serverIP}:3000/products');

    if (response.statusCode == 200) {
      List<dynamic> productsJsonData = json.decode(response.body);
      return productsJsonData.map((e) => Product.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<Product> fetchProduct(String id) async {
    http.Response response =
        await http.get('http://${serverIP}:3000/products/${id}');

    if (response.statusCode == 200) {
      print(response.body);
      dynamic jsonData = json.decode(response.body);
      return Product.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Server Error');
    }
  }

  static Future<List<Shop>> fetchShops() async {
    await Future.delayed(Duration(seconds: 2));

    return _shops;
  }

  static Future<Shop> fetchShop(String id) async {
    await Future.delayed(Duration(seconds: 2));

    var p = _shops.singleWhere((element) => element.id == id);

    return p;
  }

  static Future<List<CartItem>> loadCart() async {
    await Future.delayed(Duration(seconds: 2));

    return _items;
  }

  static Future<void> addToCart(Product product) async {
    await Future.delayed(Duration(seconds: 1));

    CartItem item = _items.firstWhere(
        (element) => element.productId == product.id,
        orElse: () => null);

    if (item != null) {
      item.count++;

      item.dateOfPurchase = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
          .format(DateTime.now());
    } else {
      item = CartItem(
          id: (_lastId++).toString(),
          count: 1,
          productId: product.id,
          name: product.name,
          price: "0",
          image: product.image,
          dateOfPurchase: DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
              .format(DateTime.now()));

      _items.add(item);
    }

    item.price = product.discountPrice ?? product.price;
    item.shopId = product.shops
        .firstWhere((element) => element.price == item.price,
            orElse: () => null)
        ?.shopId;
  }

  static Future<void> removeFromCart(CartItem item) async {
    await Future.delayed(Duration(seconds: 2));

    _items.remove(item);
  }

  static Future<void> placeOrder() async {
    await Future.delayed(Duration(seconds: 2));

    _items.clear();
  }
}
