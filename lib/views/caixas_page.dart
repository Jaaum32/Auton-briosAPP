// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:autonebriosapp/helpers/db_helper_caixa.dart';
import 'package:autonebriosapp/helpers/db_helper_dieta.dart';
import 'package:autonebriosapp/helpers/db_helper_evento.dart';
import 'package:autonebriosapp/models/caixa.dart';
import 'package:autonebriosapp/models/dieta.dart';
import 'package:autonebriosapp/models/evento.dart';
import 'package:autonebriosapp/qr/criacao_qr_code.dart';
import 'package:autonebriosapp/qr/leitor_qr_code.dart';
import 'package:autonebriosapp/views/crud/caixa_form_add.dart';
import 'package:autonebriosapp/views/crud/caixa_form_edit.dart';
import 'package:flutter/material.dart';

import 'caixa_page.dart';

class CaixasPage extends StatefulWidget {
  const CaixasPage({Key? key}) : super(key: key);

  @override
  _CaixasPageState createState() => _CaixasPageState();
}

class _CaixasPageState extends State<CaixasPage> {
  DatabaseHelperCaixa db = DatabaseHelperCaixa();
  DatabaseHelperDieta dhd = DatabaseHelperDieta();
  DatabaseHelperEvento dbe = DatabaseHelperEvento();
  List<Caixa> cxs = <Caixa>[];
  List<Dieta> dtsLista = <Dieta>[];
  List<Evento> evtsLista = <Evento>[];

  @override
  void initState() {
    super.initState();

    dhd.getDietas().then((lista) {
      setState(() {
        dtsLista = lista;
      });
    });

    dbe.getEventos().then((lista) {
      setState(() {
        evtsLista = lista;
      });
    });

    _mostrarLista();
  }

  Future _mostrarLista() async {
    await db.getCaixas().then((lista) {
      print(lista);
      setState(() {
        cxs = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Caixas',
            style: const TextStyle(
                fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
          ),
          IconButton(
            icon: const Icon(
              //leitor
              Icons.qr_code_scanner,
            ),
            iconSize: 50,
            color: Colors.white,
            onPressed: () {
              if (cxs.length > 0) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LeitorPage()));
              } else {
                final sb = SnackBar(
                    content: Text('Não há nenhuma caixa salva!'),
                    duration: Duration(seconds: 2));
                ScaffoldMessenger.of(context).showSnackBar(sb);
              }
            },
          ),
        ]),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cxs.length,
          itemBuilder: (context, index) {
            return _listaCaixas(context, index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        onPressed: () async {
          if (dtsLista.length > 0) {
            Caixa caixaRetorno = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CaixaFormAdd()));

            await db.insertCaixa(caixaRetorno).then((value) async {
              await _mostrarLista().then((value) {
                _adcEventoFinal(cxs[cxs.length - 1]);
                _adcEventoTroca(cxs[cxs.length - 1]);
              });
            });
          } else {
            final sb = SnackBar(
                content: Text(
                    'Para adicionar uma caixa, primeiro você precisa adicionar uma dieta!'),
                duration: Duration(seconds: 2));
            ScaffoldMessenger.of(context).showSnackBar(sb);
          }
        },
        icon: Icon(Icons.add),
        label: Text('Adicionar'),
      ),
    );
  }

  _listaCaixas(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CaixaPage(
                      caixa: cxs[index],
                    )));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 80,
                  height: 80,
                  child: QrCodeGenerator(idCaixa: cxs[index].id)),
              Text(
                'Caixa ' + cxs[index].id.toString(),
                style: const TextStyle(
                    fontSize: 36,
                    color: Colors.black54,
                    fontFamily: 'Comfortaa'),
              ),
              PopupMenuButton<String>(
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
                  // other items...
                ],
                onSelected: (choice) async {
                  switch (choice) {
                    case 'edit':
                      Caixa caixaRetorno = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CaixaFormEdit(caixa: cxs[index])));

                      setState(() {
                        db.updateCaixa(caixaRetorno);
                        _mostrarLista();
                        _rmvEventoCaixa(evtsLista, cxs[index]);
                        _adcEventoFinal(caixaRetorno);
                        _adcEventoTroca(caixaRetorno);
                      });

                      break;
                    case 'remove':
                      await db.deleteCaixa(cxs[index].id);
                      _rmvEventoCaixa(evtsLista, cxs[index]);
                      _mostrarLista();
                      break;
                    // other cases...
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
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

    int intervalos = definirIntervalos(dtsLista, cx);

    for (int i = 0; i < intervalos - 1; i++) {
      eIdCaixa = cx.id;

      eData = calcDataFinal(dataAux, definirIntervalo(dtsLista, cx));
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

    eData = calcDataFinal(cx.inicioCriacao, definirDuracao(dtsLista, cx));

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

  int definirDuracao(List<Dieta> lista, Caixa cx) {
    int d = 0;

    for (int i = 0; i < lista.length; i++) {
      if (lista[i].id == cx.dieta) {
        d = lista[i].tempoTotal;
      }
    }

    return d;
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
