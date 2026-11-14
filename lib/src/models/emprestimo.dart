import 'epi.dart';

class Emprestimo {
  final int id;
  final DateTime dataEmprestimo;
  final String status;
  final String observacao;
  final Epi epi;

  Emprestimo({
    required this.id,
    required this.dataEmprestimo,
    required this.status,
    required this.observacao,
    required this.epi,
  });

  factory Emprestimo.fromJson(Map<String, dynamic> json) {
    // Tratamento caso a data venha nula ou em formatos diferentes
    final dataTexto = json['dataEmprestimo'] ?? DateTime.now().toIso8601String();
    
    return Emprestimo(
      id: json['id'] ?? 0,
      dataEmprestimo: DateTime.parse(dataTexto),
      status: json['status'] ?? 'SOLICITADO',
      observacao: json['observacao'] ?? '',
      // Requisito 1b: converte o EPI embutido dentro do JSON
      epi: Epi.fromJson(json['epi'] ?? {}),
    );
  }

  // Getter auxiliar para formatar a data de solicitação na tela brasileira
  String get dataFormatada {
    final dia = dataEmprestimo.day.toString().padLeft(2, '0');
    final mes = dataEmprestimo.month.toString().padLeft(2, '0');
    return '$dia/$mes/${dataEmprestimo.year}';
  }
}
