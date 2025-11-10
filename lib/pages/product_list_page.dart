import 'package:flutter/material.dart';
import 'package:prebuy_mob/models/product_store.dart';
import 'package:prebuy_mob/models/product.dart';
import 'package:prebuy_mob/widgets/left_drawer.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = ProductStore.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Products',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: products.isEmpty
            ? const Center(
                child: Text('No products yet. Add some from the form!'),
              )
            : ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final Product p = products[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(p.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${p.category}'),
                          Text('Price: ${p.price} | Amount: ${p.amount}'),
                          Text('Rating: ${p.rating.toStringAsFixed(1)}'),
                          Text(
                            p.available ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              color: p.available ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

