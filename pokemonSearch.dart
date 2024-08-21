import 'package:flutter/material.dart';

class PokemonSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> pokemonList;

  PokemonSearchDelegate(this.pokemonList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
        
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = pokemonList.where((pokemon) => pokemon['name'].toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        var pokemon = suggestions[index];
        var name = pokemon['name'];
        return ListTile(
          title: Text(name),
          onTap: () {
            close(context, name);
          },
        );
      },
    );
  }
}
