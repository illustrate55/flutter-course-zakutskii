import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/catalog_repository.dart';
import '../../domain/entities/drink.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CatalogBloc(this._repository) : super(CatalogLoading()) {
    
    // 1. ЗАГРУЗКА КАТАЛОГА
    on<LoadCatalog>((event, emit) async {
      emit(CatalogLoading());
      final user = _auth.currentUser;
      if (user == null) {
        emit(const CatalogError('Пользователь не авторизован'));
        return;
      }

      try {
        final drinksStream = _repository.getDrinksStream();
        final favoritesStream = _repository.getFavoriteIdsStream(user.uid);

        await emit.forEach(
          Rx.combineLatest2(
            drinksStream,
            favoritesStream,
            (List<Drink> drinks, List<String> favorites) => CatalogLoaded(
              allDrinks: drinks,
              favoriteIds: favorites,
              // Сохраняем текущее состояние фильтра и поиска при обновлении
              showOnlyFavorites: state is CatalogLoaded ? (state as CatalogLoaded).showOnlyFavorites : false,
              searchQuery: state is CatalogLoaded ? (state as CatalogLoaded).searchQuery : '',
            ),
          ),
          onData: (state) => state,
          onError: (error, _) => CatalogError('Ошибка загрузки: $error'),
        );
      } catch (e) {
        emit(CatalogError('Не удалось загрузить данные: $e'));
      }
    });

    // 2. ФИЛЬТР "ТОЛЬКО ИЗБРАННЫЕ"
    on<ToggleFilter>((event, emit) {
      if (state is CatalogLoaded) {
        final currentState = state as CatalogLoaded;
        emit(currentState.copyWith(showOnlyFavorites: !currentState.showOnlyFavorites));
      }
    });

    // 3. ЛАЙКИ
    on<ToggleFavorite>((event, emit) async {
      final user = _auth.currentUser;
      if (user != null && state is CatalogLoaded) {
        final isFavorite = (state as CatalogLoaded).favoriteIds.contains(event.drinkId);
        await _repository.toggleFavorite(user.uid, event.drinkId, isFavorite);
      }
    });

    // 4. ДОБАВЛЕНИЕ
    on<AddNewDrink>((event, emit) async {
      await _repository.addDrink(event.drink);
    });

    // 5. ПОИСК (НОВОЕ)
    on<SearchDrinks>((event, emit) {
      if (state is CatalogLoaded) {
        final currentState = state as CatalogLoaded;
        emit(currentState.copyWith(searchQuery: event.query));
      }
    });
  }
}