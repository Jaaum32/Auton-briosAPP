class Evento {
  late int id;
  late int idCaixa;
  late String urgencia;
  late String data;
  late String descricao;

  Evento(this.idCaixa, this.urgencia, this.data, this.descricao);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      //'id': id,
      'idCaixa': idCaixa,
      'urgencia': urgencia,
      'data': data,
      'descricao': descricao,
    };
    return map;
  }

  Evento.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idCaixa = map['idCaixa'];
    urgencia = map['urgencia'];
    data = map['data'];
    descricao = map['descricao'];
  }

  @override
  String toString() {
    return 'Evento{id: $id, idCaixa: $idCaixa, urgencia: $urgencia, data: $data, descricao: $descricao}';
  }
}
