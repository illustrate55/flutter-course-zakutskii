import 'package:equatable/equatable.dart';
import '../../domain/entities/drink.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();
  @override
  List<Object?> get props => [];
}

class CatalogLoading extends CatalogState {}

class CatalogError extends CatalogState {
  final String message;
  const CatalogError(this.message);
  @override
  List<Object?> get props => [message];
}

class CatalogLoaded extends CatalogState {
  final List<Drink> allDrinks;
  final List<String> favoriteIds;
  final bool showOnlyFavorites;
  final String searchQuery; // <-- ДОБАВИЛИ ПОЛЕ ДЛЯ ПОИСКА

  const CatalogLoaded({
    required this.allDrinks,
    required this.favoriteIds,
    this.showOnlyFavorites = false,
    this.searchQuery = '', // <-- По умолчанию пустая строка
  });

  // Логика фильтрации: сначала по избранному, потом по поиску
  List<Drink> get displayedDrinks {
    var filtered = allDrinks;

    if (showOnlyFavorites) {
      filtered = filtered.where((drink) => favoriteIds.contains(drink.id)).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((drink) => 
        drink.title.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  // Обновили copyWith, чтобы можно было менять searchQuery
  CatalogLoaded copyWith({
    bool? showOnlyFavorites,
    String? searchQuery,
  }) {
    return CatalogLoaded(
      allDrinks: allDrinks,
      favoriteIds: favoriteIds,
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allDrinks, favoriteIds, showOnlyFavorites, searchQuery];
}