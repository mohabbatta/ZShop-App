import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import './cart_states.dart';
import '../../api/api.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';

class CartCubit extends Cubit<CartState> {
  List<CartItem> _items = [];

  CartCubit() : super(CartInitial());

  void loadCart() async {
    emit(LoadingCart());

    try {
      _items = await Api.loadCart();

      emit(CartLoaded(_items));
    } catch (ex) {
      CartFailure(ex.message);
    }
  }

  void addToCart(Product product) async {
    bool isNew = true;
    emit(AddingToCart());

    CartItem item = _items.firstWhere(
        (element) => element.productId == product.id,
        orElse: () => null);

    if (item != null) {
      item.count++;

      item.dateOfPurchase = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
          .format(DateTime.now());

      isNew = false;
    } else {
      item = CartItem(
          count: 1,
          productId: product.id,
          name: product.name,
          price: "0",
          image: product.image,
          dateOfPurchase: DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
              .format(DateTime.now()));
    }

    item.price = product.discountPrice ?? product.price;
    item.shopId = product.shops
        .firstWhere((element) => element.price == item.price,
            orElse: () => null)
        ?.shopId;

    try {
      if (isNew) {
        item.id = await Api.addToCart(item.toJson());
        _items.add(item);
      } else {
        Map<String, dynamic> jsonData = {};

        jsonData["count"] = item.count;
        jsonData["date"] = item.dateOfPurchase;
        jsonData["price"] = item.price;
        jsonData["shopId"] = item.shopId;

        await Api.updateCartItem(item.id, jsonData);
      }

      emit(AddedToCart());

      loadCart();
    } catch (ex) {
      CartFailure(ex.message);
    }
  }

  void removeFromCart(CartItem item) async {
    emit(RemovingFromToCart());

    try {
      await Api.removeFromCart(item.id);

      _items.removeWhere((i) => i.id == item.id);

      emit(RemovedFromToCart());

      loadCart();
    } catch (ex) {
      CartFailure(ex.message);
    }
  }

  void placeOrder() async {
    try {
      Map<String, dynamic> jsonData = {};

      jsonData["address"] = 1;

      await Api.placeOrder(jsonData);

      _items.clear();

      emit(OrderPlaced());

      loadCart();
    } catch (ex) {
      OrderFailure(ex.message);
    }
  }
}
