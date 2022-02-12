// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:autonebriosapp/helpers/db_helper_caixa.dart';
import 'package:autonebriosapp/helpers/db_helper_dieta.dart';
import 'package:autonebriosapp/helpers/db_helper_evento.dart';
import 'package:autonebriosapp/models/caixa.dart';
import 'package:autonebriosapp/models/dieta.dart';
import 'package:autonebriosapp/models/evento.dart';
import 'package:flutter/material.dart';

//import 'package:untitled/views/crud/caixa_form_add.dart';
//import 'package:untitled/views/crud/caixa_form_edit.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({Key? key}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  DatabaseHelperCaixa dbc = DatabaseHelperCaixa();
  DatabaseHelperDieta dhd = DatabaseHelperDieta();
  DatabaseHelperEvento db = DatabaseHelperEvento();
  List<Evento> evts = <Evento>[];
  List<Dieta> dtsLista = <Dieta>[];
  List<Caixa> cxsLista = <Caixa>[];

  @override
  void initState() {
    super.initState();

    dhd.getDietas().then((lista) {
      setState(() {
        dtsLista = lista;
      });
    });

    dbc.getCaixas().then((lista) {
      setState(() {
        cxsLista = lista;
      });
    });

    _mostrarLista();
  }

  void _mostrarLista() {
    db.getEventos().then((lista) {
      print('Antes de editado $lista');
      setState(() {
        evts = lista;
        evts.sort((a, b) => tempoFaltante(a.data).compareTo(tempoFaltante(b.data)));
        _atualizarEventos(cxsLista, evts);
        print('Depois de editado $evts');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eventos',
          style: const TextStyle(
              fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: evts.length,
          itemBuilder: (context, index) {
            return _listaEventos(context, index);
          },
        ),
      ),
    );
  }

  _listaEventos(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Caixa ' + evts[index].idCaixa.toString(),
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                      fontFamily: 'Comfortaa'),
                ),
                Text(
                  evts[index].data,
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black54,
                      fontFamily: 'Comfortaa'),
                ),
              ],
            ),
            Divider(
              color: Colors.transparent,
            ),
            Text(
              evts[index].descricao,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontSize: 20, color: Colors.black54, fontFamily: 'Comfortaa'),
            ),
            Divider(
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _alternarEstado(context, index),
                IconButton(
                  color: Colors.green,
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Tem certeza disso?'),
                        content: Text(
                            "Só marque como concluída se você realmente tiver feito essa tarefa!"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("SIM"),
                            onPressed: () async {
                              await db.deleteEvento(evts[index].id);
                              _mostrarLista();
                              final sb = SnackBar(
                                  content: Text('Tarefa Concluída'),
                                  duration: Duration(seconds: 1));
                              ScaffoldMessenger.of(context).showSnackBar(sb);
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("CANCELAR"),
                            onPressed: () {
//Put your code here which you want to execute on Cancel button click.
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _alternarEstado(BuildContext context, int index) {
    if (evts[index].urgencia == "Sem pressa") {
      return Text(
        evts[index].urgencia,
        style: const TextStyle(
            fontSize: 22,
            backgroundColor: Colors.green,
            color: Colors.white,
            fontFamily: 'Comfortaa'),
      );
    } else if (evts[index].urgencia == "Falta muito") {
      return Text(
        evts[index].urgencia,
        style: const TextStyle(
            fontSize: 22,
            backgroundColor: Colors.blue,
            color: Colors.white,
            fontFamily: 'Comfortaa'),
      );
    } else if (evts[index].urgencia == "Falta pouco") {
      return Text(
        evts[index].urgencia,
        style: const TextStyle(
            fontSize: 22,
            backgroundColor: Colors.cyan,
            color: Colors.white,
            fontFamily: 'Comfortaa'),
      );
    } else if (evts[index].urgencia == "Atenção") {
      return Text(
        evts[index].urgencia,
        style: const TextStyle(
            fontSize: 22,
            backgroundColor: Colors.yellow,
            color: Colors.white,
            fontFamily: 'Comfortaa'),
      );
    } else if (evts[index].urgencia == "Urgente") {
      return Text(
        evts[index].urgencia,
        style: const TextStyle(
            fontSize: 22,
            backgroundColor: Colors.red,
            color: Colors.white,
            fontFamily: 'Comfortaa'),
      );
    } else {
      return Text(
        evts[index].urgencia,
        style: const TextStyle(
            fontSize: 22,
            backgroundColor: Colors.black,
            color: Colors.white,
            fontFamily: 'Comfortaa'),
      );
    }
  }

  _atualizarEventos(List<Caixa> cx, List<Evento> ev) {
    for (int i = 0; i < ev.length; i++) {
      late Caixa c;

      for (int j = 0; j < cx.length; j++) {
        if (ev[i].idCaixa == cx[j].id) {
          c = cx[j];
        }
      }

      if (ev[i].data == c.finalCriacao) {
        String eUrgencia = '';

        int aux = tempoFaltante(ev[i].data);

        if (aux > 60) {
          eUrgencia = "Sem pressa";
        } else if (aux <= 60 && aux > 30) {
          eUrgencia = "Falta muito";
        } else if (aux <= 30 && aux > 15) {
          eUrgencia = "Falta pouco";
        } else if (aux <= 15 && aux > 5) {
          eUrgencia = "Atenção";
        } else if (aux <= 5 && aux >= 0) {
          eUrgencia = 'Urgente';
        } else {
          eUrgencia = 'Atrasado';
        }

        ev[i].urgencia = eUrgencia;

        if (eUrgencia != 'Atrasado') {
          ev[i].descricao =
              "Você deve coletar sua produção daqui a $aux dias, no dia " +
                  ev[i].data;
        } else {
          ev[i].descricao = "Esta atividade está atrasada!";
        }

        db.updateEvento(ev[i]);
      } else {
        String eUrgencia = '';

        int aux = tempoFaltante(ev[i].data);

        if (aux > 60) {
          eUrgencia = "Sem pressa";
        } else if (aux <= 60 && aux > 30) {
          eUrgencia = "Falta muito";
        } else if (aux <= 30 && aux > 15) {
          eUrgencia = "Falta pouco";
        } else if (aux <= 15 && aux > 5) {
          eUrgencia = "Atenção";
        } else if (aux <= 5 && aux >= 0) {
          eUrgencia = 'Urgente';
        } else {
          eUrgencia = 'Atrasado';
        }

        ev[i].urgencia = eUrgencia;

        if (eUrgencia != 'Atrasado') {
          ev[i].descricao =
              'Você deve trocar o alimento daqui a $aux dias, no dia ' +
                  ev[i].data;
        } else {
          ev[i].descricao = "Esta atividade está atrasada!";
        }

        db.updateEvento(ev[i]);
      }
    }
  }

  int tempoFaltante(String eData) {
    String dia = eData.substring(0, 2);
    String mes = eData.substring(3, 5);
    String ano = eData.substring(6, 10);

    var last = DateTime(int.parse(ano), int.parse(mes), int.parse(dia));

    var now = DateTime.now();

    var diff = last.difference(now).inDays;

    return diff;
  }

  int definirDuracao(List<Dieta> lista, Caixa cx) {
    int d = 0;

    for (int i = 0; i < lista.length; i++) {
      if (lista[i].id == cx.dieta) {
        d = lista[i].tempoTotal;
      }
    }

    return d;
  }

  String calcDataFinal(String dtI, int duracao) {
    String dia = dtI.substring(0, 2);
    String mes = dtI.substring(3, 5);
    String ano = dtI.substring(6, 10);

    final dataI = DateTime(int.parse(ano), int.parse(mes), int.parse(dia));
    String dataF = dataI.add(Duration(days: duracao)).toString();
    dataF = dataCertas(dataF);

    return dataF;
  }

  String dataCertas(String data) {
    String dia = data.substring(8, 10);
    String mes = data.substring(5, 7);
    String ano = data.substring(0, 4);
    data = dia + "/" + mes + "/" + ano;
    return data;
  }
}
