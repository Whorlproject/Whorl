// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Whorl';

  @override
  String get helpTitle => '帮助与入门';

  @override
  String get helpIntro => '欢迎使用安全信使！本应用完全匿名，点对点，端到端加密。';

  @override
  String get helpOrbotTitle => '如何与 Tor/Orbot 一起使用';

  @override
  String get helpOrbotStep1 => '1. 从 Play 商店或 F-Droid 安装 Orbot。';

  @override
  String get helpOrbotStep2 => '2. 打开 Orbot 并启动 Tor 服务。';

  @override
  String get helpOrbotStep3 => '3. 在安全信使中，启用 Tor 模式（右上角开关）。';

  @override
  String get helpOrbotStep4 => '4. 将您的 Session ID（.onion）分享给联系人。';

  @override
  String get helpOrbotStep5 => '5. 要接收消息，请保持 Orbot 和应用程序运行。';

  @override
  String get helpContactAdd => '通过 Session ID（公钥或 .onion 地址）添加联系人。';

  @override
  String get helpPin => '设置 PIN 以解锁应用。您的 PIN 永远不会以明文存储，并通过 Argon2id 保护。';

  @override
  String get helpSecurity => '所有消息均使用 Curve25519 + XChaCha20-Poly1305 加密。无元数据，无日志，无跟踪。';

  @override
  String get helpPermissions => '本应用默认不请求相机、麦克风、定位或联系人权限。';

  @override
  String get helpQr => '您可以通过二维码分享 Session ID，方便添加联系人。';

  @override
  String get helpLang => '您可以在设置中更改应用语言。';

  @override
  String get helpSupport => '如需支持，请访问我们的网站或通过 .onion 联系我们。';

  @override
  String get pinSetTitle => '设置 PIN';

  @override
  String get pinEnterTitle => '输入 PIN';

  @override
  String get pinError => 'PIN 错误，请重试。';

  @override
  String get pinForgot => '忘记 PIN？重置应用（所有数据将丢失）';

  @override
  String get contactAddTitle => '添加联系人';

  @override
  String get contactIdHint => '输入 Session ID 或 .onion 地址';

  @override
  String get contactAddButton => '添加';

  @override
  String get contactAdded => '联系人已添加！';

  @override
  String get contactInvalid => 'Session ID 无效。';

  @override
  String get securityLogsTitle => '安全日志';

  @override
  String get torStatusOn => 'Tor 模式已启用：所有流量通过 Tor/Orbot 路由，实现最大匿名性。';

  @override
  String get torStatusOff => 'Tor 模式已禁用：您的 IP 可能在本地网络中可见。';

  @override
  String get chatListTitle => '聊天列表';
  @override
  String get contactsTitle => '联系人';
  @override
  String get settingsTitle => '设置';
  @override
  String get themeColor => '主题颜色';
  @override
  String get themeColorDesc => '更改应用的主色调。';
  @override
  String get messageBubbleColor => '消息气泡颜色';
  @override
  String get messageBubbleColorDesc => '更改您的消息颜色。';

  @override
  String get logoutConfirmTitle => 'Logout and delete account?';

  @override
  String get logoutConfirmContent => 'This will erase all local data and return to the initial screen.';

  @override
  String get logoutConfirmButton => 'Delete and logout';

  @override
  String get unlockWithBiometrics => '使用生物识别解锁';

  @override
  String get reset => '重置';

  @override
  String get enterDisplayName => '请输入显示名称';

  @override
  String get pinMinLength => 'PIN 必须至少为 6 位数字';

  @override
  String get pinNoMatch => 'PIN 不匹配';

  @override
  String get setupFailed => '创建账户失败。请再试一次。';

  @override
  String errorOccurred(Object error) {
    return '发生错误: $error';
  }

  @override
  String get createIdentity => '创建您的身份';

  @override
  String get displayNamePinInfo => '您的显示名称和 PIN 将用于保护您的账户';

  @override
  String get displayName => '显示名称';

  @override
  String get enterDisplayNameHint => '输入您的显示名称';

  @override
  String get pinLabel => 'PIN（6+ 位数字）';

  @override
  String get enterPinHint => '输入您的 PIN';

  @override
  String get confirmPinLabel => '确认 PIN';

  @override
  String get reenterPinHint => '请再次输入您的 PIN';

  @override
  String get createAccount => '创建账户';

  @override
  String get securityNotice => '安全提示';

  @override
  String get pinSecurityInfo => '您的 PIN 用于加密您的本地数据。如果您忘记了 PIN，数据将无法恢复。';

  @override
  String get securitySettingsTitle => '安全设置';

  @override
  String get createOrChangePin => '创建/更改 PIN';

  @override
  String get groupsTitle => '群组';

  @override
  String get comingSoon => '即将推出';

  @override
  String get createGroupTitle => '创建群组';

  @override
  String get createIdentityTitle => '创建身份';

  @override
  String get getStarted => '开始';

  @override
  String get wipingData => '正在清除数据...';

  @override
  String get accountRemoved => '账户已成功移除。';

  @override
  String get errorWipingData => '清除数据时出错。请重试。';

  @override
  String get identityCreatedSuccessfully => '身份创建成功！';

  @override
  String get securityNoticeTitle => '安全提示';

  @override
  String get securityNoticeBody => '请妥善保管您的 PIN。遗失后无法恢复。';

  @override
  String get about => '关于';

  @override
  String get logout => '退出登录';

  @override
  String get noContacts => '还没有联系人。快去添加吧！';

  @override
  String get contactNotFound => '未找到联系人。';

  @override
  String get addressNotSet => '此联系人的连接地址未设置。请编辑联系人以添加 IP 或 .onion。';

  @override
  String get messageTooLong => '消息过长（最多 2000 个字符）';

  @override
  String get editContact => '编辑联系人';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get connectionAddressLabel => '连接地址（IP 或 .onion，可选）';

  @override
  String get fileAttachmentSoon => '文件附件功能即将推出！';

  @override
  String get securityLogs => '安全日志：';

  @override
  String selfDestructIn(Object SECONDS) {
    return '$SECONDS 秒后自毁';
  }

  @override
  String get identityTitle => '我的身份';

  @override
  String get copySessionId => '复制 Session ID';

  @override
  String get sessionIdCopied => 'Session ID 已复制！';

  @override
  String get chatWallpaper => '聊天壁纸';

  @override
  String get chooseWallpaper => '选择壁纸';

  @override
  String get wallpaperFeatureSoon => '图片选择功能即将推出。';

  @override
  String get wallpaper1 => '壁纸 1';

  @override
  String get wallpaper2 => '壁纸 2';

  @override
  String get remove => '移除';

  @override
  String get wallpaperSelected => '壁纸已选择';

  @override
  String get wallpaperDefault => '默认';

  @override
  String get darkMode => '深色模式';

  @override
  String get pinLock => '需要 PIN 才能打开应用';

  @override
  String get language => '中文';
}
