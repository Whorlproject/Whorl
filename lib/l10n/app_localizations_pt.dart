// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Whorl';

  @override
  String get helpTitle => 'Ajuda & Onboarding';

  @override
  String get helpIntro => 'Bem-vindo ao Mensageiro Seguro! Este app é 100% anônimo, peer-to-peer e com criptografia de ponta a ponta.';

  @override
  String get helpOrbotTitle => 'Como usar com Tor/Orbot';

  @override
  String get helpOrbotStep1 => '1. Instale o Orbot pela Play Store ou F-Droid.';

  @override
  String get helpOrbotStep2 => '2. Abra o Orbot e inicie o serviço Tor.';

  @override
  String get helpOrbotStep3 => '3. No Mensageiro Seguro, ative o modo Tor (chave no topo direito).';

  @override
  String get helpOrbotStep4 => '4. Compartilhe seu Session ID (.onion) com seus contatos.';

  @override
  String get helpOrbotStep5 => '5. Para receber mensagens, mantenha o Orbot e o app abertos.';

  @override
  String get helpContactAdd => 'Adicione contatos pelo Session ID (chave pública ou endereço .onion).';

  @override
  String get helpPin => 'Defina um PIN para desbloquear o app. Seu PIN nunca é salvo em texto claro e é protegido com Argon2id.';

  @override
  String get helpSecurity => 'Todas as mensagens são criptografadas com Curve25519 + XChaCha20-Poly1305. Sem metadados, sem logs, sem rastreamento.';

  @override
  String get helpPermissions => 'Este app NÃO solicita permissões de câmera, microfone, localização ou contatos por padrão.';

  @override
  String get helpQr => 'Você pode compartilhar seu Session ID via QR code para facilitar a adição de contatos.';

  @override
  String get helpLang => 'Você pode mudar o idioma do app nas configurações.';

  @override
  String get helpSupport => 'Para suporte, visite nosso site ou entre em contato via .onion.';

  @override
  String get pinSetTitle => 'Definir PIN';

  @override
  String get pinEnterTitle => 'Digite o PIN';

  @override
  String get pinError => 'PIN incorreto. Tente novamente.';

  @override
  String get pinForgot => 'Esqueceu o PIN? Redefina o app (todos os dados serão perdidos)';

  @override
  String get contactAddTitle => 'Adicionar Contato';

  @override
  String get contactIdHint => 'Digite o Session ID ou endereço .onion';

  @override
  String get contactAddButton => 'Adicionar';

  @override
  String get contactAdded => 'Contato adicionado!';

  @override
  String get contactInvalid => 'Session ID inválido.';

  @override
  String get securityLogsTitle => 'Logs de Segurança';

  @override
  String get torStatusOn => 'Modo Tor ativado: todo o tráfego passa pela rede Tor/Orbot para anonimato máximo.';

  @override
  String get torStatusOff => 'Modo Tor desativado: seu IP pode ser visível na rede local.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get about => 'Sobre';

  @override
  String get logout => 'Sair';

  @override
  String get noContacts => 'Nenhum contato ainda. Adicione um!';

  @override
  String get contactNotFound => 'Contato não encontrado.';

  @override
  String get addressNotSet => 'Endereço de conexão não definido para este contato. Edite o contato para adicionar um IP ou .onion.';

  @override
  String get messageTooLong => 'Mensagem muito longa (máx. 2000 caracteres)';

  @override
  String get editContact => 'Editar Contato';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get connectionAddressLabel => 'Endereço de conexão (IP ou .onion, opcional)';

  @override
  String get fileAttachmentSoon => 'Anexo de arquivo - Em breve!';

  @override
  String get securityLogs => 'Logs de Segurança:';

  @override
  String selfDestructIn(Object SECONDS) {
    return 'Autodestrói em ${SECONDS}s';
  }

  @override
  String get identityTitle => 'Minha Identidade';

  @override
  String get copySessionId => 'Copiar Session ID';

  @override
  String get sessionIdCopied => 'Session ID copiado!';

  @override
  String get chatWallpaper => 'Wallpaper do Chat';

  @override
  String get chooseWallpaper => 'Escolher Wallpaper';

  @override
  String get wallpaperFeatureSoon => 'Funcionalidade de seleção de imagem em breve.';

  @override
  String get wallpaper1 => 'Wallpaper 1';

  @override
  String get wallpaper2 => 'Wallpaper 2';

  @override
  String get remove => 'Remover';

  @override
  String get wallpaperSelected => 'Wallpaper selecionado';

  @override
  String get wallpaperDefault => 'Padrão';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get pinLock => 'Exigir PIN para abrir o app';

  @override
  String get themeColor => 'Cor do tema';

  @override
  String get themeColorDesc => 'Altere a cor principal do app.';

  @override
  String get messageBubbleColor => 'Cor das mensagens';

  @override
  String get messageBubbleColorDesc => 'Altere a cor das suas mensagens.';

  @override
  String get logoutConfirmTitle => 'Sair e apagar conta?';

  @override
  String get logoutConfirmContent => 'Isso irá apagar todos os dados locais e voltar para a tela inicial.';

  @override
  String get logoutConfirmButton => 'Apagar e sair';

  @override
  String get unlockWithBiometrics => 'Desbloquear com biometria';

  @override
  String get reset => 'Redefinir';

  @override
  String get enterDisplayName => 'Por favor, insira um nome de exibição';

  @override
  String get pinMinLength => 'O PIN deve ter pelo menos 6 dígitos';

  @override
  String get pinNoMatch => 'Os PINs não coincidem';

  @override
  String get setupFailed => 'Falha ao configurar a conta. Tente novamente.';

  @override
  String errorOccurred(Object error) {
    return 'Ocorreu um erro: $error';
  }

  @override
  String get createIdentity => 'Crie sua Identidade';

  @override
  String get displayNamePinInfo => 'Seu nome de exibição e PIN serão usados para proteger sua conta';

  @override
  String get displayName => 'Nome de exibição';

  @override
  String get enterDisplayNameHint => 'Digite seu nome de exibição';

  @override
  String get pinLabel => 'PIN (6+ dígitos)';

  @override
  String get enterPinHint => 'Digite seu PIN';

  @override
  String get confirmPinLabel => 'Confirmar PIN';

  @override
  String get reenterPinHint => 'Redigite seu PIN';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get securityNotice => 'Aviso de Segurança';

  @override
  String get pinSecurityInfo => 'Seu PIN é usado para criptografar seus dados locais. Se você esquecê-lo, seus dados não poderão ser recuperados.';

  @override
  String get securitySettingsTitle => 'Configurações de Segurança';

  @override
  String get createOrChangePin => 'Criar/Alterar PIN';

  @override
  String get groupsTitle => 'Grupos';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get createGroupTitle => 'Criar Grupo';

  @override
  String get createIdentityTitle => 'Criar Identidade';

  @override
  String get getStarted => 'Começar a usar';

  @override
  String get wipingData => 'Apagando dados...';

  @override
  String get accountRemoved => 'Conta removida com sucesso.';

  @override
  String get errorWipingData => 'Erro ao apagar dados. Tente novamente.';

  @override
  String get identityCreatedSuccessfully => 'Identidade criada com sucesso!';

  @override
  String get securityNoticeTitle => 'Aviso de Segurança';

  @override
  String get securityNoticeBody => 'Guarde seu PIN em local seguro. Ele não pode ser recuperado se perdido.';
}
