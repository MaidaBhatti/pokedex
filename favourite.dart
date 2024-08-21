import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String favoritesKey = 'favoritePokemonIds';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<String>> getFavoritePokemonIds() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(favoritesKey) ?? [];
  }

  Future<void> addToFavorites(String pokemonId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoritePokemonIds = prefs.getStringList(favoritesKey) ?? [];
    if (!favoritePokemonIds.contains(pokemonId)) {
      favoritePokemonIds.add(pokemonId);
      await prefs.setStringList(favoritesKey, favoritePokemonIds);
    }
  }

  Future<void> removeFromFavorites(String pokemonId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoritePokemonIds = prefs.getStringList(favoritesKey) ?? [];
    if (favoritePokemonIds.contains(pokemonId)) {
      favoritePokemonIds.remove(pokemonId);
      await prefs.setStringList(favoritesKey, favoritePokemonIds);
    }
  }
}