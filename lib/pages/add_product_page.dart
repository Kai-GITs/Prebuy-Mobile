import 'package:flutter/material.dart';
import 'package:prebuy_mob/models/product.dart';
import 'package:prebuy_mob/models/product_store.dart';
import 'package:prebuy_mob/widgets/left_drawer.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  double _rating = 3.0;
  bool _available = true;
  bool _onSale = false;

  final List<String> _categories = const [
    'Sports',
    'News',
    'Merchandise',
    'Ticket',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _amountController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
      _rating = 3.0;
      _available = true;
      _onSale = false;
    });
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        name: _nameController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        amount: int.parse(_amountController.text.trim()),
        category: _selectedCategory ?? '-',
        description: _descriptionController.text.trim(),
        rating: _rating,
        available: _available,
        onSale: _onSale,
      );

      ProductStore.products.add(product);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Product Saved'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Name: ${product.name}'),
                  Text('Price: ${product.price}'),
                  Text('Amount: ${product.amount}'),
                  Text('Category: ${product.category}'),
                  Text('Rating: ${product.rating.toStringAsFixed(1)}'),
                  Text('Available: ${product.available ? 'Yes' : 'No'}'),
                  Text('On Sale: ${product.onSale ? 'Yes' : 'No'}'),
                  const SizedBox(height: 8),
                  const Text('Description:'),
                  Text(product.description),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
        _clearForm();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Price is required';
                }
                final parsed = int.tryParse(value.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid non-negative number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount is required';
                }
                final parsed = int.tryParse(value.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid non-negative number';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategory,
              items: _categories
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
              validator: (value) => value == null ? 'Select a category' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rating'),
                Slider(
                  value: _rating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _rating.toStringAsFixed(1),
                  onChanged: (v) => setState(() => _rating = v),
                ),
              ],
            ),
            SwitchListTile(
              value: _available,
              title: const Text('Available'),
              onChanged: (v) => setState(() => _available = v),
            ),
            CheckboxListTile(
              value: _onSale,
              title: const Text('On Sale'),
              onChanged: (v) => setState(() => _onSale = v ?? false),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: const Text('Save Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

