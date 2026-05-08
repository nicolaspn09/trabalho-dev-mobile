import 'package:flutter/material.dart';
import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/util/db.dart';

class TarefaProvider with ChangeNotifier {
  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => [..._tarefas];

  List<Tarefa> _ordenarPorData(List<Tarefa> lista) {
    lista.sort((a, b) {
      if (a.dataPrevista.isEmpty) return 1;
      if (b.dataPrevista.isEmpty) return -1;
      return DateTime.parse(a.dataPrevista).compareTo(DateTime.parse(b.dataPrevista));
    });
    return lista;
  }

  List<Tarefa> get importantes => _ordenarPorData(_tarefas.where((t) => t.importante).toList());
  List<Tarefa> get naoImportantes => _ordenarPorData(_tarefas.where((t) => !t.importante).toList());

  List<Tarefa> get realizadas => _ordenarPorData(_tarefas.where((t) => t.realizada).toList());
  List<Tarefa> get naoRealizadas => _ordenarPorData(_tarefas.where((t) => !t.realizada).toList());

  List<Tarefa> get atrasadas {
    final hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _ordenarPorData(_tarefas.where((t) {
      if (t.realizada || t.dataPrevista.isEmpty) return false;
      return DateTime.parse(t.dataPrevista).isBefore(hoje);
    }).toList());
  }

  List<Tarefa> get noPrazo {
    final hoje = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _ordenarPorData(_tarefas.where((t) {
      if (t.realizada || t.dataPrevista.isEmpty) return false;
      return !DateTime.parse(t.dataPrevista).isBefore(hoje); 
    }).toList());
  }

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
    await carregarTarefas();
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