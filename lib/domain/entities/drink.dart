import 'dart:ui' show Color;

enum DrinkCategory { coffee, tea }

class Drink {
  final String id; // MockAPI выдаёт id строкой: "1", "2", ...
  final String title;
  final String subtitle;
  final DrinkCategory category;
  final String description;
  final String image; // путь к фото в assets, пустая строка = нет фото
  final Color color;

  const Drink({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.description,
    required this.image,
    required this.color,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      category: DrinkCategory.values.byName(json['category'] as String),
      description: json['description'] as String,
      image: json['image'] as String,
      color: Color(int.parse('FF${json['color']}', radix: 16)),
    );
  }

  /// id не отправляем: его выдаёт сервер.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'category': category.name,
      'description': description,
      'image': image,
      'color': color.toARGB32().toRadixString(16).substring(2).toUpperCase(),
    };
  }
}