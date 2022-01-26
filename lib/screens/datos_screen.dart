import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatosScreen extends StatelessWidget {
  final String? docId;
  DatosScreen(this.docId,{Key? key}):super(key: key);
  Future<Usuario> getData() async{
    Usuario currentUser = await FirebaseFirestore.instance.collection('usuarios').doc(docId).get()
        .then((value){
          print(value.data()!);
          print(value.data()!["nombres"]);
          Usuario currentUser = Usuario(
              nombre: value.data()!["nombres"],
              apellido: value.data()!["apellidos"],
              correo: value.data()!["correo"],
              contrasena: value.data()!["contrasena"]
          );
          print(currentUser.correo);
          return currentUser;
    });
    return currentUser;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<Usuario> snapshot) {
          if(snapshot.hasError) {
            return Center(
                child: Text(snapshot.error.toString())
            );
          } else if(snapshot.hasData){
            return SingleChildScrollView(
              reverse: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height),
                child: Stack(
                  children: [
                    SizedBox(
                      height: size.height,
                      width: size.width,
                      child: Image.asset(
                        'assets/images/bg.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height / 10,
                            width: size.width / 1.25,
                            child: Text(
                              "Nombre: " + snapshot.data!.nombre,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 10,
                            width: size.width / 1.25,
                            child: Text(
                              "Apellido: " +  snapshot.data!.apellido,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          SizedBox(
                            height: size.height / 10,
                            width: size.width / 1.25,
                            child: Text(
                              "Correo: " + snapshot.data!.correo,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),

                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ), SizedBox(
                            height: size.height / 10,
                            width: size.width / 1.25,
                            child: Text(
                              "Contraseña: " + snapshot.data!.contrasena,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Usuario {
  final String nombre;
  final String apellido;
  final String correo;
  final String contrasena;
  Usuario({required this.nombre, required this.apellido, required this.correo, required this.contrasena});
}
