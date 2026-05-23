import 'package:flutter/material.dart';
import '../models/movie.dart';

class FavoritosScreen extends StatelessWidget {
  final List<Movie> favoritos;

  const FavoritosScreen({
    super.key,
    required this.favoritos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Mis Favoritos ❤️',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: favoritos.isEmpty
          ? const Center(
              child: Text(
                'No tienes favoritos aún 😭',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favoritos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final pelicula = favoritos[index];

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: Image.network(
                            pelicula.imagen,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          pelicula.titulo,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}