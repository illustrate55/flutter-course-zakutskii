import 'package:equatable/equatable.dart';
import '../../domain/entities/drink.dart';

sealed class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

/// Состояние 1: загрузка
class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

/// Состояние 2: данные
class CatalogLoaded extends CatalogState {
  final List<Drink> allDrinks;
  final List<String> favoriteIds;
  final bool showOnlyFavorites;
  final String searchQuery;

  const CatalogLoaded({
    required this.allDrinks,
    required this.favoriteIds,
    this.showOnlyFavorites = false,
    this.searchQuery = '',
  });

  /// Сначала фильтр по избранному, потом поиск по названию
  List<Drink> get displayedDrinks {
    var filtered = allDrinks;

    if (showOnlyFavorites) {
      filtered =
          filtered.where((drink) => favoriteIds.contains(drink.id)).toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where((drink) => drink.title.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

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
  List<Object?> get props =>
      [allDrinks, favoriteIds, showOnlyFavorites, searchQuery];
}

/// Состояние 3: ошибка
class CatalogError extends CatalogState {
  final String message;

  const CatalogError(this.message);

  @override
  List<Object?> get props => [message];
}