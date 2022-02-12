import 'package:flutter/material.dart';
import 'package:autonebriosapp/helpers/db_helper_dieta.dart';
import 'package:autonebriosapp/models/dieta.dart';

class DietaFormAdd extends StatefulWidget {
  const DietaFormAdd({Key? key}) : super(key: key);

  @override
  _DietaFormAddState createState() => _DietaFormAddState();
}

class _DietaFormAddState extends State<DietaFormAdd> {
  DatabaseHelperDieta db = DatabaseHelperDieta();
  Dieta dt = Dieta(0, '', 0.0, '', 0.0, '', 0.0, 0, 0, '');

  String alert = 'Esse campo não pode ser vazio!';

  bool valid = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void validate() {
    if (formKey.currentState!.validate()) {
      print("validated");
    } else {
      print("not validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nova dieta',
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
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Valor Inválido";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value != '') {
                            dt.alimento1 = value;
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Alimento 1',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Valor Inválido";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value != '') {
                            dt.quantidade1 = double.parse(value);
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Qtd 1 (g)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        validator: (value) {
                          return null;
                        },
                        onChanged: (value) {
                          if (value != '') {
                            dt.alimento2 = value;
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Alimento 2',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          // if (value!.isEmpty && dt.alimento2.isEmpty) {
                          //   return "Valor Inválido";
                          // } else if (double.parse(value) <= 0 && dt.alimento2.isNotEmpty) {
                          //   return "Valor(0) Inválido";
                          // } else {
                          //   return null;
                          // }
                        },
                        onChanged: (value) {
                          if (value != '') {
                            dt.quantidade2 = double.parse(value);
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Qtd 2 (g)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value != '') {
                            dt.alimento3 = value;
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Alimento 3',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty &&
                        //       dt.quantidade3.toString().isNotEmpty) {
                        //     return "Valor Inválido";
                        //   } else if (double.parse(value) <= 0 &&
                        //       dt.quantidade3.toString().isNotEmpty) {
                        //     return "Valor(0) Inválido";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        onChanged: (value) {
                          if (value != '') {
                            dt.quantidade3 = double.parse(value);
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Qtd 3 (g)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Valor Inválido";
                          } else if (int.parse(value) <= 0) {
                            return "Valor(0) Inválido";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value != '') {
                            dt.tempoDeTroca = int.parse(value);
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Tempo de Troca (Dias)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Valor Inválido";
                          } else if (int.parse(value) <= 0) {
                            return "Valor(0) Inválido";
                          } else if (int.parse(value) <= dt.tempoDeTroca) {
                            return "Precisa ser maior \nque Tempo de Troca";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          if (value != '') {
                            dt.tempoTotal = int.parse(value);
                          }
                        },
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: 'Tempo de Criação (Dias)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.transparent,
                ),
                TextFormField(
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return "Valor Inválido";
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  maxLines: 7,
                  onChanged: (value) {
                    if (value != '') {
                      dt.descricao = value;
                    }
                  },
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
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
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, dt);
                    }else {
                      final sb = SnackBar(
                          content: Text('Existem campos incorretos'),
                          duration: Duration(seconds: 2));
                      ScaffoldMessenger.of(context).showSnackBar(sb);
                    };
                  },
                  child: Text("Adicionar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
