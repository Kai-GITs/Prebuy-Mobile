import 'package:flutter/material.dart';
import 'package:prebuy_mob/screens/news_entry_list.dart';
import 'package:prebuy_mob/screens/newslist_form.dart';
import 'package:prebuy_mob/widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  final String username;

  MyHomePage({super.key, required this.username});

  final String npm = "2406360256";
  final String kelas = "C";

  final List<ItemHomepage> items = [
    ItemHomepage("All Products", Icons.apps, Colors.blue),
    ItemHomepage("Create Products", Icons.add_business, Colors.orange),
    ItemHomepage("My Products", Icons.account_box_rounded, Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PreBuy Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: LeftDrawer(username: username),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'Username', content: username),
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),
            const SizedBox(height: 16.0),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Halo! Pilih aksi untuk mengelola news item kamu.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                GridView.count(
                  primary: true,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: items.map((ItemHomepage item) {
                    return ItemCard(item: item, username: username);
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final String username;

  const ItemCard({super.key, required this.item, required this.username});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu membuka menu ${item.name}")),
            );

          if (item.name == 'Create Products') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsListFormPage(username: username),
              ),
            );
          } else if (item.name == 'All Products') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsEntryListPage(
                  username: username,
                  onlyMine: false,
                  title: 'All Products',
                ),
              ),
            );
          } else if (item.name == 'My Products') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsEntryListPage(
                  username: username,
                  onlyMine: true,
                  title: 'My Products',
                ),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
