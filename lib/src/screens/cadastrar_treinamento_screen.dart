import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/usuario.dart';
import '../services/treinamento_service.dart';

class CadastrarTreinamentoScreen extends StatefulWidget {
  final Usuario usuario;

  const CadastrarTreinamentoScreen({super.key, required this.usuario});

  @override
  State<CadastrarTreinamentoScreen> createState() =>
      _CadastrarTreinamentoScreenState();
}

class _CadastrarTreinamentoScreenState
    extends State<CadastrarTreinamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _arquivoController = TextEditingController();
  final _validadeController = TextEditingController();

  Uint8List? _arquivoBytes;
  String? _nomeArquivo;
  bool _salvando = false;

     Future<void> _selecionarArquivo() async {
    final PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'mp4'],
    );

    if (file != null) {
      // Lê os bytes do arquivo de forma assíncrona (padrão do file_picker v13+)
      final Uint8List bytes = await file.readAsBytes();

      setState(() {
        _arquivoBytes = bytes;
        _nomeArquivo = file.name;
        _arquivoController.text = _nomeArquivo!;
      });
    }
  }



  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate())return;
    setState(() => _salvando = true);

    try {
      final validadeText = _validadeController.text;
      final int? validadeMeses =  
          validadeText.isNotEmpty ? int.tryParse(validadeText) : null;

      await TreinamentoService().cadastrar(
        titulo: _tituloController.text,
        descricao: _descricaoController.text.isEmpty
            ? null
            : _descricaoController.text,
        arquivoBytes: _arquivoBytes,
        nomeArquivo: _nomeArquivo,
        validadeMeses: validadeMeses,
        adminId: widget.usuario.id,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treinamento cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _arquivoController.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Treinamento'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título (Obrigatório) *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe o título do treinamento'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arquivoController,
                readOnly: true,
                onTap: _selecionarArquivo,
                decoration: InputDecoration(
                  labelText: 'Anexar Arquivo (PDF, Vídeo, etc.)',
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_arquivoBytes != null)
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _arquivoBytes = null;
                              _nomeArquivo = null;
                              _arquivoController.clear();
                            });
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.upload_file),
                        onPressed: _selecionarArquivo,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _validadeController,
                decoration: const InputDecoration(
                  labelText: 'Validade em Meses (Opcional - Desafio Extra)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              _salvando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _salvar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Salvar Treinamento',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
