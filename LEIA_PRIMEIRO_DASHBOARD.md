# Dashboard integrado ao Flutter

O painel agora faz parte de `lib/src/screens/main_screen.dart` e é aberto após login a partir de `lib/main.dart`.

## Executar no VS Code ou IntelliJ (Windows 11)

1. Abra a pasta `app-epi-main` como projeto Flutter.
2. Tenha Flutter SDK instalado e configurado no editor.
3. Execute `flutter pub get` (necessário após inclusão de `shared_preferences`).
4. Execute `flutter run -d chrome` ou clique Run em `lib/main.dart`.
5. Login demonstrativo: matrícula `1001`, senha `123456`.

### Recuperação de senha demonstrativa

Clique em **Esqueci minha senha**, use a chave `EPI-DEMO-2026` e escolha nova senha (mínimo 6 caracteres). A senha é salva localmente no dispositivo via `shared_preferences`. **Não use em produção**: a chave é pública no código e não fornece autenticação segura.

### API Java

O projeto Java foi preservado. O modo local mostra o dashboard sem servidor, mas as telas originais de EPIs, funcionários, empréstimos e treinamentos ainda exigem a API Java. Para autenticar na API, ative `Conectar à API Java` no login. A recuperação local não altera senhas do banco Java.

### Limitações

Não há dados reais nos indicadores sem API; não há controle hierárquico seguro offline; não foram executados testes Flutter neste ambiente (SDK indisponível).
