import 'package:flutter/material.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Кофе и чай',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: const CatalogScreen(),
    );
  }
}

/// Модель одной карточки каталога.
class CatalogItem {
  final String title;
  final String subtitle;
  final IconData categoryIcon;
  final String categoryLabel;
  final bool liked;
  final Color colorStart;
  final Color colorEnd;

  const CatalogItem({
    required this.title,
    required this.subtitle,
    required this.categoryIcon,
    required this.categoryLabel,
    required this.liked,
    required this.colorStart,
    required this.colorEnd,
  });
}

const List<CatalogItem> items = [
  CatalogItem(
    title: 'Эспрессо',
    subtitle: 'Крепкий и насыщенный, классика итальянской кухни',
    categoryIcon: Icons.coffee,
    categoryLabel: 'Кофе',
    liked: true,
    colorStart: Color(0xFF5D4037),
    colorEnd: Color(0xFF8D6E63),
  ),
  CatalogItem(
    title: 'Капучино',
    subtitle: 'Эспрессо, молоко и плотная молочная пенка',
    categoryIcon: Icons.coffee,
    categoryLabel: 'Кофе',
    liked: false,
    colorStart: Color(0xFF8D6E63),
    colorEnd: Color(0xFFD7CCC8),
  ),
  CatalogItem(
    title: 'Латте',
    subtitle: 'Нежный вкус с большим количеством молока',
    categoryIcon: Icons.coffee,
    categoryLabel: 'Кофе',
    liked: true,
    colorStart: Color(0xFFA1887F),
    colorEnd: Color(0xFFEFEBE9),
  ),
  CatalogItem(
    title: 'Зелёный чай сенча с жасмином и лепестками цветов',
    subtitle: 'Лёгкий травянистый вкус и цветочный аромат',
    categoryIcon: Icons.emoji_food_beverage,
    categoryLabel: 'Чай',
    liked: false,
    colorStart: Color(0xFF2E7D32),
    colorEnd: Color(0xFF81C784),
  ),
  CatalogItem(
    title: 'Чёрный чай Эрл Грей',
    subtitle: 'С ароматом бергамота, отлично подходит к завтраку',
    categoryIcon: Icons.emoji_food_beverage,
    categoryLabel: 'Чай',
    liked: true,
    colorStart: Color(0xFF3E2723),
    colorEnd: Color(0xFF795548),
  ),
  CatalogItem(
    title: 'Матча',
    subtitle: 'Порошковый зелёный чай из Японии',
    categoryIcon: Icons.eco,
    categoryLabel: 'Чай',
    liked: true,
    colorStart: Color(0xFF558B2F),
    colorEnd: Color(0xFFC5E1A5),
  ),
  CatalogItem(
    title: 'Американо',
    subtitle: 'Эспрессо, разбавленный горячей водой',
    categoryIcon: Icons.coffee,
    categoryLabel: 'Кофе',
    liked: false,
    colorStart: Color(0xFF4E342E),
    colorEnd: Color(0xFF6D4C41),
  ),
  CatalogItem(
    title: 'Улун молочный',
    subtitle: 'Сливочный вкус и мягкое послевкусие',
    categoryIcon: Icons.emoji_food_beverage,
    categoryLabel: 'Чай',
    liked: false,
    colorStart: Color(0xFF00897B),
    colorEnd: Color(0xFF80CBC4),
  ),
  CatalogItem(
    title: 'Флэт уайт',
    subtitle: 'Двойной эспрессо с бархатистым молоком',
    categoryIcon: Icons.coffee,
    categoryLabel: 'Кофе',
    liked: true,
    colorStart: Color(0xFF6D4C41),
    colorEnd: Color(0xFFBCAAA4),
  ),
];

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофе и чай'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) => CatalogCard(item: items[index]),
      ),
    );
  }
}

class CatalogCard extends StatelessWidget {
  final CatalogItem item;

  const CatalogCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCover(),
            const SizedBox(width: 12),
            Expanded(child: _buildTextBlock(context)),
          ],
        ),
      ),
    );
  }

  /// Обложка: Stack из трёх слоёв.
  Widget _buildCover() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // 1. Цветной фон с градиентом
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [item.colorStart, item.colorEnd],
              ),
            ),
          ),
          // 2. Первая буква названия по центру
          Center(
            child: Text(
              item.title[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // 3. Значок лайка в правом верхнем углу
          Positioned(
            top: 6,
            right: 6,
            child: Icon(
              item.liked ? Icons.favorite : Icons.favorite_border,
              size: 22,
              color: item.liked ? Colors.redAccent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Текстовый блок: название, подпись, категория.
  Widget _buildTextBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          item.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              item.categoryIcon,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                item.categoryLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}