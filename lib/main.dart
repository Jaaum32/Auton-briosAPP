import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'views/dietas_page.dart';
import 'views/eventos_page.dart';
import 'views/inst_page.dart';
import 'views/caixas_page.dart';
import 'views/mainhome_page.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(),
        '/main': (context) => MainPage(),
        '/caixas': (context) => CaixasPage(),
        '/eventos': (context) => EventosPage(),
        '/dietas': (context) => DietasPage(),
        '/inst': (context) => InstPage(),
        //'/qr': (context) => QRTestePage(),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 283,
              width: 284,
            ),
            Text(
              'AutonébriosAPP',
              style: const TextStyle(
                  fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tempoExec();
  }

  Future<void> tempoExec() async {
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (Route<dynamic> route) => false);
    });
  }
}
