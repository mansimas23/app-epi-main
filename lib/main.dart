import 'package:flutter/material.dart';
import 'src/screens/login_screen.dart';
void main()=>runApp(const EpiApp());
class EpiApp extends StatelessWidget {
 const EpiApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(
   title:'Gestão de EPIs • S-Informática',debugShowCheckedModeBanner:false,
   theme:ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF087E8B)),scaffoldBackgroundColor:const Color(0xFFF4F7F9)),
   home:const LoginScreen());
}
