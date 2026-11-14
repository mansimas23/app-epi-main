import 'package:flutter/material.dart';
import '../models/usuario.dart';
import 'login_screen.dart';
import 'epi_screen.dart';
import 'funcionario_screen.dart';
import 'emprestimos_screen.dart';
import 'treinamento_screen.dart';
import 'cadastrar_treinamento_screen.dart';

class MainScreen extends StatelessWidget {
  final Usuario usuario;
  final bool modoDemonstracao;
  const MainScreen({super.key,required this.usuario,this.modoDemonstracao=false});
  bool get admin=>usuario.perfil.toUpperCase()=='ADMIN';
  @override Widget build(BuildContext context){
    void abrir(Widget tela){Navigator.push(context,MaterialPageRoute(builder:(_)=>tela));}
    Widget opcao(IconData icon,String nome,VoidCallback acao)=>ListTile(leading:Icon(icon,color:const Color(0xFF087E8B)),title:Text(nome),trailing:const Icon(Icons.chevron_right),onTap:acao);
    Widget indicador(String titulo,String valor,IconData icon,Color cor)=>Card(child:Padding(padding:const EdgeInsets.all(18),child:Row(children:[CircleAvatar(backgroundColor:cor.withValues(alpha:.12),child:Icon(icon,color:cor)),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(titulo,style:const TextStyle(color:Colors.black54)),const SizedBox(height:6),Text(valor,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold))]))])));
    final opcoes=<Widget>[
      opcao(Icons.health_and_safety,'EPIs',()=>abrir(EpiScreen(usuario:usuario))),
      opcao(Icons.assignment_turned_in_outlined,'Meus empréstimos',()=>abrir(MeusEmprestimosScreen(usuario:usuario))),
      opcao(Icons.school_outlined,'Treinamentos',()=>abrir(TreinamentosScreen(usuario:usuario))),
      opcao(Icons.people_outline,'Funcionários',()=>abrir(const FuncionarioScreen())),
      if(admin)opcao(Icons.add_task,'Cadastrar treinamento',()=>abrir(CadastrarTreinamentoScreen(usuario:usuario))),
    ];
    return Scaffold(
      appBar:AppBar(backgroundColor:const Color(0xFF103B50),foregroundColor:Colors.white,title:const Text('Painel de Segurança do Trabalho'),actions:[IconButton(tooltip:'Sair',icon:const Icon(Icons.logout),onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginScreen()),(_)=>false))]),
      drawer:Drawer(child:SafeArea(child:ListView(children:[UserAccountsDrawerHeader(decoration:const BoxDecoration(color:Color(0xFF103B50)),accountName:Text(usuario.nome),accountEmail:Text('Perfil: ${usuario.perfil}'),currentAccountPicture:const CircleAvatar(child:Icon(Icons.person))),...opcoes]))),
      body:LayoutBuilder(builder:(context,limites)=>SingleChildScrollView(child:Center(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:1100),child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('Bem-vindo, ${usuario.nome}',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.bold)),
        const SizedBox(height:6),Text('Visão geral • ${usuario.perfil}',style:const TextStyle(color:Colors.black54)),
        if(modoDemonstracao)Container(margin:const EdgeInsets.only(top:16),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:const Color(0xFFFFF3DB),borderRadius:BorderRadius.circular(10)),child:const Row(children:[Icon(Icons.info_outline),SizedBox(width:8),Expanded(child:Text('Modo demonstração local. Os módulos originais consultam a API Java e precisam dela para listar ou gravar dados. Indicadores abaixo são ilustrativos.'))])),
        const SizedBox(height:22),const Text('Indicadores',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),
        const SizedBox(height:10),GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:limites.maxWidth>800?4:limites.maxWidth>480?2:1,childAspectRatio:limites.maxWidth>480?1.8:3.5,children:[
          indicador('EPIs cadastrados',modoDemonstracao?'—':'Consultar',Icons.health_and_safety,Colors.teal),
          indicador('Funcionários',modoDemonstracao?'—':'Consultar',Icons.people,Colors.blue),
          indicador('Empréstimos',modoDemonstracao?'—':'Consultar',Icons.assignment,Colors.orange),
          indicador('Treinamentos',modoDemonstracao?'—':'Consultar',Icons.school,Colors.purple),
        ]),const SizedBox(height:22),const Text('Acesso rápido',style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),
        Card(child:Column(children:opcoes)),const SizedBox(height:20),const Center(child:Text('Criação e desenvolvimento: S-Informática',style:TextStyle(color:Colors.black54,fontSize:12))),
      ])))))),
    );
  }
}
