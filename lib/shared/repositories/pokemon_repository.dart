import 'dart:convert';
import 'package:app/shared/utils/api_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app/shared/models/pokemon.dart';
import 'package:app/shared/models/pokemon_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonRepository {
  Future<List<PokemonSummary>> fetchPokemonsSummary() async {
    try {
      final response = await http.get(
        Uri.parse(
          // ApiConstants.pokedexSummaryData,
          '${ApiConstants.baseURL}/pokemon',
        ),
        headers: {
          'api-key': dotenv.env['API_KEY'].toString(),
        },
      );

      // return List<PokemonSummary>.from(
      //   json.decode(const Utf8Decoder().convert(response.body.codeUnits)).map(
      //         (model) => PokemonSummary.fromJson(model),
      //       ),
      // );
      return pokemonSummaryListFromJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> fetchFavoritesPokemonsSummary() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites-pokemons');
      // final favorites = prefs.getStringList('favorites-pokemons');

      if (favorites == null) {
        return [];
      } else {
        return favorites;
      }
    } catch (e) {
      rethrow;
    }
  }

  void saveFavoritePokemonSummary(List<String> favorites) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      // await prefs.setStringList('favorites-pokemons', favorites);
      await prefs.setStringList('$username-favorites-pokemons', favorites);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pokemon> fetchPokemon(String number) async {
    try {
      final response =
          await http.get(Uri.parse(ApiConstants.pokemonDetails(number)));

      return Pokemon.fromJson(
          jsonDecode(const Utf8Decoder().convert(response.body.codeUnits)));
    } catch (e) {
      rethrow;
    }
  }
}
