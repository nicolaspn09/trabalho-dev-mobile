import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/providers/tarefa_provider.dart';
import 'package:trabalho/util/rotas.dart';

class TelaLista extends StatelessWidget {
  const TelaLista({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Tarefas'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.list), text: "Todas"),
              Tab(icon: Icon(Icons.star), text: "Importantes"),
              Tab(icon: Icon(Icons.warning), text: "Atrasadas"),
              Tab(icon: Icon(Icons.done_all), text: "Realizadas"),
            ],
          ),
        ),
        body: Consumer<TarefaProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                _buildLista(provider.tarefas, context),
                _buildLista(provider.importantes, context),
                _buildLista(provider.atrasadas, context),
                _buildLista(provider.realizadas, context),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, Rotas.telaForm),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Componente reutilizável exigido no requisito 9
  Widget _buildLista(List<Tarefa> lista, BuildContext context) {
    if (lista.isEmpty) {
      return const Center(child: Text("Nenhuma tarefa encontrada."));
    }
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (ctx, i) {
        final tarefa = lista[i];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(tarefa.titulo),
            subtitle: Text("Vence em: ${tarefa.dataPrevista}\nCategoria: ${tarefa.categoria}"),
            // Requisito 2: Não mostra ID nem descrição aqui
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
      },
    );
  }
}