import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/treinamento.dart';
import '../models/treinamento_realizado.dart';
import 'api_config.dart';

class TreinamentoService {
  // GET /treinamentos
  Future<List<Treinamento>> buscarTreinamentos() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/treinamentos'),
    );

    if (response.statusCode == 200) {
      List<dynamic> lista = json.decode(utf8.decode(response.bodyBytes));
      return lista.map((item) => Treinamento.fromJson(item)).toList();
    }
    throw Exception('Erro ao carregar treinamentos');
  }

  // POST /treinamentos (Com upload direto de arquivo via Multipart)
  Future<void> cadastrar({
    required String titulo,
    String? descricao,
    Uint8List? arquivoBytes, // Bytes do arquivo escolhido
    String? nomeArquivo,     // Nome original do arquivo (ex: nr35.pdf)
    int? validadeMeses,
    required int adminId,
  }) async {
    // Usa o ApiConfig.baseUrl e mantém o adminId na URL como no seu padrão original
    final uri = Uri.parse('${ApiConfig.baseUrl}/treinamentos?adminId=$adminId');

    final request = http.MultipartRequest('POST', uri);

    // Campos de texto
    request.fields['titulo'] = titulo;

    if (descricao != null && descricao.isNotEmpty) {
      request.fields['descricao'] = descricao;
    }
    if (validadeMeses != null) {
      request.fields['validadeMeses'] = validadeMeses.toString();
    }

    // Anexa o arquivo físico se o usuário selecionou algum
    if (arquivoBytes != null && nomeArquivo != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'arquivo', // Nome do parâmetro esperado no Java (@RequestParam("arquivo"))
          arquivoBytes,
          filename: nomeArquivo,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }
    throw Exception(utf8.decode(response.bodyBytes));
  }

  // GET /treinamentos/realizados/funcionario/3
  Future<List<TreinamentoRealizado>> buscarRealizados(
      int funcionarioId) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/treinamentos/realizados/funcionario/$funcionarioId',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> lista = json.decode(utf8.decode(response.bodyBytes));
      return lista
          .map((item) => TreinamentoRealizado.fromJson(item))
          .toList();
    }
    throw Exception('Erro ao carregar treinamentos concluídos');
  }

  // POST /treinamentos/2/concluir?funcionarioId=3
  Future<void> concluir(int treinamentoId, int funcionarioId) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/treinamentos/$treinamentoId/concluir'
        '?funcionarioId=$funcionarioId',
      ),
    );

    if (response.statusCode == 201) {
      return;
    }
    throw Exception(utf8.decode(response.bodyBytes));
  }
}
