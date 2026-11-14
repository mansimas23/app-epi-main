import 'package:flutter/material.dart';
import '../services/local_demo_auth.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final matricula = TextEditingController();
  final senha = TextEditingController();
  bool carregando = false;
  bool usarApi = false;
  @override void dispose(){matricula.dispose();senha.dispose();super.dispose();}
  void aviso(String mensagem){if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(mensagem)));}
  Future<void> entrar() async {
    setState(()=>carregando=true);
    try {
      final usuario = usarApi ? await AuthService().login(matricula.text, senha.text) :
        (await LocalDemoAuth.entrar(matricula.text, senha.text) ? LocalDemoAuth.admin : null);
      if(!mounted)return;
      if(usuario == null){aviso('Matrícula ou senha inválidos');return;}
      Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>MainScreen(usuario:usuario, modoDemonstracao:!usarApi)));
    }catch(e){aviso('Não foi possível entrar: $e');}
    finally{if(mounted)setState(()=>carregando=false);}
  }
  Future<void> recuperar() async {
    final codigo = TextEditingController();final nova = TextEditingController();
    final ok = await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(
      title:const Text('Recuperar senha local'),
      content:Column(mainAxisSize:MainAxisSize.min,children:[
        const Text('Somente para demonstração. Informe a chave de recuperação fornecida no guia.'),
        const SizedBox(height:12),TextField(controller:codigo,decoration:const InputDecoration(labelText:'Chave de recuperação')),
        TextField(controller:nova,obscureText:true,decoration:const InputDecoration(labelText:'Nova senha (mínimo 6 caracteres)')),
      ]),actions:[TextButton(onPressed:()=>Navigator.pop(ctx,false),child:const Text('Cancelar')),
        FilledButton(onPressed:()async{final sucesso=await LocalDemoAuth.redefinir(codigo.text,nova.text);if(ctx.mounted)Navigator.pop(ctx,sucesso);},child:const Text('Redefinir'))]));
    codigo.dispose();nova.dispose();
    if(ok==true)aviso('Senha redefinida. Entre com a nova senha.');else if(ok==false)aviso('Recuperação cancelada ou chave inválida.');
  }
  @override Widget build(BuildContext context)=>Scaffold(
    body:Container(decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xFF0D2638),Color(0xFF17617A)],begin:Alignment.topLeft,end:Alignment.bottomRight)),
    child:Center(child:SingleChildScrollView(child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:440),child:Card(elevation:12,margin:const EdgeInsets.all(20),child:Padding(padding:const EdgeInsets.all(28),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      const Icon(Icons.health_and_safety,size:58,color:Color(0xFF087E8B)),
      const SizedBox(height:12),const Text('GESTÃO DE EPIs',textAlign:TextAlign.center,style:TextStyle(fontSize:27,fontWeight:FontWeight.w800)),
      const Text('Segurança do Trabalho • Acesso ao sistema',textAlign:TextAlign.center),
      const SizedBox(height:25),TextField(controller:matricula,decoration:const InputDecoration(labelText:'Matrícula',prefixIcon:Icon(Icons.badge_outlined),border:OutlineInputBorder())),
      const SizedBox(height:14),TextField(controller:senha,obscureText:true,onSubmitted:(_)=>entrar(),decoration:const InputDecoration(labelText:'Senha',prefixIcon:Icon(Icons.lock_outline),border:OutlineInputBorder())),
      const SizedBox(height:10),SwitchListTile(contentPadding:EdgeInsets.zero,title:const Text('Conectar à API Java (opcional)',style:TextStyle(fontSize:13)),value:usarApi,onChanged:(v)=>setState(()=>usarApi=v)),
      FilledButton.icon(onPressed:carregando?null:entrar,icon:const Icon(Icons.login),label:Text(carregando?'Entrando...':'Entrar')),
      TextButton(onPressed:usarApi?null:recuperar,child:const Text('Esqueci minha senha')),
      if(!usarApi)const Text('Teste local: 1001 / 123456',textAlign:TextAlign.center,style:TextStyle(color:Colors.black54,fontSize:12)),
      const Divider(height:30),const Text('Criação e desenvolvimento: S-Informática',textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:Colors.black54)),
    ]))))))));
}
