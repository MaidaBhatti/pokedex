import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/pokemonattributecard.dart';

class PokemonDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? pokemon;

  const PokemonDetailsScreen({Key? key, required this.pokemon}) : super(key: key);

  Color _getTypeColor(String type) {
    switch (type) {
      case 'grass':
        return Colors.green;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      default:
        return Colors.grey; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    String capitalize(String? s) => s![0].toUpperCase() + s.substring(1);
    List<Color> typeColors = pokemon?['types']?.map<Color>((type) => _getTypeColor(type)).toList() ?? [];

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
     
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: typeColors.isNotEmpty ? [typeColors[0], Colors.white] : [Colors.white, Colors.white],
            stops: [0.25, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.grey[300],
                ),
                child: SizedBox(
                  height: 200,
                  
                  width: 200,
                  child: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon?['id']}.png',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                ),
              ),
        
              SizedBox(height: 16),
              Text(
                capitalize(pokemon?['name']),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'CP ${pokemon?['id']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
                SizedBox(height: 16),
         /*     Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                width: MediaQuery.of(context).size.width * 0.6, // Adjusted width
                child: Text(
                  'Description',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
*/              SizedBox(height: 10),
          Container(
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Text(
      pokemon?['description'] ?? '',
      style: TextStyle(
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
      // maxLines: 1,
      // overflow: TextOverflow.visible,
      // softWrap: false,
    ),
  ),
),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PokemonAttributeCard(
                    title: 'Weight',
                    value: '${(pokemon?['weight'] ?? 0) / 10} kg',
                  ),
                  PokemonAttributeCard(
                    title: 'Height',
                    value: '${(pokemon?['height'] ?? 0) / 10} m',
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Moves',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: pokemon?['moves']?.map<Widget>((move) {
                    return ListTile(
                      title: Text(
                        capitalize(move['name']),
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      trailing: Text(
                        'Power: ${move['power']}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    );
                  }).toList() ?? [],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
