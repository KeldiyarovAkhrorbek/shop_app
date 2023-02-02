import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartModel> product_items;
  final DateTime time;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.product_items,
      required this.time});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? token;
  final String? userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get orderCount {
    return _orders.length;
  }

  Future<void> addOrder(List<CartModel> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shopapp-2256b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            product_items: cartProducts,
            time: timeStamp));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shopapp-2256b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    var response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          product_items: (orderData['products'] as List<dynamic>)
              .map((item) => CartModel(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList(),
          time: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
