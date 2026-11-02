import 'package:equatable/equatable.dart';
import '../../domain/entities/drink.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

/// Запрос загрузки каталога (первая загрузка и кнопка «Обновить»)
class LoadCatalog extends CatalogEvent {
  const LoadCatalog();
}

class ToggleFilter extends CatalogEvent {
  const ToggleFilter();
}

class ToggleFavorite extends CatalogEvent {
  final String drinkId;

  const ToggleFavorite(this.drinkId);

  @override
  List<Object?> get props => [drinkId];
}

class AddNewDrink extends CatalogEvent {
  final Drink drink;

  const AddNewDrink(this.drink);

  @override
  List<Object?> get props => [drink];
}

class SearchDrinks extends CatalogEvent {
  final String query;

  const SearchDrinks(this.query);

  @override
  List<Object?> get props => [query];
}