import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/catalog/catalog_bloc.dart';
import '../../bloc/catalog/catalog_event.dart';
import '../../bloc/catalog/catalog_state.dart';
import '../../domain/entities/drink.dart';

class DetailScreen extends StatelessWidget {
  final Drink drink;

  const DetailScreen({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drink.title),
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          bool isFavorite = false;
          if (state is CatalogLoaded) {
            isFavorite = state.favoriteIds.contains(drink.id);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Обложка
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(drink.coverColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      drink.title.isNotEmpty ? drink.title[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Заголовок и лайк
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        drink.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      iconSize: 32,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        // Отправляем событие лайка в общий Bloc, чтобы он обновился везде
                        context.read<CatalogBloc>().add(ToggleFavorite(drink.id));
                      },
                    ),
                  ],
                ),
                Text(
                  drink.subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                // Категория
                Chip(
                  label: Text(drink.category),
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 16),
                // Описание
                const Text(
                  'Описание',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(drink.description, style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}