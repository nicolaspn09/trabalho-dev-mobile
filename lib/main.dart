import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho/providers/tarefa_provider.dart';
import 'package:trabalho/util/rotas.dart';
import 'package:trabalho/telas/tela_lista.dart';
import 'package:trabalho/telas/tela_form.dart';
import 'package:trabalho/telas/tela_detalhes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TarefaProvider()),
      ],
      child: MaterialApp(
        title: 'App de Tarefas',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: Rotas.boasVindas,
        routes: {
          Rotas.boasVindas: (context) => const TelaBoasVindas(),
          Rotas.telaLista: (context) => const TelaLista(),
          Rotas.telaForm: (context) => const TelaForm(),
          Rotas.telaDetalhes: (context) => const TelaDetalhes(),
        },
      ),
    );
  }
}

class TelaBoasVindas extends StatefulWidget {
  const TelaBoasVindas({super.key});

  @override
  State<TelaBoasVindas> createState() => _TelaBoasVindasState();
}

class _TelaBoasVindasState extends State<TelaBoasVindas> {
  late Future<void> _carregarTarefasFuture;

  @override
  void initState() {
    super.initState();
    // Inicia o carregamento do banco de dados assim que o app abre
    _carregarTarefasFuture = Provider.of<TarefaProvider>(context, listen: false).carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _carregarTarefasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<TarefaProvider>(
            builder: (context, provider, child) {
              final proxima = provider.proximaAVencer;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.task_alt, size: 100, color: Colors.deepPurple),
                      const SizedBox(height: 20),
                      const Text(
                        "Bem-vindo ao Tarefas App!",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      // Requisito 7: Mostrar título e data da tarefa mais perto de vencer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepPurple.shade200),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Próxima Tarefa a Vencer:",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            if (proxima != null) ...[
                              Text(proxima.titulo, style: const TextStyle(fontSize: 22, color: Colors.deepPurple)),
                              Text("Data: ${proxima.dataPrevista}", style: const TextStyle(fontSize: 16)),
                            ] else ...[
                              const Text("Você não tem tarefas pendentes!", style: TextStyle(fontSize: 16)),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          // Navega para a lista e substitui a tela atual para não voltar para as boas-vindas com o botão "voltar" do celular
                          Navigator.pushReplacementNamed(context, Rotas.telaLista);
                        },
                        child: const Text("Entrar"),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}