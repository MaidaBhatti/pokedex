
import 'package:flutter/material.dart';

class PokemonAttributeCard extends StatelessWidget {
  final String title;
  final String value;

  const PokemonAttributeCard({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    
      child: Column(
        children: [
          SizedBox(height:10),
          Text(
            '  $title: $value',
            style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 5, 3, 3)),
          ),
        ],
      ),
    );
  }
}
