import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    // GET /shops
    http.Response response = await http.get("http://$serverIP:3000/shops");

    // 200, [ {} ]
    if (response.statusCode == 200) {
      // decode JSON
      List<dynamic> jsonData = json.decode(response.body);

      // map each json object to Shop
      return jsonData.map((e) => Shop.fromJson(e)).toList();
    } else {
      throw Exception("Server Error");
    }
  }

  static Future<Shop> fetchShop(String id) async {
    await Future.delayed(Duration(seconds: 2));

    var p = _shops.singleWhere((element) => element.id == id);

    return p;
  }

  static Future<List<CartItem>> loadCart() async {
    // /cart
    http.Response response = await http.get('http://$serverIP:3000/cart');

    // status 200, [ {} ]
    if (response.statusCode == 200) {
      // decode body
      List<dynamic> decodedJson = json.decode(response.body);

      // map each json object to cart item object
      return decodedJson.map((e) => CartItem.fromJson(e)).toList();
    } else {
      throw Exception("Server Error");
    }
  }

  static Future<String> addToCart(Map<String, dynamic> jsonData) async {
    http.Response response = await http.post('http://$serverIP:3000/cart',
        headers: {"Content-Type": "application/json"},
        body: json.encode(jsonData));

    if (response.statusCode == 201) {
      return response.headers["location"].replaceFirst("/cart/", "");
    } else {
      throw Exception("Server Error");
    }
  }

  static Future<void> updateCartItem(id, Map<String, dynamic> jsonData) async {
    http.Response response = await http.patch('http://$serverIP:3000/cart/$id',
        headers: {"Content-Type": "application/json"},
        body: json.encode(jsonData));

    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }
  }

  static Future<void> removeFromCart(String id) async {
    // DELETE /cart/ID
    http.Response response =
        await http.delete('http://$serverIP:3000/cart/$id');

    // 200
    if (response.statusCode != 200) {
      throw Exception("Server Error");
    }
  }

  static Future<void> placeOrder(Map<String, dynamic> jsonData) async {
    // /orders --> { address: ID }

    http.Response response = await http.post("http://$serverIP:3000/orders",
        headers: {"Content-Type": "application/json"},
        body: json.encode(jsonData));

    // 201, location HEADER
    if (response.statusCode != 201) {
      throw Exception("Server Error");
    }
  }
}
