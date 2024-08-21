import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/favourite.dart';

class CatchPokemon extends StatefulWidget {
  @override
  _CatchPokemonState createState() => _CatchPokemonState();
}

class _CatchPokemonState extends State<CatchPokemon> {
  late Future<List<String>> _favoritePokemons;
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _favoritePokemons = _getFavoritePokemon();
  }

  Future<List<String>> _getFavoritePokemon() async {
    return _favoritesManager.getFavoritePokemonIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          'Your Pokémons',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(197, 232, 223, 235),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 85, 77, 77),
      ),
     
      body: FutureBuilder<List<String>>(
        future: _favoritePokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite Pokémon found.'));
          } else {
            var favoritePokemonIds = snapshot.data!;
            return ListView.builder(
              itemCount: favoritePokemonIds.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Pokémon ID: ${favoritePokemonIds[index]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
