class Treinamento {
  final int id;
  final String titulo;
  final String? descricao;
  final String? arquivoUrl;
  final int? validadeMeses; // NOVO CAMPO

  Treinamento({
    required this.id,
    required this.titulo,
    this.descricao,
    this.arquivoUrl,
    this.validadeMeses, // ADICIONADO
  });

  factory Treinamento.fromJson(Map<String, dynamic> json) {
    return Treinamento(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      arquivoUrl: json['arquivoUrl'],
      validadeMeses: json['validadeMeses'], // ADICIONADO
    );
  }
}
