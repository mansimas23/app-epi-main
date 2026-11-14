import 'package:flutter/material.dart';
import '../models/emprestimo.dart';
import '../models/usuario.dart';
import '../services/emprestimo_service.dart';

class MeusEmprestimosScreen extends StatelessWidget {
  final Usuario usuario; // Requisito 1e: Restringe ao usuário logado

  const MeusEmprestimosScreen({
    super.key,
    required this.usuario,
  });

  // Requisito 3: Define as cores baseadas no status do empréstimo
  Color obterCorStatus(String status) {
    switch (status.toUpperCase()) {
      case 'SOLICITADO':
        return Colors.orange;
      case 'EMPRESTADO':
        return Colors.green;
      case 'DEVOLVIDO':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Empréstimos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Emprestimo>>(
        future: EmprestimoService().buscarPorFuncionario(usuario.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final lista = snapshot.data ?? [];

          if (lista.isEmpty) {
            return const Center(
              child: Text('Você não possui nenhuma solicitação de empréstimo.'),
            );
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final emprestimo = lista[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // CORREÇÃO: Alterado de 'between' para 'spaceBetween'
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Requisito 1d: Nome do EPI
                          Expanded(
                            child: Text(
                              emprestimo.epi.nome,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Requisito 3: Badge com a cor correta do status
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: obterCorStatus(emprestimo.status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              emprestimo.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Requisito 1d: Data da solicitação
                      Text(
                        'Data do pedido: ${emprestimo.dataFormatada}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      // Requisito 1d: Motivo (observacao)
                      Text(
                        'Motivo: ${emprestimo.observacao.isNotEmpty ? emprestimo.observacao : "Não informado"}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
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
