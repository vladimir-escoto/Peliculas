import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final Function(BuildContext, Pelicula) onSearchClick;

  DataSearch({@required this.onSearchClick});

  final peliculasProvider = new PeliculasProvider();
  final peliculas = [
    'SpiderMan',
    'Aquaman',
    'Batman',
    'Shazam',
    'IronMan',
    'Capitan America',
  ];
  final peliculasRecientes = [
    'SpiderMan',
    'Capitan America',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    //acciones del AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la Izquierda del appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultadoa a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias  que aparecen cuando las personas escriben
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: peliculasProvider.buscarPelicula(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          final peliculas = snapshot.data;
          if (snapshot.hasData) {
            return ListView(
              children: peliculas.map((pelicula) {
                pelicula.uniqueId = '${pelicula.id}-swiper';

                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/imag/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: () {
                    close(context, null);
                    onSearchClick(context, pelicula);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

//  @override
//  Widget buildSuggestions(BuildContext context) {
//    // Sugerencias  que aparecen cuando las personas escriben
//
//    final listaSugerida = (query.isEmpty)
//        ? peliculasRecientes
//        : peliculas
//            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
//            .toList();
//
//    return ListView.builder(
//      itemBuilder: (context, i) {
//        return ListTile(
//          leading: Icon(Icons.movie),
//          title: Text(listaSugerida[i]),
//          onTap: () {
//            //showResults(context);
//          },
//        );
//      },
//      itemCount: listaSugerida.length,
//    );
//  }
}
