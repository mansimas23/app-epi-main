class Epi {
  final int id;
  final String nome;
  final String categoria;
  final String ca;
  final String imagemUrl; // Modificado para deixar com 'm'
  final int quantidadeDisponivel; // Exercício 3a
  final DateTime validadeCa;      // Exercício 3b
  final bool caVencido;           // Exercício 3b

  Epi({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.ca,
    required this.imagemUrl, // Modificado para deixar com 'm'
    required this.quantidadeDisponivel,
    required this.validadeCa,
    required this.caVencido,
  });

  // Construtor de fábrica que converte um JSON recebido da API
  // em um objeto Epi do Flutter.
  // Cada campo do JSON é associado ao atributo correspondente da classe.
  factory Epi.fromJson(Map<String, dynamic> json) {
    // Tratamento preventivo caso a data venha nula da API
    final dataTexto = json['validadeCa'] ?? DateTime.now().toIso8601String();
    final validade = DateTime.parse(dataTexto);

    return Epi(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      categoria: json['categoria'] ?? '',
      ca: json['ca'] ?? '',
      // Tenta ler com 'm' ou sem 'm' da API. Se ambos forem nulos, deixa vazio '' para não quebrar
      imagemUrl: json['imagemUrl'] ?? json['imageUrl'] ?? '',
      quantidadeDisponivel: json['quantidadeDisponivel'] ?? 0,
      validadeCa: validade,
      // O método isCaVencido() do Java vira o campo "caVencido" no JSON.
      // Se por algum motivo ele não vier, o app calcula pela data.
      caVencido: json['caVencido'] ?? validade.isBefore(DateTime.now()),
    );
  }

  // Data no formato brasileiro: 30/06/2025
  String get validadeFormatada {
    final dia = validadeCa.day.toString().padLeft(2, '0');
    final mes = validadeCa.month.toString().padLeft(2, '0');
    return '$dia/$mes/${validadeCa.year}';
  }
}
