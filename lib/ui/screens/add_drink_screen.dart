import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/catalog/catalog_bloc.dart';
import '../../bloc/catalog/catalog_event.dart';
import '../../domain/entities/drink.dart';

class AddDrinkScreen extends StatefulWidget {
  const AddDrinkScreen({super.key});

  @override
  State<AddDrinkScreen> createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends State<AddDrinkScreen> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveDrink() {
    // Обязательное поле "Название" (Часть 3.3 задания)
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Название не может быть пустым!'), backgroundColor: Colors.red),
      );
      return;
    }

    // Генерируем случайный цвет для обложки, чтобы карточка не была черной
    final randomColor = 0xFF000000 | (DateTime.now().millisecondsSinceEpoch % 0xFFFFFF);

    final newDrink = Drink(
      id: '', // Firestore сам сгенерирует ID, нам он тут не нужен
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim().isEmpty ? 'Разное' : _categoryController.text.trim(),
      coverColor: randomColor,
    );

    context.read<CatalogBloc>().add(AddNewDrink(newDrink));
    Navigator.pop(context); // Закрываем экран после добавления
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить элемент')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название (обязательно)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Подпись (короткое описание)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Категория (например: Кофе, Чай)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Полное описание'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveDrink,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Сохранить', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}