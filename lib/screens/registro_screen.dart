import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'datos_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  late UserCredential userCredential;

  void registroFirebase() async {
    if(emailController.text.isEmpty || nombreController.text.isEmpty || apellidoController.text.isEmpty || passwordController.text.isEmpty){
      Fluttertoast.showToast(
          msg: 'Por favor llena todos los campos',
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          timeInSecForIosWeb: 2
      );
      return;
    }
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: 'Contraseña demasiado débil',
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            timeInSecForIosWeb: 2
        );
        return;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(
          msg: 'La cuenta ya existe',
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            timeInSecForIosWeb: 2
        );
        return;
      } else{
        Fluttertoast.showToast(
          msg: e.message.toString(),
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            timeInSecForIosWeb: 2
        );
        return;
      }
    }

    CollectionReference users = FirebaseFirestore.instance.collection('usuarios');
    users.doc(userCredential.user?.uid).set({
      'nombres':nombreController.text,
      'apellidos':apellidoController.text,
      'correo':emailController.text,
      'contrasena':passwordController.text
    }).then((value) {
        Fluttertoast.showToast(
          msg: 'Usuario registrado!',
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            timeInSecForIosWeb: 2
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DatosScreen(userCredential.user?.uid)));
  }
    );

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Prueba"),
        backgroundColor: Colors.black.withOpacity(0.7),
      ),
      body: SingleChildScrollView(
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
                      child: const Text(
                        'Registro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                      width: size.width / 1.25,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white70.withOpacity(.7),
                          fontSize: 20,
                        ),
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          hintText: 'Ingresa tu correo',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.withOpacity(.7),
                          ),
                          prefixIcon: const Icon(Icons.mail),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      height: size.height / 10,
                      width: size.width / 1.25,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white70.withOpacity(.7),
                          fontSize: 20,
                        ),
                        controller: passwordController,
                        decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(.2),
                          filled: true,
                          hintText: 'Ingresa tu contraseña',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.withOpacity(.7),
                          ),
                          prefixIcon: const Icon(Icons.mail),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),SizedBox(
                      height: size.height / 10,
                      width: size.width / 1.25,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white70.withOpacity(.7),
                          fontSize: 20,
                        ),
                        controller: nombreController,
                        decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(.2),
                          filled: true,
                          hintText: 'Ingresa tu nombre',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.withOpacity(.7),
                          ),
                          prefixIcon: const Icon(Icons.mail),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),SizedBox(
                      height: size.height / 10,
                      width: size.width / 1.25,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white70.withOpacity(.7),
                          fontSize: 20,
                        ),
                        controller: apellidoController,
                        decoration: InputDecoration(
                          fillColor: Colors.black.withOpacity(.2),
                          filled: true,
                          hintText: 'Ingresa tu apellido',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.withOpacity(.7),
                          ),
                          prefixIcon: const Icon(Icons.mail),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: registroFirebase,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: size.width * .05,
                        ),
                        height: size.height / 10,
                        width: size.width / 1.25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Tengo una cuenta!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
  }
}
