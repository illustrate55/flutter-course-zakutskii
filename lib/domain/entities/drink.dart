enum DrinkCategory { coffee, tea }

class Drink {
  final int id;
  final String title;
  final String subtitle;
  final DrinkCategory category;
  final String? description;
  final String? image; // путь к фото в assets, может быть null
  final int colorStart; // цвета хранятся как int, например 0xFF5D4037
  final int colorEnd;

  const Drink({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.description,
    this.image,
    required this.colorStart,
    required this.colorEnd,
  });
}