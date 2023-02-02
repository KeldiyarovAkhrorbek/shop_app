import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage.assetNetwork(
              image: product.imageUrl,
              placeholder: 'lib/assets/images/placeholder.png',
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                splashRadius: 15,
                onPressed: () {
                  product.toggleFavoriteStatus(authData.token, authData.userId);
                },
                color: Theme.of(context).accentColor,
              ),
              // child:
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                splashRadius: 15,
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(
                      'Added item to card',
                      // textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                },
                color: Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }
}
