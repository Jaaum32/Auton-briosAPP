import 'package:flutter/material.dart';
import 'package:autonebriosapp/models/dieta.dart';

class DietaFormEdit extends StatefulWidget {
  final Dieta dieta;

  const DietaFormEdit({Key? key, required this.dieta}) : super(key: key);

  @override
  _DietaFormEditState createState() => _DietaFormEditState();
}

class _DietaFormEditState extends State<DietaFormEdit> {
  Dieta dt = Dieta(0, '', 0.0, '', 0.0, '', 0.0, 0, 0, '');
  var _al1Controller = TextEditingController();
  var _qtd1Controller = TextEditingController();
  var _al2Controller = TextEditingController();
  var _qtd2Controller = TextEditingController();
  var _al3Controller = TextEditingController();
  var _qtd3Controller = TextEditingController();
  var _tdtController = TextEditingController();
  var _ttController = TextEditingController();
  var _dController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _al1Controller.text = widget.dieta.alimento1;
    _qtd1Controller.text = widget.dieta.quantidade1.toString();
    _al2Controller.text = widget.dieta.alimento2;
    _qtd2Controller.text = widget.dieta.quantidade2.toString();
    _al3Controller.text = widget.dieta.alimento3;
    _qtd3Controller.text = widget.dieta.quantidade3.toString();
    _tdtController.text = widget.dieta.tempoDeTroca.toString();
    _ttController.text = widget.dieta.tempoTotal.toString();
    _dController.text = widget.dieta.descricao;

    dt.id = widget.dieta.id;
    dt.alimento1 = widget.dieta.alimento1;
    dt.quantidade1 = widget.dieta.quantidade1;
    dt.alimento2 = widget.dieta.alimento2;
    dt.quantidade2 = widget.dieta.quantidade2;
    dt.alimento3 = widget.dieta.alimento3;
    dt.quantidade3 = widget.dieta.quantidade3;
    dt.tempoDeTroca = widget.dieta.tempoDeTroca;
    dt.tempoTotal = widget.dieta.tempoTotal;
    dt.descricao = widget.dieta.descricao;
  }

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
          'Dieta ' + widget.dieta.id.toString(),
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
                        controller: _al1Controller,
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
                        controller: _qtd1Controller,
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
                        controller: _al2Controller,
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
                        controller: _qtd2Controller,
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
                        controller: _al3Controller,
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
                        controller: _qtd3Controller,
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
                        controller: _tdtController,
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
                          labelText: 'Tempo de Troca',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _ttController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Valor Inválido";
                          } else if (int.parse(value) <= 0) {
                            return "Valor(0) Inválido";
                          } else if (int.parse(value) <= dt.tempoDeTroca) {
                            return "Precisa ser maior\n que Tempo de Troca";
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
                          labelText: 'Tempo de Criação',
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
                  controller: _dController,
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
                      dt = Dieta(
                          widget.dieta.id,
                          _al1Controller.text,
                          double.parse(_qtd1Controller.text),
                          _al2Controller.text,
                          double.parse(_qtd2Controller.text),
                          _al3Controller.text,
                          double.parse(_qtd3Controller.text),
                          int.parse(_tdtController.text),
                          int.parse(_ttController.text),
                          _dController.text);
                      Navigator.pop(context, dt);
                    } else {
                      final sb = SnackBar(
                          content: Text('Existem campos incorretos'),
                          duration: Duration(seconds: 2));
                      ScaffoldMessenger.of(context).showSnackBar(sb);
                    }
                    ;
                  },
                  child: Text("Editar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
