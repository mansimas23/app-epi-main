import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';

/// Acesso de demonstração local. Não utilizar com dados reais.
class LocalDemoAuth {
  static const matricula = '1001';
  static const codigoRecuperacao = 'EPI-DEMO-2026';
  static Future<bool> entrar(String usuario, String senha) async {
    final prefs = await SharedPreferences.getInstance();
    return usuario.trim().toLowerCase() == matricula && senha == (prefs.getString('epi_demo_senha') ?? '123456');
  }
  static Future<bool> redefinir(String codigo, String novaSenha) async {
    if (codigo.trim() != codigoRecuperacao || novaSenha.length < 6) return false;
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('epi_demo_senha', novaSenha);
  }
  static Usuario get admin => Usuario(id: 1, matricula: matricula, nome: 'Administrador', setor: 'Segurança do Trabalho', perfil: 'ADMIN');
}
