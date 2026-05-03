import 'package:trabalho/models/model.dart';

class Tarefa implements Model {
  int? _id;
  String titulo;
  String descricao;
  String dataPrevista;
  bool importante;
  bool realizada;
  String recompensa; 

  Tarefa({
    this.titulo = '',
    this.descricao = '',
    this.dataPrevista = '',
    this.importante = false,
    this.realizada = false,
    this.recompensa = '',
  });

  @override
  set id(int id) {
    _id = id;
  }

  @override
  int? get id => _id;

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'titulo': titulo,
      'descricao': descricao,
      'dataPrevista': dataPrevista,
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0,
      'recompensa': recompensa,
    };
    
    if (_id != null) {
      map['id'] = _id;
    }
    
    return map;
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    var tarefa = Tarefa(
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      dataPrevista: map['dataPrevista'] as String,
      importante: map['importante'] == 1,
      realizada: map['realizada'] == 1,
      recompensa: map['recompensa'] as String,
    );
    // Validação caso o banco retorne o id nulo
    if (map['id'] != null) {
      tarefa.id = map['id'] as int;
    }
    return tarefa;
  }
}