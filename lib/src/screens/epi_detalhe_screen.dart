import 'package:flutter/material.dart';
import '../models/epi.dart';
import '../models/usuario.dart';
import '../services/api_config.dart';
import '../services/emprestimo_service.dart';

class EpiDetalheScreen extends StatefulWidget {
  final Epi epi;
  final Usuario usuario;

  const EpiDetalheScreen({
    super.key,
    required this.epi,
    required this.usuario,
  });

  @override
  State<EpiDetalheScreen> createState() => _EpiDetalheScreenState();
}

class _EpiDetalheScreenState extends State<EpiDetalheScreen> {
  final formKey = GlobalKey<FormState>();
  final observacaoController = TextEditingController();
  bool carregando = false;

  @override
  void dispose() {
    observacaoController.dispose();
    super.dispose();
  }

  Future<void> solicitarEmprestimo() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      carregando = true;
    });

    try {
      await EmprestimoService().solicitar(
        funcionarioId: widget.usuario.id,
        epiId: widget.epi.id,
        observacao: observacaoController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitação enviada! Aguarde a aprovação.'),
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
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final epi = widget.epi;
    final podeSolicitar = !epi.caVencido && epi.quantidadeDisponivel > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do EPI'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '${ApiConfig.baseUrl}${epi.imagemUrl}',
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.blue.shade50,
                      child: const Icon(
                        Icons.health_and_safety,
                        size: 80,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                epi.nome,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                epi.categoria,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Divider(height: 30),
              linhaInfo(Icons.verified, 'CA', epi.ca),
              linhaInfo(
                Icons.event,
                'Validade do CA',
                epi.validadeFormatada,
                cor: epi.caVencido ? Colors.red : null,
              ),
              linhaInfo(
                Icons.inventory_2,
                'Disponível',
                '${epi.quantidadeDisponivel} un.',
              ),
              const Divider(height: 30),
              Text(
                'Solicitante: ${widget.usuario.nome} (matrícula ${widget.usuario.matricula})',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: observacaoController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: 'Motivo da classificação',
                  hintText: 'Ex.: capacete atual está trincado',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o motivo da solicitação';
                  }
                  if (valor.trim().length < 5) {
                    return 'Escreva pelo menos 5 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              if (!podeSolicitar)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    epi.caVencido
                        ? 'CA vencido: este EPI não pode ser emprestado.'
                        : 'EPI sem estoque no momento.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: (carregando || !podeSolicitar)
                      ? null
                      : () {
                          // Requisito 2: AlertDialog de confirmação antes de enviar
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmar Solicitação'),
                                content: Text('Confirma a solicitação de "${epi.nome}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      solicitarEmprestimo();
                                    },
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  icon: carregando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: const Text('Solicitar Empréstimo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget linhaInfo(IconData icone, String rotulo, String valor, {Color? cor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, color: cor ?? Colors.blue),
          const SizedBox(width: 10),
          Text(
            '$rotulo: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(valor, style: TextStyle(color: cor)),
          ),
        ],
      ),
    );
  }
}
