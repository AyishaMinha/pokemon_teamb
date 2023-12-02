import 'package:app/shared/models/pokemon_summary.dart';
import 'package:app/shared/repositories/auth_interceptor.dart';
import 'package:app/shared/repositories/favourites_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class FavouritesProvider extends ChangeNotifier {
  late bool _isFav = false;
  late List<PokemonSummary> _favourites = [];

  FavouritesService favService = FavouritesService();

  void checkIfCurrentIsFavourite(BuildContext context, PokemonSummary currentPokemon) async {
    final favouritesList = await fetchFavourites(context);
    if (favouritesList.contains(currentPokemon)) {
      _isFav = true;
      notifyListeners();
    } else {
      _isFav = false;
      notifyListeners();
    }
  }

  Future<bool> addFavourite(
    BuildContext context,
    String favourite,
  ) async {
    final Dio dio = favService.getDioInstance();
    dio.interceptors.add(AuthInterceptor(dio: dio, context: context));
    final bool result = await favService.addFavourite(favourite);
    _isFav = result;
    notifyListeners();
    dio.interceptors.clear();
    return result;
  }

  Future<bool> removeFavourite(
    BuildContext context,
    String favourite,
  ) async {
    final Dio dio = favService.getDioInstance();
    dio.interceptors.add(AuthInterceptor(dio: dio, context: context));
    final bool result = await favService.removeFavourite(favourite);
    _isFav = !result;
    _favourites.removeWhere((element) => element.number == favourite);
    notifyListeners();
    dio.interceptors.clear();
    return result;
  }

  Future<List<PokemonSummary>> fetchFavourites(BuildContext context) async {
    final Dio dio = favService.getDioInstance();
    dio.interceptors.add(AuthInterceptor(dio: dio, context: context));
    final List<PokemonSummary> result = await favService.getFavourites();
    _favourites = result;
    notifyListeners();
    dio.interceptors.clear();
    return _favourites;
  }

  void clearFavourites() {
    _favourites.clear();
    notifyListeners();
  }

  List<PokemonSummary> get favourites {
    _favourites.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));
    return _favourites;
  }

  bool get isFavourite => _isFav;
}
