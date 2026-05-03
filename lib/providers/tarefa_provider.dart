import 'package:flutter/material.dart';
import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/util/db.dart';

class TarefaProvider with ChangeNotifier {
  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => [..._tarefas];

  // 1. Importantes ou não
  List<Tarefa> get importantes => _tarefas.where((t) => t.importante).toList();
  List<Tarefa> get naoImportantes => _tarefas.where((t) => !t.importante).toList();

  // 2. Realizadas ou não
  List<Tarefa> get realizadas => _tarefas.where((t) => t.realizada).toList();
  List<Tarefa> get naoRealizadas => _tarefas.where((t) => !t.realizada).toList();

  // 3. Atrasadas ou não (comparando apenas datas sem as horas)
  List<Tarefa> get atrasadas {
    final hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _tarefas.where((t) {
      if (t.realizada || t.dataPrevista.isEmpty) return false;
      return DateTime.parse(t.dataPrevista).isBefore(hoje);
    }).toList();
  }

  List<Tarefa> get noPrazo {
    final hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _tarefas.where((t) {
      if (t.realizada || t.dataPrevista.isEmpty) return false;
      return !DateTime.parse(t.dataPrevista).isBefore(hoje); 
    }).toList();
  }

  // Busca a tarefa mais próxima de vencer (para a tela inicial)
  Tarefa? get proximaAVencer {
    final pendentes = _tarefas.where((t) => !t.realizada && t.dataPrevista.isNotEmpty).toList();
    if (pendentes.isEmpty) return null;

    pendentes.sort((a, b) => DateTime.parse(a.dataPrevista).compareTo(DateTime.parse(b.dataPrevista)));
    return pendentes.first;
  }

  Future<void> carregarTarefas() async {
    final data = await DBUtil.list(DBUtil.tableTarefas);
    _tarefas = data.map((item) => Tarefa.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addTarefa(Tarefa tarefa) async {
    await DBUtil.insert(DBUtil.tableTarefas, tarefa);
    await carregarTarefas(); // Recarrega para pegar o ID gerado pelo banco
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    await DBUtil.update(DBUtil.tableTarefas, tarefa);
    await carregarTarefas();
  }

  Future<void> deleteTarefa(int id) async {
    await DBUtil.delete(DBUtil.tableTarefas, id);
    await carregarTarefas();
  }
}