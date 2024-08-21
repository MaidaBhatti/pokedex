import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/sideDrawer.dart';
import 'package:flutter_application_1/screens/favourite.dart';
import 'package:flutter_application_1/screens/pokemonDetail.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<dynamic> pokedex = [];
  late List<dynamic> filteredPokedex = [];
  late TextEditingController searchController = TextEditingController();
  late FavoritesManager _favoritesManager;
  late Future<void> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesManager = FavoritesManager();
    _favoritesFuture = fetchPokemonData();
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pokédex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromARGB(197, 232, 223, 235),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 85, 77, 77),
      ),
      drawer: Sidedrawer(),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('home.jpg'), // Add your background image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main Content
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 253, 250, 250),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 146, 5, 5).withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Pokémon',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredPokedex = pokedex.where((pokemon) =>
                          pokemon['name'].toString().toLowerCase().contains(value.toLowerCase())).toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _favoritesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error fetching data'));
                    } else {
                      return ListView.builder(
                        itemCount: filteredPokedex.length,
                        itemBuilder: (context, index) {
                          var pokemon = filteredPokedex[index];
                          var name = capitalize(pokemon['name']);
                          var types = pokemon['types'].join(', ');
                          var color = typeGradients[pokemon['types'][0]] ?? LinearGradient(colors: [Colors.green, Colors.green]);
                          var pokemonIndex = index + 1; // Index starts from 1

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced vertical padding
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonDetailsScreen(pokemon: filteredPokedex[index]),
                                  ),
                                );
                              },
                              child: Container(
                                height: 90, // Reduced height
                                decoration: BoxDecoration(
                                  gradient: color,
                                  borderRadius: BorderRadius.circular(10), // Slightly rounded corners
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 30, top: 5, right: 20,), // Adjusted padding
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '#00$pokemonIndex            $name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize:18,
                                                color: const Color.fromARGB(255, 10, 9, 9),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.2), // Grey outline highlight
                                                borderRadius: BorderRadius.circular(10), // Slightly rounded corners
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center( // Center the text
                                                child: Text(
                                                  types,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                                      fontSize:14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.withOpacity(0.5), // Background grey with opacity
                                            ),
                                          ),
                                          CachedNetworkImage(
                                            imageUrl:
                                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: FutureBuilder<List<String>>(
                                              future: _favoritesManager.getFavoritePokemonIds(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Icon(Icons.error);
                                                } else {
                                                  var favoritePokemonIds = snapshot.data ?? [];
                                                  var isFavorite = favoritePokemonIds.contains(pokemon['id'].toString());
                                                  return IconButton(
                                                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                                                    color: Colors.white,
                                                    onPressed: () async {
                                                      setState(() {
                                                        if (isFavorite) {
                                                          _favoritesManager.removeFromFavorites(pokemon['id'].toString());
                                                        } else {
                                                          _favoritesManager.addToFavorites(pokemon['id'].toString());

                                                      }
                                                      });
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

 Map<String, LinearGradient> typeGradients = {
  'normal': LinearGradient(
    colors: [
      Colors.greenAccent.withOpacity(0.5),
      Colors.greenAccent.withOpacity(1.0),
    ],
  ),
  'fire': LinearGradient(
    colors: [
      Colors.redAccent.withOpacity(0.5),
      Colors.redAccent.withOpacity(1.0),
    ],
  ),
  'water': LinearGradient(
    colors: [
      Colors.blueAccent.withOpacity(0.5),
      Colors.blueAccent.withOpacity(1.0),
    ],
  ),
  'electric': LinearGradient(
    colors: [
      Colors.yellowAccent.withOpacity(0.5),
      Colors.yellowAccent.withOpacity(1.0),
    ],
  ),
};
  Future<void> fetchPokemonData() async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151');
    try {
      var response = await http.get(url);
      var decodedJsonData = jsonDecode(response.body);
      var pokemonList = decodedJsonData['results'] as List<dynamic>;
      for (var pokemon in pokemonList) {
        var pokemonResponse = await http.get(Uri.parse(pokemon['url']));
        var pokemonData = jsonDecode(pokemonResponse.body);
        var pokemonName = pokemonData['name'];
        var pokemonTypes = pokemonData['types'].map((type) => type['type']['name']).toList();
        var pokemonWeight = pokemonData['weight'];
        var pokemonHeight = pokemonData['height'];
        var pokemonMoves = pokemonData['moves'].take(5).map((move) => {
              'name': move['move']['name'],
              'power': move['power'] ?? 'Unknown',

            }).toList();

        var description = '';
        var speciesUrl = pokemonData['species']['url'];
        var speciesResponse = await http.get(Uri.parse(speciesUrl));
        var speciesData = jsonDecode(speciesResponse.body);
        var flavorTextEntries = speciesData['flavor_text_entries'] as List<dynamic>;
        var flavorTextEntry = flavorTextEntries.firstWhere(
            (entry) => entry['language']['name'] == 'en',
            orElse: () => null);
        if (flavorTextEntry != null) {
          description = flavorTextEntry['flavor_text'];
        }

        setState(() {
          pokedex.add({
            'name': pokemonName,
            'types': pokemonTypes,
            'weight': pokemonWeight,
            'height': pokemonHeight,
            'moves': pokemonMoves,
            'description': description,
            'id': pokemonData['id'],
          });
          filteredPokedex = List.from(pokedex);
        });
      }
    } catch (e) {
      print('Error fetching Pokemon data: $e');
    }
  }
}
