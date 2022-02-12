// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:autonebriosapp/helpers/db_helper_dieta.dart';
import 'package:autonebriosapp/models/caixa.dart';
import 'package:autonebriosapp/models/dieta.dart';

class CaixaFormAdd extends StatefulWidget {
  const CaixaFormAdd({Key? key}) : super(key: key);

  @override
  _CaixaFormAddState createState() => _CaixaFormAddState();
}

class _CaixaFormAddState extends State<CaixaFormAdd> {
  DatabaseHelperDieta dhd = DatabaseHelperDieta();
  Caixa cx = Caixa(0, ' ', ' ', 0.0, 0.0, 0, '');

  String alert = "Esse campo não pode ser vazio!";

  bool valid = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Dieta> dtsLista = <Dieta>[];
  List<String> dietas = <String>[];
  List<String> funcoes = <String>['Postura de ovos', 'Produção da larva'];
  String initD = "";

  @override
  void initState() {
    super.initState();

    dhd.getDietas().then((lista) {
      setState(() {
        dtsLista = lista;
        dietas = listaDieta(lista);
        initD = dietas[0];
        cx.dieta = int.parse(initD.substring(6));
        cx.funcao = funcoes[0];
      });
    });
  }

  int definirDuracao(List<Dieta> lista) {
    int d = 0;

    for (int i = 0; i < lista.length; i++) {
      if (lista[i].id == cx.dieta) {
        d = lista[i].tempoTotal;
      }
    }

    return d;
  }

  List<String> listaDieta(List<Dieta> lista) {
    List<String> l = <String>[];

    for (int i = 0; i < lista.length; i++) {
      l.add("Dieta " + lista[i].id.toString());
    }

    return l;
  }

  void validate() {
    if (formKey.currentState!.validate()) {
      print("validated");
    } else {
      print("not validated");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nova caixa',
          style: const TextStyle(
              fontSize: 36, color: Colors.white, fontFamily: 'Comfortaa'),
        ),
      ),
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 8, left: 8, right: 8),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ignore: prefer_const_constructors
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Valor Inválido";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (value != '') {
                          cx.inicioCriacao = value;
                        }
                      },
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: 'Data de Inicio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          cx.dieta = int.parse(newValue!.substring(6));

                        });
                      },
                      value: initD,
                      items: dietas.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20),
                              ));
                        },
                      ).toList(),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          cx.funcao = newValue!;

                        });
                      },
                      value: funcoes[0],
                      items: funcoes.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20),
                              ));
                        },
                      ).toList(),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          minimumSize: Size(167, 52)),
                      onPressed: () async {
                        print(cx);
                        print(calcDataFinal(
                            cx.inicioCriacao, definirDuracao(dtsLista)));
                        cx.finalCriacao = calcDataFinal(
                            cx.inicioCriacao, definirDuracao(dtsLista));
                        Navigator.pop(context, cx);
                      },
                      child: Text("Adicionar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
