import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:prebuy_mob/models/news_entry.dart';
import 'package:prebuy_mob/screens/news_detail.dart';
import 'package:prebuy_mob/utils/constants.dart';
import 'package:prebuy_mob/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class NewsEntryListPage extends StatefulWidget {
  final String username;
  final bool onlyMine;
  final String title;

  const NewsEntryListPage({
    super.key,
    required this.username,
    required this.onlyMine,
    required this.title,
  });

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  Future<List<NewsEntry>>? _entriesFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      setState(() {
        _entriesFuture = _fetchEntries(request);
      });
    });
  }

  Future<List<NewsEntry>> _fetchEntries(CookieRequest request) async {
    final url = widget.onlyMine ? newsListMineUrl : newsListAllUrl;
    final List<dynamic> response = await request.get(url);
    return response.map((raw) => NewsEntry.fromJson(raw)).toList();
  }

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
        title: Text(widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: LeftDrawer(username: widget.username),
      body: _entriesFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<NewsEntry>>(
              future: _entriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal memuat data: ${snapshot.error}'),
                  );
                }
                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return const Center(
                    child: Text('Belum ada item. Tambahkan dari menu tambah item!'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = data[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailPage(
                                username: widget.username,
                                entry: entry,
                              ),
                            ),
                          );
                        },
                        leading: entry.thumbnail != null && entry.thumbnail!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _proxyUrl(entry.thumbnail),
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                                ),
                              )
                            : CircleAvatar(
                                child: Text(entry.name.isNotEmpty ? entry.name[0] : '?'),
                              ),
                        title: Text(entry.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kategori: ${entry.category}'),
                            Text('Harga: ${entry.price}'),
                            Text(
                              entry.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: entry.isFeatured
                            ? const Icon(Icons.star, color: Colors.amber)
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
