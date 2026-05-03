import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/util/rotas.dart';
import 'package:flutter/material.dart';

class TarefaCard extends StatelessWidget {
  final Tarefa tarefa;

  const TarefaCard({super.key, required this.tarefa});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(tarefa.titulo),
        subtitle: Text("Vence em: ${tarefa.dataPrevista}\nRecompensa: ${tarefa.recompensa}"),
        leading: Icon(
          tarefa.realizada ? Icons.check_circle : Icons.circle_outlined,
          color: tarefa.realizada ? Colors.green : Colors.grey,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => Navigator.pushNamed(context, Rotas.telaForm, arguments: tarefa),
        ),
        onTap: () => Navigator.pushNamed(context, Rotas.telaDetalhes, arguments: tarefa),
      ),
    );
  }
}