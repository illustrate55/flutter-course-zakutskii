import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../data/catalog_repository.dart';
import '../../domain/entities/drink.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CatalogBloc(this._repository) : super(const CatalogLoading()) {
    // restartable: повторная загрузка («Обновить») отменяет прошлую подписку
    on<LoadCatalog>(_onLoadCatalog, transformer: restartable());
    on<ToggleFilter>(_onToggleFilter);
    on<ToggleFavorite>(_onToggleFavorite);
    on<AddNewDrink>(_onAddNewDrink);
    on<SearchDrinks>(_onSearchDrinks);
  }

  // 1. Загрузка каталога: подписка на snapshots() живёт в Bloc
  Future<void> _onLoadCatalog(
    LoadCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoading());

    final user = _auth.currentUser;
    if (user == null) {
      emit(const CatalogError('Пользователь не авторизован'));
      return;
    }

    try {
      final stream = Rx.combineLatest2<List<Drink>, List<String>,
          (List<Drink>, List<String>)>(
        _repository.getDrinksStream(),
        _repository.getFavoriteIdsStream(user.uid),
        (drinks, favorites) => (drinks, favorites),
      );

      await emit.forEach<(List<Drink>, List<String>)>(
        stream,
        onData: (data) {
          // Сохраняем фильтр и поиск, когда Firestore присылает новые данные
          final current = state;
          return CatalogLoaded(
            allDrinks: data.$1,
            favoriteIds: data.$2,
            showOnlyFavorites:
                current is CatalogLoaded ? current.showOnlyFavorites : false,
            searchQuery: current is CatalogLoaded ? current.searchQuery : '',
          );
        },
        onError: (error, stackTrace) =>
            const CatalogError('Не удалось загрузить каталог'),
      );
    } catch (_) {
      emit(const CatalogError('Не удалось загрузить каталог'));
    }
  }

  // 2. Фильтр «Только избранные»
  void _onToggleFilter(ToggleFilter event, Emitter<CatalogState> emit) {
    final current = state;
    if (current is CatalogLoaded) {
      emit(current.copyWith(showOnlyFavorites: !current.showOnlyFavorites));
    }
  }

  // 3. Лайки
  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<CatalogState> emit,
  ) async {
    final user = _auth.currentUser;
    final current = state;
    if (user != null && current is CatalogLoaded) {
      final isFavorite = current.favoriteIds.contains(event.drinkId);
      await _repository.toggleFavorite(user.uid, event.drinkId, isFavorite);
    }
  }

  // 4. Добавление: список обновится сам через snapshots()
  Future<void> _onAddNewDrink(
    AddNewDrink event,
    Emitter<CatalogState> emit,
  ) async {
    await _repository.addDrink(event.drink);
  }

  // 5. Поиск
  void _onSearchDrinks(SearchDrinks event, Emitter<CatalogState> emit) {
    final current = state;
    if (current is CatalogLoaded) {
      emit(current.copyWith(searchQuery: event.query));
    }
  }
}