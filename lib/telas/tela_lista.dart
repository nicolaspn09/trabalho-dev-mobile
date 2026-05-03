import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/providers/tarefa_provider.dart';
import 'package:trabalho/util/rotas.dart';
import 'package:trabalho/componentes/tarefa_card.dart';

class TelaLista extends StatelessWidget {
  const TelaLista({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Tarefas'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Importantes"),
              Tab(text: "Não Importantes"),
              Tab(text: "Realizadas"),
              Tab(text: "Não Realizadas"),
              Tab(text: "Atrasadas"),
              Tab(text: "No Prazo"),
            ],
          ),
        ),
        body: Consumer<TarefaProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: [
                _buildLista(provider.importantes, context),
                _buildLista(provider.naoImportantes, context),
                _buildLista(provider.realizadas, context),
                _buildLista(provider.naoRealizadas, context),
                _buildLista(provider.atrasadas, context),
                _buildLista(provider.noPrazo, context),
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

  Widget _buildLista(List<Tarefa> lista, BuildContext context) {
    if (lista.isEmpty) {
      return const Center(child: Text("Nenhuma tarefa encontrada."));
    }
    return ListView.builder(
      itemCount: lista.length,
      itemBuilder: (ctx, i) {
        return TarefaCard(tarefa: lista[i]);
      },
    );
  }
}