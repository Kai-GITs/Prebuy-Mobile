import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:prebuy_mob/screens/menu.dart';
import 'package:prebuy_mob/utils/constants.dart';
import 'package:prebuy_mob/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class NewsListFormPage extends StatefulWidget {
  final String username;

  const NewsListFormPage({super.key, required this.username});

  @override
  State<NewsListFormPage> createState() => _NewsListFormPageState();
}

class _NewsListFormPageState extends State<NewsListFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  String? _selectedCategory;
  bool _isFeatured = false;
  bool _isSubmitting = false;

  final List<Map<String, String>> _categories = const [
    {"value": "cap", "label": "Cap"},
    {"value": "jersey", "label": "Jersey"},
    {"value": "card", "label": "Card"},
    {"value": "ball", "label": "Ball"},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  Future<void> _submit(CookieRequest request) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final response = await request.postJson(
      createNewsUrl,
      jsonEncode({
        "name": _nameController.text.trim(),
        "price": _priceController.text.trim(),
        "description": _descriptionController.text.trim(),
        "category": _selectedCategory,
        "thumbnail": _thumbnailController.text.trim(),
        "is_featured": _isFeatured,
      }),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News successfully saved!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(username: widget.username),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Something went wrong, please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: LeftDrawer(username: widget.username),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Item',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Harga wajib diisi';
                }
                final parsed = int.tryParse(value.trim());
                if (parsed == null || parsed < 0) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategory,
              items: _categories
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e["value"],
                      child: Text(e["label"]!),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
              validator: (value) => value == null ? 'Pilih kategori' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _thumbnailController,
              decoration: const InputDecoration(
                labelText: 'URL Thumbnail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi wajib diisi';
                }
                return null;
              },
            ),
            SwitchListTile(
              value: _isFeatured,
              title: const Text('Featured Item'),
              onChanged: (value) => setState(() => _isFeatured = value),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : () => _submit(request),
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan Item'),
            ),
          ],
        ),
      ),
    );
  }
}
