import 'package:flutter/material.dart';
import 'package:autonebriosapp/helpers/db_helper_caixa.dart';
import 'package:autonebriosapp/helpers/db_helper_dieta.dart';
import 'package:autonebriosapp/helpers/db_helper_evento.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DatabaseHelperCaixa db = DatabaseHelperCaixa();
  DatabaseHelperDieta dhd = DatabaseHelperDieta();
  DatabaseHelperEvento dbe = DatabaseHelperEvento();

@override
void initState() {
  super.initState();

  db.rebuildDB();
  dhd.rebuildDB();
  dbe.rebuildDB();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'AutonébriosAPP',
        style: const TextStyle(
            fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
      ),
    ),
    body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("/caixas");
                },
                icon: Image.asset(
                  'assets/images/box.png',
                  height: 50,
                  width: 50,
                ),
                label: Text(
                  'Caixas',
                  style: const TextStyle(
                      fontSize: 36,
                      color: Colors.black54,
                      fontFamily: 'Comfortaa'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("/eventos");
                },
                icon: Image.asset(
                  'assets/images/eventos.png',
                  height: 50,
                  width: 50,
                ),
                label: Text(
                  'Eventos',
                  style: const TextStyle(
                      fontSize: 36,
                      color: Colors.black54,
                      fontFamily: 'Comfortaa'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("/dietas");
                },
                icon: Image.asset(
                  'assets/images/dietas.png',
                  height: 50,
                  width: 50,
                ),
                label: Text(
                  'Dietas',
                  style: const TextStyle(
                      fontSize: 36,
                      color: Colors.black54,
                      fontFamily: 'Comfortaa'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("/inst");
                },
                icon: Image.asset(
                  'assets/images/infos.png',
                  height: 50,
                  width: 50,
                ),
                label: Text(
                  'Instruções',
                  style: const TextStyle(
                      fontSize: 36,
                      color: Colors.black54,
                      fontFamily: 'Comfortaa'),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}}
