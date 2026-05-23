import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'detalle_pelicula_screen.dart';
import 'favoritos_screen.dart';
import 'admin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {

  String busqueda = '';

  final List<Movie> favoritos = [];

  final List<Movie> peliculas = [

    Movie(
      titulo: 'La La Land',
      imagen:
          'https://upload.wikimedia.org/wikipedia/en/a/ab/La_La_Land_%28film%29.png',
      anio: '2016',
      director: 'Damien Chazelle',
      genero: 'Romance / Musical',
      sinopsis: 'Una actriz y un músico luchan por sus sueños.',
    ),

    Movie(
      titulo: 'Coraline',
      imagen:
          'https://upload.wikimedia.org/wikipedia/en/3/36/Coraline_poster.jpg',
      anio: '2009',
      director: 'Henry Selick',
      genero: 'Animación',
      sinopsis: 'Una niña descubre un mundo alternativo peligroso.',
    ),
        Movie(
      titulo: 'Little Women',
      imagen:
          'https://pics.filmaffinity.com/little_women-778503384-large.jpg',
      anio: '2019',
      director: 'Greta Gerwig',
      genero: 'Drama',
      sinopsis:
          'Cuatro hermanas enfrentan el amor, la pérdida y el crecimiento personal.',
    ),

    Movie(
      titulo: 'Taxi Driver',
      imagen:
          'https://pics.filmaffinity.com/taxi_driver-173769074-large.jpg',
      anio: '1976',
      director: 'Martin Scorsese',
      genero: 'Drama / Crimen',
      sinopsis:
          'Un conductor nocturno de Nueva York cae en la obsesión y la violencia.',
    ),
  ];

  void toggleFavorito(Movie pelicula) {

    setState(() {

      if (favoritos.contains(pelicula)) {
        favoritos.remove(pelicula);
      } else {
        favoritos.add(pelicula);
      }
    });
  }

  void agregarPelicula(Movie pelicula) {

    setState(() {
      peliculas.add(pelicula);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: Colors.black,

        title: TextField(
          onChanged: (value) {
            setState(() => busqueda = value);
          },

          style: const TextStyle(
            color: Colors.white,
          ),

          decoration: const InputDecoration(
            hintText: 'Buscar...',
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
            border: InputBorder.none,
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),

            onPressed: () async {

              final nuevaPelicula =
                  await Navigator.push<Movie>(

                context,

                MaterialPageRoute(
                  builder: (_) => const AdminScreen(),
                ),
              );

              if (nuevaPelicula != null) {
                agregarPelicula(nuevaPelicula);
              }
            },
          ),

          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => FavoritosScreen(
                    favoritos: favoritos,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection('peliculas')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          final peliculasFirebase = docs.map((p) {

            return Movie(
              titulo: p['titulo'],
              imagen: p['imagen'],
              anio: p['anio'],
              director: p['director'],
              genero: p['genero'],
              sinopsis: p['sinopsis'],
            );

          }).toList();

          final todasLasPeliculas = [
            ...peliculas,
            ...peliculasFirebase,
          ];

          final filtradas =
              todasLasPeliculas.where((p) {

            return p.titulo
                .toLowerCase()
                .contains(
                  busqueda.toLowerCase(),
                );

          }).toList();

          return GridView.builder(

            padding: const EdgeInsets.all(12),

            itemCount: filtradas.length,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),

            itemBuilder: (context, index) {

              final pelicula = filtradas[index];

              return GestureDetector(

                onTap: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          DetallePeliculaScreen(
                        pelicula: pelicula,
                      ),
                    ),
                  );
                },

                child: Container(

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius:
                        BorderRadius.circular(18),
                  ),

                  child: Column(
                    children: [

                      Expanded(

                        child: ClipRRect(

                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),

                          child: Image.network(

                            pelicula.imagen,

                            width: double.infinity,

                            fit: BoxFit.cover,

                            alignment:
                                Alignment.topCenter,
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.all(8),

                        child: Text(

                          pelicula.titulo,

                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}