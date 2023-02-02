import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Your products',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, products, _) => products.items.length == 0
                          ? Center(
                              child: Text(
                                'You have no orders',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListView.builder(
                                itemBuilder: (_, i) => Column(
                                  children: [
                                    UserProductItem(products.items[i]),
                                    const Divider(),
                                  ],
                                ),
                                itemCount: products.items.length,
                              ),
                            ),
                    ),
                  ),
      ),
    );
  }
}
