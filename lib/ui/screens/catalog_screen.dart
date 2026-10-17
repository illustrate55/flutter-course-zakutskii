import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/drink.dart';
import '../widgets/drink_card.dart';

const baseUrl = 'https://6ad23b8166cd28aed82dd021.mockapi.io';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _titleController = TextEditingController();
  final Set<String> _likedIds = {};

  List<Drink> _drinks = [];
  bool _isLoading = true;
  String? _error;
  bool _isSending = false;
  bool _onlyLiked = false;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _loadDrinks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // ---------- GET ----------
  Future<void> _loadDrinks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(Uri.parse('$baseUrl/drinks'));
      if (response.statusCode != 200) {
        throw Exception('Статус ${response.statusCode}');
      }
      // utf8.decode(bodyBytes), чтобы русский текст не превратился в кракозябры
      final list = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final drinks = list
          .map((e) => Drink.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() {
        _drinks = drinks;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // ---------- POST ----------
  Future<void> _addDrink() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _showMessage('Введите название');
      return;
    }

    setState(() => _isSending = true);
    try {
      // Поля, которые пользователь не вводит, берём по умолчанию
      final draft = Drink(
        id: '',
        title: title,
        subtitle: 'Добавлено вручную',
        category: DrinkCategory.coffee,
        description: '',
        image: '',
        color: const Color(0xFF8D6E63),
      );

      final response = await http.post(
        Uri.parse('$baseUrl/drinks'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(draft.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Статус ${response.statusCode}');
      }
      final created = Drink.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
      );

      if (!mounted) return;
      setState(() {
        _drinks.insert(0, created); // новый элемент в начало списка
        _titleController.clear();
        _isSending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      _showMessage('Не удалось отправить: $e');
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  // ---------- Лайки и фильтр (локально) ----------
  void _toggleLike(String id) {
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

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кофе и чай'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Text(
            'В избранном: ${_likedIds.length}',
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Не удалось загрузить каталог:\n$_error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadDrinks,
                child: const Text('Обновить'),
              ),
            ],
          ),
        ),
      );
    }

    // Отфильтрованный список считаем здесь, отдельно не храним
    final visibleDrinks = _onlyLiked
        ? _drinks.where((drink) => _likedIds.contains(drink.id)).toList()
        : _drinks;

    return Column(
      children: [
        if (_showForm) _buildForm(),
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
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: _isSending ? null : _addDrink,
            child: _isSending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Отправить'),
          ),
        ],
      ),
    );
  }
}