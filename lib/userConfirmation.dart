import 'package:flutter/material.dart';
import 'loginPage.dart';

void main() {
  runApp(const userConfirmation());
}

class userConfirmation extends StatelessWidget {
  const userConfirmation({Key? key}) : super(key: key);

  void _continuarButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => loginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: FractionalOffset(0.5, 0.2),
              colors: [
                Colors.deepPurple,
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 190),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140.0,
                      height: 140.0,
                      child: Transform.translate(
                        offset: Offset(10.0, 0.0),
                        child: Image.asset('assets/photos/verified_logo.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Registro Exitoso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50),
                  child: Text(
                    'Hemos guardado tus credenciales de forma exitosa. Presiona continuar para seguir adelante',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          return ElevatedButton(
                            onPressed: () {
                              _continuarButtonPressed(context);
                            },
                            child: Text(
                              'Continuar',
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
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
