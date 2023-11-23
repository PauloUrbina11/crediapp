import 'dart:async';
import 'package:flutter/material.dart';
import 'registerPage.dart';
import 'loginPage.dart';

void main() {
  runApp(const CrediApp());
}

class CrediApp extends StatelessWidget {
  const CrediApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          MyBackgroundPage(),
          MyBackgroundPage2(),
        ],
      ),
    );
  }
}

class MyBackgroundPage extends StatelessWidget {
  const MyBackgroundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/photos/bg1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 150.0,
          left: 35.0,
          right: 105.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Accede a créditos con un solo toque y sin complicaciones.',
                  style: TextStyle(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          left: 50.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButtonsSection(),
          ),
        ),
      ],
    );
  }
}

class MyBackgroundPage2 extends StatelessWidget {
  const MyBackgroundPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/photos/bg2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 150.0,
          left: 35.0,
          right: 105.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Toma el control de tus finanzas con confianza y accede a ellas sin restricciones.',
                  style: TextStyle(
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1.5
                      ..color = Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          left: 50.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButtonsSection(),
          ),
        ),
      ],
    );
  }
}

class ElevatedButtonsSection extends StatelessWidget {
  const ElevatedButtonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => loginPage()),
            );
          },
          child: Text(
            'Ingresar',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shadowColor: Colors.transparent,
            fixedSize: Size(300, 30),
          ),
        ),
        SizedBox(height: 5.0),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => registerPage()),
            );
          },
          child: Text(
            'Registrarse',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shadowColor: Colors.transparent,
            fixedSize: Size(300, 30),
          ),
        ),
      ],
    );
  }
}
