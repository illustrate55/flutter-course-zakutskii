import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/catalog/catalog_bloc.dart';
import '../../bloc/catalog/catalog_event.dart';
import '../../bloc/catalog/catalog_state.dart';
import '../widgets/drink_card.dart';
import 'detail_screen.dart';
import 'add_drink_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(SignOutRequested()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDrinkScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CatalogError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<CatalogBloc>().add(LoadCatalog()),
                    child: const Text('Обновить'),
                  ),
                ],
              ),
            );
          }

          if (state is CatalogLoaded) {
            final drinks = state.displayedDrinks;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Поиск по названию',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<CatalogBloc>().add(const SearchDrinks(''));
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      context.read<CatalogBloc>().add(SearchDrinks(value));
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text('Только избранные'),
                  value: state.showOnlyFavorites,
                  onChanged: (_) => context.read<CatalogBloc>().add(ToggleFilter()),
                ),
                Expanded(
                  child: drinks.isEmpty
                      ? const Center(child: Text('Ничего не найдено или здесь пока пусто...'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: drinks.length,
                          itemBuilder: (context, index) {
                            final drink = drinks[index];
                            final isFavorite = state.favoriteIds.contains(drink.id);

                            return DrinkCard(
                              drink: drink,
                              isLiked: isFavorite,
                              onLikeTap: () {
                                context.read<CatalogBloc>().add(ToggleFavorite(drink.id));
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(drink: drink),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text('Нажмите обновить'));
        },
      ),
    );
  }
}