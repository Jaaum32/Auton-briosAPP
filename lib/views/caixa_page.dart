import 'package:autonebriosapp/models/caixa.dart';
import 'package:autonebriosapp/qr/criacao_qr_code.dart';
import 'package:flutter/material.dart';

class CaixaPage extends StatefulWidget {
  final Caixa caixa;

  const CaixaPage({Key? key, required this.caixa}) : super(key: key);

  @override
  _CaixaPageState createState() => _CaixaPageState();
}

class _CaixaPageState extends State<CaixaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Caixa ' + widget.caixa.id.toString(),
            style: const TextStyle(
                fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
          ),
          bottom: const TabBar(
            tabs: <Widget>[
              Text('Dados'),
              Text('Gráficos'),
              Text('QRCode'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _pageDados(context),
            Center(
              child: Text("Nada por aqui ainda :)"),
            ),
            QrCodeGenerator(idCaixa: widget.caixa.id),
          ],
        ),
      ),
    );
  }

  _pageDados(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text("ID: " + widget.caixa.id.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),),
          Text("Início da criação: " + widget.caixa.inicioCriacao,
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),),
          Text("Final da criação: " + widget.caixa.finalCriacao,
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),),
          Text("Temperatura: ?",
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),), //+ widget.caixa.temperatura.toString()),
          Text("Umidade: ?",
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),), //+ widget.caixa.umidade.toString()),
          Text("Dieta: Dieta " + widget.caixa.dieta.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),),
          Text("Função: " + widget.caixa.funcao.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
                fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),),
        ],
      ),
    );
  }
}
