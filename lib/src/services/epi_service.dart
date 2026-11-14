import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/epi.dart';
import 'api_config.dart';

class EpiService {
  Future<List<Epi>> buscarEpis() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/epis'));

    if (response.statusCode == 200) {
      final lista =
          jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return lista
          .map((item) => Epi.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erro ao carregar EPIs: HTTP ${response.statusCode}');
  }
}
