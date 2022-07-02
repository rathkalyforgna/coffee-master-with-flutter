import 'package:coffee_masters/datamanager.dart';
import 'package:coffee_masters/datamodel.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  final DataManager dataManager;

  const MenuPage({Key? key, required this.dataManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataManager.getMenu(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          var categories = snapshot.data! as List<Category>;
          // print(categories);

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(categories[index].name),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: categories[index].products.length,
                      itemBuilder: ((context, productIndex) {
                        var product = categories[index].products[productIndex];

                        return ProductItem(
                            product: product,
                            onAdd: (p) {
                              dataManager.cartAdd(p);
                            });
                      })),
                ],
              );
            }),
          );
        } else {
          if (snapshot.hasError) {
            return const Text("Uh oh, there's an error");
          } else {
            return const CircularProgressIndicator();
          }
        }
      }),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final Function onAdd;

  const ProductItem({Key? key, required this.product, required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("\$${product.price.toStringAsFixed(2)} ea"),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onAdd(product);
                    },
                    child: const Text("Add"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
