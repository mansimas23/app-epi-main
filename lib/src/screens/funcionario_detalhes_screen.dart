import 'package:flutter/material.dart';
import '../models/funcionario.dart';
import '../models/treinamento_realizado.dart';
import '../services/treinamento_service.dart';

class FuncionarioDetalhesScreen extends StatefulWidget {
  final Funcionario funcionario;

  const FuncionarioDetalhesScreen({super.key, required this.funcionario});

  @override
  State<FuncionarioDetalhesScreen> createState() => _FuncionarioDetalhesScreenState();
}

class _FuncionarioDetalhesScreenState extends State<FuncionarioDetalhesScreen> {
  late Future<List<TreinamentoRealizado>> _buscaTreinamentos;

  @override
  void initState() {
    super.initState();
    _buscaTreinamentos = TreinamentoService().buscarRealizados(widget.funcionario.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.funcionario.nome),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CORRIGIDO: Removido o 'width' do Card e envelopado com SizedBox
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Setor: ${widget.funcionario.setor}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Matrícula: ${widget.funcionario.matricula}'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Histórico de Treinamentos Concluídos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<TreinamentoRealizado>>(
                future: _buscaTreinamentos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
                  }
                  
                  final realizados = snapshot.data ?? [];
                  
                  if (realizados.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text('Nenhum treinamento concluído por este funcionário.'),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: realizados.length,
                    itemBuilder: (context, index) {
                      final registro = realizados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.verified, color: Colors.green),
                          title: Text(
                            registro.treinamento.titulo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(registro.treinamento.descricao ?? 'Sem descrição'),
                          trailing: Chip(
                            label: Text(registro.dataFormatada),
                            backgroundColor: Colors.green.shade50,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
