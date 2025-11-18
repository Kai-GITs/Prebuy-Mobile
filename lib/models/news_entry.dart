import 'dart:convert';

List<NewsEntry> newsEntryListFromJson(String str) =>
    List<NewsEntry>.from(json.decode(str).map((x) => NewsEntry.fromJson(x)));

String newsEntryListToJson(List<NewsEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsEntry {
  final String id;
  final String name;
  final int price;
  final String description;
  final String category;
  final String? thumbnail;
  final bool isFeatured;
  final int newsViews;
  final DateTime? createdAt;
  final int? userId;
  final String? userUsername;

  NewsEntry({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.isFeatured,
    required this.newsViews,
    required this.createdAt,
    required this.userId,
    required this.userUsername,
  });

  factory NewsEntry.fromJson(Map<String, dynamic> json) => NewsEntry(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        price: json["price"] is int
            ? json["price"]
            : int.tryParse(json["price"].toString()) ?? 0,
        description: json["description"] ?? "",
        category: json["category"] ?? "",
        thumbnail: json["thumbnail"],
        isFeatured: json["is_featured"] ?? false,
        newsViews: json["news_views"] is int
            ? json["news_views"]
            : int.tryParse(json["news_views"].toString()) ?? 0,
        createdAt: json["created_at"] != null && json["created_at"] != ""
            ? DateTime.tryParse(json["created_at"])
            : null,
        userId: json["user_id"],
        userUsername: json["user_username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "category": category,
        "thumbnail": thumbnail,
        "is_featured": isFeatured,
        "news_views": newsViews,
        "created_at": createdAt?.toIso8601String(),
        "user_id": userId,
        "user_username": userUsername,
      };
}
