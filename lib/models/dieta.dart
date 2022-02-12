class Dieta {
  late int id;
  late String alimento1;
  late double quantidade1;
  late String alimento2;
  late double quantidade2;
  late String alimento3;
  late double quantidade3;
  late int tempoDeTroca;
  late int tempoTotal;
  late String descricao;

  Dieta(
      this.id,
      this.alimento1,
      this.quantidade1,
      this.alimento2,
      this.quantidade2,
      this.alimento3,
      this.quantidade3,
      this.tempoDeTroca,
      this.tempoTotal,
      this.descricao);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      //'id': id,
      'alimento1': alimento1,
      'quantidade1': quantidade1,
      'alimento2': alimento2,
      'quantidade2': quantidade2,
      'alimento3': alimento3,
      'quantidade3': quantidade3,
      'tempoDeTroca': tempoDeTroca,
      'tempoTotal': tempoTotal,
      'descricao': descricao
    };
    return map;
  }

  Dieta.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    alimento1 = map['alimento1'];
    quantidade1 = map['quantidade1'].toDouble();
    alimento2 = map['alimento2'];
    quantidade2 = map['quantidade2'].toDouble();
    alimento3 = map['alimento3'];
    quantidade3 = map['quantidade3'].toDouble();
    tempoDeTroca = map['tempoDeTroca'];
    tempoTotal = map['tempoTotal'];
    descricao = map['descricao'];
  }

  @override
  String toString() {
    return 'Dieta{id: $id, alimento1: $alimento1, quantidade1: $quantidade1, alimento2: $alimento2, quantidade2: $quantidade2, alimento3: $alimento3, quantidade3: $quantidade3, tempoDeTroca: $tempoDeTroca, tempoTotal: $tempoTotal, descricao: $descricao}';
  }
}
