import 'dieta.dart';

class Caixa {
  late int id;
  late String inicioCriacao;
  late String finalCriacao;
  late double temperatura;
  late double umidade;
  late int dieta;
  late String funcao;


  Caixa(this.id, this.inicioCriacao, this.finalCriacao, this.temperatura, this.umidade, this.dieta, this.funcao);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'inicioCriacao': inicioCriacao,
      'finalCriacao': finalCriacao,
      'temperatura': temperatura,
      'umidade': umidade,
      'dieta': dieta,
      'funcao': funcao,
    };
    return map;
  }

  Caixa.fromMap(Map<String, dynamic> map){
    id = map['id'];
    inicioCriacao = map['inicioCriacao'].toString();
    finalCriacao = map['finalCriacao'].toString();
    temperatura = map['temperatura'].toDouble();
    umidade = map['umidade'].toDouble();
    dieta = map['dieta'];
    funcao = map['funcao'];
  }

  @override
  String toString() {
    return 'Caixa{id: $id, inicioCriacao: $inicioCriacao, finalCriacao: $finalCriacao, temperatura: $temperatura, umidade: $umidade, dieta: $dieta, funcao: $funcao'
        '}';
  }
}

