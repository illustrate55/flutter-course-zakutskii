import 'package:flutter/material.dart';
import '../../domain/entities/drink.dart';

class DrinkCard extends StatelessWidget {
  final Drink drink;
  final bool isLiked;
  final VoidCallback onLikeTap;
  final VoidCallback onTap;

  const DrinkCard({
    super.key,
    required this.drink,
    required this.isLiked,
    required this.onLikeTap,
    required this.onTap,
  });

  IconData get _categoryIcon {
    switch (drink.category.toLowerCase()) {
      case 'кофе': return Icons.coffee;
      case 'чай': return Icons.emoji_food_beverage;
      case 'выпечка': return Icons.bakery_dining;
      case 'десерты': return Icons.cake;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }

  Widget _buildCover() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // Фон (используем coverColor из новой модели)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(drink.coverColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                drink.title.isNotEmpty ? drink.title[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Сердечко
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: onLikeTap,
              iconSize: 18,
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black38,
                minimumSize: const Size(32, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.redAccent : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          drink.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          drink.subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(_categoryIcon, size: 18, color: primary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                drink.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: primary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}