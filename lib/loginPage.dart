import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'registerPage.dart';
import 'homePage.dart';
import 'models.dart';
import 'dart:collection';
import 'package:google_sign_in/google_sign_in.dart';
import 'creditHistory.dart';

void main() {
  runApp(const loginPage());
}

void _iniciar(BuildContext context, String? userName, int? usuarioActivo) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) =>
            HomePage(userName: userName, usuarioActivo: usuarioActivo)),
  );
}

class loginPage extends StatelessWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView(
            children: [
              // Column
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'CrediApp',
                      style: TextStyle(
                        fontSize: 50.0,
                        fontFamily: 'Montserrat',
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Inicia sesión o continua, solo te tomará unos minutos',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Login()
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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  late DatabaseHelper dbHelper;

  _LoginState() {
    dbHelper = DatabaseHelper();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email or Usuario',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      hintText: 'user@example.com',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contraseña',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Montserrat',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  PasswordFormField(
                    controller: passwordController,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String email = emailController.text;
                      String password = passwordController.text;

                      List<User?> users = await dbHelper.getUsers();

                      List<User?> authenticatedUsers = users
                          .where((user) =>
                              user?.email == email &&
                              user?.password == password)
                          .toList();

                      if (authenticatedUsers.isNotEmpty) {
                        User? authenticatedUser = authenticatedUsers[0];
                        String? userName = authenticatedUser?.name;
                        int? usuarioActivo = authenticatedUser?.id;
                        _iniciar(context, userName, usuarioActivo);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Inicio de sesión exitoso',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                '¡Bienvenido, ${authenticatedUser?.name}!',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Inicio de sesión fallido',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Credenciales no válidas. Por favor, verifica tu correo electrónico y contraseña.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shadowColor: Colors.transparent,
                    minimumSize: Size(double.infinity, 40.0),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                _rememberMe = value;
                              });
                            }
                          },
                        ),
                        Text(
                          'Recordarme',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Olvidé mi contraseña',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'O',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/photos/google_logo.png',
                            height: 25.0),
                        SizedBox(width: 10),
                        Text('Ingresa con Google'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/photos/apple_logo.png',
                            height: 25.0),
                        SizedBox(width: 10),
                        Text('Ingresa con Apple'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                RichText(
                  text: TextSpan(
                    text: '¿No tienes una cuenta? ',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Regístrate aquí',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => registerPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;

  PasswordFormField({required this.controller});

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14.0,
        color: Colors.grey,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        hintText: 'Ingrese su contraseña',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontFamily: 'Montserrat',
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
