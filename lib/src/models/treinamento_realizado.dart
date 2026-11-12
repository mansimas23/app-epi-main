import 'treinamento.dart';

class TreinamentoRealizado {
  final int id;
  final Treinamento treinamento;
  final DateTime dataConclusao;

  TreinamentoRealizado({
    required this.id,
    required this.treinamento,
    required this.dataConclusao,
  });

  factory TreinamentoRealizado.fromJson(Map<String, dynamic> json) {
    return TreinamentoRealizado(
      id: json['id'],
      treinamento: Treinamento.fromJson(json['treinamento']),
      dataConclusao: DateTime.parse(json['dataConclusao']),
    );
  }

  String get dataFormatada {
    final dia = dataConclusao.day.toString().padLeft(2, '0');
    final mes = dataConclusao.month.toString().padLeft(2, '0');
    return '$dia/$mes/${dataConclusao.year}';
  }

  // LÓGICA DO DESAFIO: Verifica se o treinamento está vencido
  bool get estaVencido {
    if (treinamento.validadeMeses == null) return false;

    // Calcula a data limite somando os meses de validade
    final dataLimite = DateTime(
      dataConclusao.year,
      dataConclusao.month + treinamento.validadeMeses!,
      dataConclusao.day,
    );

    // Se a data atual for depois da data limite, venceu
    return DateTime.now().isAfter(dataLimite);
  }
}
