import 'package:equatable/equatable.dart';
import '../../domain/entities/drink.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();
  @override
  List<Object?> get props => [];
}

class LoadCatalog extends CatalogEvent {}

class ToggleFilter extends CatalogEvent {}

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

// НОВОЕ СОБЫТИЕ ДЛЯ ПОИСКА
class SearchDrinks extends CatalogEvent {
  final String query;
  const SearchDrinks(this.query);
  @override
  List<Object?> get props => [query];
}