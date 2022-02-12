// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:autonebriosapp/helpers/db_helper_caixa.dart';
import 'package:autonebriosapp/helpers/db_helper_dieta.dart';
import 'package:autonebriosapp/helpers/db_helper_evento.dart';
import 'package:autonebriosapp/models/caixa.dart';
import 'package:autonebriosapp/models/dieta.dart';
import 'package:autonebriosapp/models/evento.dart';
import 'package:autonebriosapp/views/crud/dieta_form_edit.dart';
import 'package:flutter/material.dart';

import 'crud/dieta_form_add.dart';

class DietasPage extends StatefulWidget {
  const DietasPage({Key? key}) : super(key: key);

  @override
  _DietasPageState createState() => _DietasPageState();
}

class _DietasPageState extends State<DietasPage> {
  DatabaseHelperCaixa cdb = DatabaseHelperCaixa();
  DatabaseHelperDieta db = DatabaseHelperDieta();
  DatabaseHelperEvento dbe = DatabaseHelperEvento();
  List<Dieta> dts = <Dieta>[];
  Dieta d = Dieta(0, '', 0.0, '', 0.0, '', 0.0, 0, 0, '');

  List<Caixa> cxs = <Caixa>[];
  List<Evento> evtsLista = <Evento>[];

  @override
  void initState() {
    super.initState();

    cdb.getCaixas().then((lista) {
      setState(() {
        cxs = lista;
      });
    });

    dbe.getEventos().then((lista) {
      setState(() {
        evtsLista = lista;
      });
    });

    _mostrarLista();
  }

  void _mostrarLista() {
    db.getDietas().then((lista) {
      print(lista);
      setState(() {
        dts = lista;
      });
    });
  }

  String _alimentos(Dieta d) {
    String s =
        'Alimentos: \n' + d.alimento1 + ': ' + d.quantidade1.toString() + ' g';

    if (d.alimento2 != '') {
      s += 'g \n' + d.alimento2 + ': ' + d.quantidade2.toString() + ' g';
    }
    ;
    if (d.alimento3 != '') {
      s += '\n' + d.alimento3 + ': ' + d.quantidade3.toString() + ' g';
    }

    return s;
  }

  List<int> existemCaixas(Dieta d, List<Caixa> cxs) {
    List<int> idx = <int>[];

    for (int i = 0; i < cxs.length; i++) {
      if (cxs[i].dieta == d.id) {
        idx.add(cxs[i].id);
      }
    }

    return idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dietas',
          style: const TextStyle(
              fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: dts.length,
          itemBuilder: (context, index) {
            return _listaDietas(context, index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        onPressed: () async {
          Dieta dietaRetorno = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => DietaFormAdd()));

          await db.insertDieta(dietaRetorno);
          _mostrarLista();
        },
        icon: Icon(Icons.add),
        label: Text('Adicionar'),
      ),
    );
  }

  _listaDietas(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dieta ' + dts[index].id.toString(),
                  style: const TextStyle(
                      fontSize: 36,
                      color: Colors.black54,
                      fontFamily: 'Comfortaa'),
                ),
                PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.mode_edit),
                              title: Text('Editar'),
                            ),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Apagar'),
                            ),
                            value: 'remove',
                          ),
                        ],
                    onSelected: (choice) async {
                      switch (choice) {
                        case 'edit':
                          print(dts[index]);
                          Dieta dietaRetorno = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DietaFormEdit(dieta: dts[index])));

                          setState(() {
                            db.updateDieta(dietaRetorno);
                            _mostrarLista();

                            for (int i = 0; i < cxs.length; i++) {
                              if (cxs[i].dieta == dts[index].id) {
                                cxs[i].finalCriacao = calcDataFinal(
                                    cxs[i].inicioCriacao,
                                    definirDuracao(dts, cxs[i]));
                                cdb.updateCaixa(cxs[i]);
                                _rmvEventoCaixa(evtsLista, cxs[index]);
                                _adcEventoFinal(cxs[i]);
                                _adcEventoTroca(cxs[i]);
                              }
                            }
                          });

                          break;
                        case 'remove':
                          List<int> contCaixa = existemCaixas(dts[index], cxs);

                          if (contCaixa.length > 0) {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Ação Inválida'),
                                content: Text(
                                    "Essa dieta está presente na(s) caixa(s) " +
                                        contCaixa.toString() +
                                        ", então altere-a(s) antes de apagar essa dieta."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      //Put your code here which you want to execute on Cancel button click.
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            await db.deleteDieta(dts[index].id);
                            _mostrarLista();
                          }

                          break;
                      }
                    }),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_alimentos(dts[index])),
                SizedBox(width: 10),
                Text('Trocas: A cada ' +
                    dts[index].tempoDeTroca.toString() +
                    ' dias \nRetirada da produção em: ' +
                    dts[index].tempoTotal.toString() +
                    ' dias'),
              ],
            ),
            Divider(
              color: Colors.transparent,
            ),
            Text(
              dts[index].descricao,
              style: const TextStyle(
                  fontSize: 22, color: Colors.black54, fontFamily: 'Comfortaa'),
            ),
            Divider(
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
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

  _rmvEventoCaixa(List<Evento> lista, Caixa cx) {
    for (int i = 0; i < lista.length; i++) {
      if (lista[i].idCaixa == cx.id) {
        dbe.deleteEvento(lista[i].id);
      }
    }
  }

  _adcEventoTroca(Caixa cx) {
    int eIdCaixa = 0;
    String eData = '';
    String eUrgencia = '';
    String eDescricao = '';

    String dataAux = cx.inicioCriacao;

    int intervalos = definirIntervalos(dts, cx);

    for (int i = 0; i < intervalos - 1; i++) {
      eIdCaixa = cx.id;

      eData = calcDataFinal(dataAux, definirIntervalo(dts, cx));
      dataAux = eData;

      int aux = tempoFaltante(eData);

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

      if (eUrgencia != 'Atrasado') {
        eDescricao =
            "Você deve trocar o alimento daqui a $aux dias, no dia $eData";
      } else {
        eDescricao = "Esta atividade está atrasada!";
      }

      Evento e = Evento(eIdCaixa, eUrgencia, eData, eDescricao);

      dbe.insertEvento(e);
    }
  }

  _adcEventoFinal(Caixa cx) {
    int eIdCaixa = 0;
    String eData = '';
    String eUrgencia = '';
    String eDescricao = '';

    eIdCaixa = cx.id;

    eData = calcDataFinal(cx.inicioCriacao, definirDuracao(dts, cx));

    int aux = tempoFaltante(eData);

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

    if (eUrgencia != 'Atrasado') {
      eDescricao =
          "Você deve coletar sua produção daqui a $aux dias, no dia $eData";
    } else {
      eDescricao = "Esta atividade está atrasada!";
    }

    Evento e = Evento(eIdCaixa, eUrgencia, eData, eDescricao);

    dbe.insertEvento(e);
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

  int definirIntervalo(List<Dieta> lista, Caixa cx) {
    int d = 0;

    for (int i = 0; i < lista.length; i++) {
      if (lista[i].id == cx.dieta) {
        d = lista[i].tempoDeTroca;
      }
    }

    return d;
  }

  int definirIntervalos(List<Dieta> lista, Caixa cx) {
    int d = 0;

    for (int i = 0; i < lista.length; i++) {
      if (lista[i].id == cx.dieta) {
        // print('TempoTotal: ' + lista[i].tempoTotal.toString());
        //print('TempoTroca: ' + lista[i].tempoDeTroca.toString());

        d = lista[i].tempoTotal ~/ lista[i].tempoDeTroca;
      }
    }

    // print("Número de intervalos: $d");
    return d;
  }
}
