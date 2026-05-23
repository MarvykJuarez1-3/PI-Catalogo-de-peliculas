import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  final tituloController = TextEditingController();
  final anioController = TextEditingController();
  final directorController = TextEditingController();
  final generoController = TextEditingController();
  final sinopsisController = TextEditingController();
  final imagenController = TextEditingController();

  Future<void> agregarPelicula() async {

    await FirebaseFirestore.instance.collection('peliculas').add({
      'titulo': tituloController.text,
      'anio': anioController.text,
      'director': directorController.text,
      'genero': generoController.text,
      'sinopsis': sinopsisController.text,
      'imagen': imagenController.text,
    });

    tituloController.clear();
    anioController.clear();
    directorController.clear();
    generoController.clear();
    sinopsisController.clear();
    imagenController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Película agregada'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: const Text('Administración'),
        backgroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            children: [

              TextField(
                controller: tituloController,
                decoration: const InputDecoration(
                  hintText: "Título",
                ),
              ),

              TextField(
                controller: anioController,
                decoration: const InputDecoration(
                  hintText: "Año",
                ),
              ),

              TextField(
                controller: directorController,
                decoration: const InputDecoration(
                  hintText: "Director",
                ),
              ),

              TextField(
                controller: generoController,
                decoration: const InputDecoration(
                  hintText: "Género",
                ),
              ),

              TextField(
                controller: sinopsisController,
                decoration: const InputDecoration(
                  hintText: "Sinopsis",
                ),
              ),

              TextField(
                controller: imagenController,
                decoration: const InputDecoration(
                  hintText: "URL Imagen",
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: agregarPelicula,
                child: const Text("Agregar película"),
              ),

              const Divider(color: Colors.white),

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('peliculas')
                    .snapshots(),

                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final peliculas = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: peliculas.length,

                    itemBuilder: (context, index) {

                      final pelicula = peliculas[index];

                      return ListTile(

                        title: Text(
                          pelicula['titulo'],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),

                        subtitle: Text(
                          pelicula['director'],
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),

                          onPressed: () async {

                            await FirebaseFirestore.instance
                                .collection('peliculas')
                                .doc(pelicula.id)
                                .delete();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}