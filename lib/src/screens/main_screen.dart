import 'package:app_epi/src/models/usuario.dart';
import 'package:flutter/material.dart';

import 'cadastrar_treinamento_screen.dart';
import 'treinamento_screen.dart'; 
import 'emprestimos_screen.dart';
import 'epi_screen.dart';
import 'funcionario_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatelessWidget {
  final Usuario usuario;

  const MainScreen({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    String mensagemPermissao = '';
    
    if (usuario.perfil.toUpperCase() == 'ADMIN') {
      mensagemPermissao = 'Você possui permissões para aprovar empréstimos e registrar devoluções';
    } else {
      mensagemPermissao = 'Você pode consultar EPIs e solicitar empréstimos.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empréstimos de EPIs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(usuario.nome),
              accountEmail: Text(usuario.perfil),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 40.0, color: Colors.blue),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety),
              title: const Text('EPIs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EpiScreen(usuario: usuario)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Meus Empréstimos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MeusEmprestimosScreen(usuario: usuario),
                  ),
                );
              },
            ),
            // Condicional do Exercício: Menu visível exclusivamente para perfil ADMIN
            if (usuario.perfil.toUpperCase() == 'ADMIN')
              ListTile(
                leading: const Icon(Icons.add_task),
                title: const Text('Cadastrar Treinamento'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CadastrarTreinamentoScreen(usuario: usuario),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Treinamentos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TreinamentosScreen(usuario: usuario),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Funcionários'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FuncionarioScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bem-vindo ${usuario.nome}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                mensagemPermissao,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
