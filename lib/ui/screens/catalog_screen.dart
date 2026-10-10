import 'package:flutter/material.dart';

import '../../domain/entities/drink.dart';
import '../widgets/drink_card.dart';

const List<Drink> _drinks = [
  Drink(
    id: 1,
    title: 'Эспрессо',
    subtitle: 'Крепкий и насыщенный, классика итальянской кухни',
    category: DrinkCategory.coffee,
    description: 'Готовится под давлением горячей воды из мелкого помола.',
    image: 'assets/images/espresso.jpg',
    colorStart: 0xFF5D4037,
    colorEnd: 0xFF8D6E63,
  ),
  Drink(
    id: 2,
    title: 'Капучино',
    subtitle: 'Эспрессо, молоко и плотная молочная пенка',
    category: DrinkCategory.coffee,
    image: 'assets/images/cappuccino.jpg',
    colorStart: 0xFF8D6E63,
    colorEnd: 0xFFD7CCC8,
  ),
  Drink(
    id: 3,
    title: 'Латте',
    subtitle: 'Нежный вкус с большим количеством молока',
    category: DrinkCategory.coffee,
    image: 'assets/images/latte.jpg',
    colorStart: 0xFFA1887F,
    colorEnd: 0xFFEFEBE9,
  ),
  Drink(
    id: 4,
    title: 'Зелёный чай сенча с жасмином и лепестками цветов',
    subtitle: 'Лёгкий травянистый вкус и цветочный аромат',
    category: DrinkCategory.tea,
    description: 'Японский зелёный чай, ароматизированный жасмином.',
    image: 'assets/images/green_tea.jpg',
    colorStart: 0xFF2E7D32,
    colorEnd: 0xFF81C784,
  ),
  Drink(
    id: 5,
    title: 'Чёрный чай Эрл Грей',
    subtitle: 'С ароматом бергамота, отлично подходит к завтраку',
    category: DrinkCategory.tea,
    image: 'assets/images/earl_grey.jpg',
    colorStart: 0xFF3E2723,
    colorEnd: 0xFF795548,
  ),
  Drink(
    id: 6,
    title: 'Матча',
    subtitle: 'Порошковый зелёный чай из Японии',
    category: DrinkCategory.tea,
    image: 'assets/images/matcha.jpg',
    colorStart: 0xFF558B2F,
    colorEnd: 0xFFC5E1A5,
  ),
  Drink(
    id: 7,
    title: 'Американо',
    subtitle: 'Эспрессо, разбавленный горячей водой',
    category: DrinkCategory.coffee,
    image: 'assets/images/americano.jpg',
    colorStart: 0xFF4E342E,
    colorEnd: 0xFF6D4C41,
  ),
  Drink(
    id: 8,
    title: 'Улун молочный',
    subtitle: 'Сливочный вкус и мягкое послевкусие',
    category: DrinkCategory.tea,
    image: 'assets/images/oolong.jpg',
    colorStart: 0xFF00897B,
    colorEnd: 0xFF80CBC4,
  ),
  Drink(
    id: 9,
    title: 'Флэт уайт',
    subtitle: 'Двойной эспрессо с бархатистым молоком',
    category: DrinkCategory.coffee,
    image: 'assets/images/flat_white.jpg',
    colorStart: 0xFF6D4C41,
    colorEnd: 0xFFBCAAA4,
  ),
];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<int> _likedIds = {};
  bool _onlyLiked = false;

  void _toggleLike(int id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  void _toggleFilter() {
    setState(() {
      _onlyLiked = !_onlyLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Отфильтрованный список считаем здесь, отдельно не храним
    final visibleDrinks = _onlyLiked
        ? _drinks.where((drink) => _likedIds.contains(drink.id)).toList()
        : _drinks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофе и чай'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'В избранном: ${_likedIds.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _onlyLiked
                  ? FilledButton.icon(
                      onPressed: _toggleFilter,
                      icon: const Icon(Icons.favorite),
                      label: const Text('Только избранные'),
                    )
                  : OutlinedButton.icon(
                      onPressed: _toggleFilter,
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Только избранные'),
                    ),
            ),
          ),
          // ListView внутри Column обязательно оборачиваем в Expanded
          Expanded(
            child: visibleDrinks.isEmpty
                ? const Center(child: Text('Ничего не нашлось'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: visibleDrinks.length,
                    itemBuilder: (context, index) {
                      final drink = visibleDrinks[index];
                      return DrinkCard(
                        drink: drink,
                        isLiked: _likedIds.contains(drink.id),
                        onLikeTap: () => _toggleLike(drink.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}