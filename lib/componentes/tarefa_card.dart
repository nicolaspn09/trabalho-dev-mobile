import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/util/rotas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho/providers/tarefa_provider.dart';

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
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => Navigator.pushNamed(context, Rotas.telaForm, arguments: tarefa),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Popup de confirmação antes de excluir
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Tarefa'),
                      content: const Text('Tem certeza? Esta ação não pode ser desfeita.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<TarefaProvider>(context, listen: false).deleteTarefa(tarefa.id!);
                            Navigator.pop(ctx);
                          },
                          child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        onTap: () => Navigator.pushNamed(context, Rotas.telaDetalhes, arguments: tarefa),
      ),
    );
  }
}