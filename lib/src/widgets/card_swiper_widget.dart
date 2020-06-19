import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function(BuildContext, Pelicula) onCarPressed;

  CardSwiper({@required this.peliculas, @required this.onCarPressed});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        onTap: (i) {
          onCarPressed(context, peliculas[i]);
        },
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-swiper';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.cover,
                  image: NetworkImage(peliculas[index].getPosterImg())),
            ),
          );
        },
        itemCount: peliculas.length,
//        pagination: new SwiperPagination(),
//        control: new SwiperControl(),
      ),
    );
  }
}
