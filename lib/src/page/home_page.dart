import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/provider/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movies_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculaProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculaProvider.getPupulares();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Peliculas en cines"),
        backgroundColor: Colors.indigo,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: DataSearch(onSearchClick: startMovieDetaill),
                  //query: 'Hola',
                );
              })
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
        future: peliculaProvider.getEnCines(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return CardSwiper(
              peliculas: snapshot.data,
              onCarPressed: startMovieDetaill,
            );
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
//    peliculaProvider.getEnCines();
//    return CardSwiper(peliculas: [1, 2, 3, 4, 5]);
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Populares", style: Theme.of(context).textTheme.subhead),
          StreamBuilder(
              stream: peliculaProvider.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.data != null) {
                  return MovieHorizontal(
                    peliculas: snapshot.data,
                    siguientePagina: peliculaProvider.getPupulares,
                    onCarPressed: startMovieDetaill,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }

  startMovieDetaill(BuildContext context, Pelicula pelicula) {
    Navigator.pushNamed(context, "detalle", arguments: pelicula);
  }
}
