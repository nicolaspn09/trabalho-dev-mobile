import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho/models/tarefa.dart';
import 'package:trabalho/providers/tarefa_provider.dart';

class TelaForm extends StatefulWidget {
  const TelaForm({super.key});

  @override
  State<TelaForm> createState() => _TelaFormState();
}

class _TelaFormState extends State<TelaForm> {
  final _tituloController = TextEditingController();
  final _descController = TextEditingController();
  final _catController = TextEditingController();
  DateTime? _dataSelecionada;
  bool _importante = false;
  
  Tarefa? _tarefaEditada;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        _tarefaEditada = arg as Tarefa;
        _tituloController.text = _tarefaEditada!.titulo;
        _descController.text = _tarefaEditada!.descricao;
        _catController.text = _tarefaEditada!.categoria;
        _importante = _tarefaEditada!.importante;
        if (_tarefaEditada!.dataPrevista.isNotEmpty) {
          _dataSelecionada = DateTime.parse(_tarefaEditada!.dataPrevista);
        }
      }
      _isInit = false;
    }
  }

  Future<void> _mostrarDatePicker() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  void _salvar() {
    if (_tituloController.text.isEmpty || _dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título e Data são obrigatórios!')),
      );
      return;
    }

    final dataIso = _dataSelecionada!.toIso8601String().split('T')[0];

    if (_tarefaEditada != null) {
      // Atualização
      _tarefaEditada!.titulo = _tituloController.text;
      _tarefaEditada!.descricao = _descController.text; // Regra 4: pode editar os outros campos
      _tarefaEditada!.categoria = _catController.text;
      _tarefaEditada!.dataPrevista = dataIso;
      _tarefaEditada!.importante = _importante;
      Provider.of<TarefaProvider>(context, listen: false).updateTarefa(_tarefaEditada!);
    } else {
      // Inserção
      final novaTarefa = Tarefa(
        titulo: _tituloController.text,
        descricao: _descController.text,
        categoria: _catController.text,
        dataPrevista: dataIso,
        importante: _importante,
        realizada: false, // Regra 4/2: Não pode realizar na criação/edição
      );
      Provider.of<TarefaProvider>(context, listen: false).addTarefa(novaTarefa);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tarefaEditada == null ? 'Nova Tarefa' : 'Editar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            TextField(
              controller: _catController,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            SwitchListTile(
              title: const Text('Importante?'),
              value: _importante,
              onChanged: (val) => setState(() => _importante = val),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dataSelecionada == null
                        ? 'Nenhuma data selecionada'
                        : 'Data: ${_dataSelecionada!.toIso8601String().split('T')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: _mostrarDatePicker,
                  child: const Text('Selecionar Data'),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar Tarefa'),
            )
          ],
        ),
      ),
    );
  }
}