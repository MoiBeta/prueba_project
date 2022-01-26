import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba_project/screens/registro_screen.dart';

import 'datos_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late UserCredential userCredential;

  void loginFirebase() async {
    if(emailController.text.isEmpty || passwordController.text.isEmpty){
      Fluttertoast.showToast(
          msg: 'Por favor llena todos los campos',
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          timeInSecForIosWeb: 2
      );
      return;
    }
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'Usuario no encontrado',
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            timeInSecForIosWeb: 2
        );
        return;
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Contraseña incorrecta',
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
    Fluttertoast.showToast(
        msg: 'Success',
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        timeInSecForIosWeb: 2
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DatosScreen(userCredential.user?.uid)));
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
          constraints: BoxConstraints(
              maxHeight: size.height,
            maxWidth: size.width
          ),
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
                          'Iniciar Sesión',
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
                        style: const TextStyle(
                          color: Colors.white70,
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
                        obscureText: true,
                        style: const TextStyle(
                          color: Colors.white70,
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
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: loginFirebase,
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
                          'Iniciar',
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RegistroScreen()));
                        },
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
