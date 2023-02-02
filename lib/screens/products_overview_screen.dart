import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // var products = Provider.of<Products>(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.All) {
                    _showOnlyFavorite = false;
                  } else if (value == FilterOptions.Favorites) {
                    _showOnlyFavorite = true;
                  }
                });
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    const PopupMenuItem(
                      child: Text('Show all'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (ctx, cart, _child) => Badge(
                child: _child as Widget,
                value: cart.itemCount.toString(),
                color: Colors.red),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorite),
    );
  }
}
