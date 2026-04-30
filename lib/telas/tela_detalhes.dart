import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/providers/tarefa_provider.dart';

class TelaDetalhes extends StatelessWidget {
  const TelaDetalhes({super.key});

  @override
  Widget build(BuildContext context) {
    // Recebe a tarefa passada por argumento na rota
    final Tarefa tarefa = ModalRoute.of(context)?.settings.arguments as Tarefa;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Requisito 2: ID e descrição mostrados APENAS aqui
            Text("ID da Tarefa: ${tarefa.id}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 10),
            Text(tarefa.titulo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const Divider(),
            Text("Descrição:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(tarefa.descricao.isEmpty ? "Sem descrição." : tarefa.descricao, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text("Categoria: ${tarefa.categoria}", style: const TextStyle(fontSize: 16)),
            Text("Vencimento: ${tarefa.dataPrevista}", style: const TextStyle(fontSize: 16)),
            Text(
              tarefa.importante ? "⚠️ Tarefa Importante" : "Tarefa Normal",
              style: TextStyle(fontSize: 16, color: tarefa.importante ? Colors.orange : Colors.black),
            ),
            const Spacer(),
            // Requisito 2 e 4: Realizar a tarefa apenas nesta tela
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tarefa.realizada ? Colors.grey : Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                icon: Icon(tarefa.realizada ? Icons.undo : Icons.check, color: Colors.white),
                label: Text(
                  tarefa.realizada ? "Desmarcar Tarefa" : "Realizar Tarefa",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  // Inverte o status da tarefa
                  tarefa.realizada = !tarefa.realizada;
                  
                  // Atualiza no banco de dados através do Provider
                  Provider.of<TarefaProvider>(context, listen: false).updateTarefa(tarefa);
                  
                  // Volta para a tela anterior
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tarefa.realizada ? 'Tarefa concluída!' : 'Tarefa reaberta!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}