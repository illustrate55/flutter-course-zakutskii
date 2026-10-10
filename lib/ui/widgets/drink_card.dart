import 'package:flutter/material.dart';

import '../../domain/entities/drink.dart';

class DrinkCard extends StatelessWidget {
  final Drink drink;
  final bool isLiked;
  final VoidCallback onLikeTap;

  const DrinkCard({
    super.key,
    required this.drink,
    required this.isLiked,
    required this.onLikeTap,
  });

  String get _categoryLabel => switch (drink.category) {
        DrinkCategory.coffee => 'Кофе',
        DrinkCategory.tea => 'Чай',
      };

  IconData get _categoryIcon => switch (drink.category) {
        DrinkCategory.coffee => Icons.coffee,
        DrinkCategory.tea => Icons.emoji_food_beverage,
      };

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

  Widget _gradientBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(drink.colorStart), Color(drink.colorEnd)],
        ),
      ),
    );
  }

  /// Обложка: Stack из трёх слоёв.
  Widget _buildCover() {
    final hasImage = drink.image != null;

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // 1. Фон: фото, а если его нет или файл не найден, то градиент
          hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    drink.image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _gradientBackground(),
                  ),
                )
              : _gradientBackground(),
          // 2. Первая буква названия по центру (только если нет фото)
          if (!hasImage)
            Center(
              child: Text(
                drink.title[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          // 3. Сердечко в правом верхнем углу: нажатие уходит наверх через колбэк
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
                _categoryLabel,
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