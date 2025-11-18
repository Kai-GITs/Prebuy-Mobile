import 'package:flutter/material.dart';
import 'package:prebuy_mob/models/news_entry.dart';
import 'package:prebuy_mob/utils/constants.dart';
import 'package:prebuy_mob/widgets/left_drawer.dart';

class NewsDetailPage extends StatelessWidget {
  final String username;
  final NewsEntry entry;

  const NewsDetailPage({super.key, required this.username, required this.entry});

  String _proxyUrl(String? raw) {
    if (raw == null || raw.isEmpty) {
      return "";
    }
    return '$proxyImageUrl?url=${Uri.encodeComponent(raw)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          entry.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: LeftDrawer(username: username),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (entry.thumbnail != null && entry.thumbnail!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _proxyUrl(entry.thumbnail),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  size: 120,
                ),
              ),
            )
          else
            const SizedBox(
              height: 120,
              child: Icon(Icons.image_not_supported, size: 80),
            ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Harga: ${entry.price}'),
                  Text('Kategori: ${entry.category}'),
                  Text('Featured: ${entry.isFeatured ? "Ya" : "Tidak"}'),
                  Text('Jumlah dilihat: ${entry.newsViews}'),
                  if (entry.createdAt != null)
                    Text('Tanggal dibuat: ${entry.createdAt}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(entry.description),
                  const SizedBox(height: 16),
                  Text('Pemilik item: ${entry.userUsername ?? "-"}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke daftar item'),
          ),
        ],
      ),
    );
  }
}
