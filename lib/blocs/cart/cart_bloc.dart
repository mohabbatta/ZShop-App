import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import './cart_states.dart';
import '../../api/api.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';

class CartCubit extends Cubit<CartState> {
  final List<CartItem> _items = [];

  CartCubit() : super(CartInitial());

  void loadCart() async {
    emit(LoadingCart());

    try {
      List<CartItem> items = await Api.loadCart();

      emit(CartLoaded(items));
    } catch (ex) {
      CartFailure(ex.message);
    }
  }

  void addToCart(Product product) async {
    emit(AddingToCart());

    CartItem item = _items.firstWhere(
        (element) => element.productId == product.id,
        orElse: () => null);

    if (item != null) {
      item.count++;

      item.dateOfPurchase = DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
          .format(DateTime.now());
    } else {
      item = CartItem(
          count: 1,
          productId: product.id,
          name: product.name,
          price: "0",
          image: product.image,
          dateOfPurchase: DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
              .format(DateTime.now()));

      // _items.add(item);
    }

    item.price = product.discountPrice ?? product.price;
    item.shopId = product.shops
        .firstWhere((element) => element.price == item.price,
            orElse: () => null)
        ?.shopId;

    try {
      item.id = await Api.addToCart(item.toJson());
      _items.add(item);

      emit(AddedToCart());

      loadCart();
    } catch (ex) {
      CartFailure(ex.message);
    }
  }

  void removeFromCart(CartItem item) async {
    emit(RemovingFromToCart());

    try {
      await Api.removeFromCart(item);

      emit(RemovedFromToCart());

      loadCart();
    } catch (ex) {
      CartFailure(ex.message);
    }
  }

  void placeOrder() async {
    try {
      await Api.placeOrder();

      emit(OrderPlaced());

      loadCart();
    } catch (ex) {
      OrderFailure(ex.message);
    }
  }
}
