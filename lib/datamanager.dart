import 'dart:convert';

import 'datamodel.dart';
import 'package:http/http.dart' as http;

class DataManager {
  List<Category>? _menu;
  List<ItemInCart> carts = [];

  fetchMenu() async {
    try {
      const url = 'https://firtman.github.io/coffeemasters/api/menu.json';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _menu = [];
        var decodedData = jsonDecode(response.body) as List<dynamic>;
        for (var json in decodedData) {
          _menu?.add(Category.fromJson(json));
        }
      } else {
        throw Exception("Error loading data");
      }
    } catch (e) {
      throw Exception("Error loading data");
    }
  }

  Future<List<Category>> getMenu() async {
    if (_menu == null) {
      await fetchMenu();
    }

    return _menu!;
  }

  cartAdd(Product product) {
    bool found = false;

    for (var item in carts) {
      if (item.product.id == product.id) {
        item.quantity++;
        found = true;
      }
    }

    if (!found) {
      carts.add(ItemInCart(product: product, quantity: 1));
    }
  }

  cartRemove(Product product) {
    carts.removeWhere((item) => item.product.id == product.id);
  }

  cartClear() {
    carts.clear();
  }

  double cartTotal() {
    double total = 0;

    for (var item in carts) {
      total += item.quantity * item.product.price;
    }

    return total;
  }
}
