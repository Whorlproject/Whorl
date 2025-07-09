// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Whorl';

  @override
  String get helpTitle => 'Помощь и Введение';

  @override
  String get helpIntro => 'Добро пожаловать в Безопасный Мессенджер! Это приложение полностью анонимно, P2P и с сквозным шифрованием.';

  @override
  String get helpOrbotTitle => 'Как использовать с Tor/Orbot';

  @override
  String get helpOrbotStep1 => '1. Установите Orbot из Play Store или F-Droid.';

  @override
  String get helpOrbotStep2 => '2. Откройте Orbot и запустите Tor.';

  @override
  String get helpOrbotStep3 => '3. В Безопасном Мессенджере включите режим Tor (переключатель вверху справа).';

  @override
  String get helpOrbotStep4 => '4. Поделитесь своим Session ID (.onion) с контактами.';

  @override
  String get helpOrbotStep5 => '5. Для получения сообщений держите Orbot и приложение открытыми.';

  @override
  String get helpContactAdd => 'Добавляйте контакты по Session ID (публичный ключ или .onion адрес).';

  @override
  String get helpPin => 'Установите PIN для разблокировки приложения. Ваш PIN никогда не хранится в открытом виде и защищён с помощью Argon2id.';

  @override
  String get helpSecurity => 'Все сообщения шифруются Curve25519 + XChaCha20-Poly1305. Нет метаданных, нет логов, нет отслеживания.';

  @override
  String get helpPermissions => 'Это приложение НЕ запрашивает доступ к камере, микрофону, геолокации или контактам по умолчанию.';

  @override
  String get helpQr => 'Вы можете поделиться своим Session ID через QR-код для удобного добавления контактов.';

  @override
  String get helpLang => 'Вы можете изменить язык приложения в настройках.';

  @override
  String get helpSupport => 'Для поддержки посетите наш сайт или свяжитесь с нами через .onion.';

  @override
  String get pinSetTitle => 'Установить PIN';

  @override
  String get pinEnterTitle => 'Введите PIN';

  @override
  String get pinError => 'Неверный PIN. Попробуйте снова.';

  @override
  String get pinForgot => 'Забыли PIN? Сбросьте приложение (все данные будут удалены)';

  @override
  String get contactAddTitle => 'Добавить контакт';

  @override
  String get contactIdHint => 'Введите Session ID или .onion адрес';

  @override
  String get contactAddButton => 'Добавить';

  @override
  String get contactAdded => 'Контакт добавлен!';

  @override
  String get contactInvalid => 'Неверный Session ID.';

  @override
  String get securityLogsTitle => 'Журнал безопасности';

  @override
  String get torStatusOn => 'Режим Tor включён: весь трафик проходит через Tor/Orbot для максимальной анонимности.';

  @override
  String get torStatusOff => 'Режим Tor выключен: ваш IP может быть виден в локальной сети.';

  @override
  String get chatListTitle => 'Список чатов';
  @override
  String get contactsTitle => 'Контакты';
  @override
  String get settingsTitle => 'Настройки';
  @override
  String get themeColor => 'Цвет темы';
  @override
  String get themeColorDesc => 'Изменить основной цвет приложения.';
  @override
  String get messageBubbleColor => 'Цвет пузыря сообщения';
  @override
  String get messageBubbleColorDesc => 'Изменить цвет ваших сообщений.';

  @override
  String get logoutConfirmTitle => 'Logout and delete account?';

  @override
  String get logoutConfirmContent => 'This will erase all local data and return to the initial screen.';

  @override
  String get logoutConfirmButton => 'Delete and logout';

  @override
  String get unlockWithBiometrics => 'Unlock with biometrics';

  @override
  String get reset => 'Сбросить';

  @override
  String get enterDisplayName => 'Пожалуйста, введите отображаемое имя';

  @override
  String get pinMinLength => 'PIN должен содержать не менее 6 цифр';

  @override
  String get pinNoMatch => 'PIN-коды не совпадают';

  @override
  String get setupFailed => 'Не удалось создать аккаунт. Пожалуйста, попробуйте снова.';

  @override
  String errorOccurred(Object error) {
    return 'Произошла ошибка: $error';
  }

  @override
  String get createIdentity => 'Создайте свою личность';

  @override
  String get displayNamePinInfo => 'Ваше отображаемое имя и PIN будут использоваться для защиты вашей учетной записи';

  @override
  String get displayName => 'Отображаемое имя';

  @override
  String get enterDisplayNameHint => 'Введите ваше отображаемое имя';

  @override
  String get pinLabel => 'PIN (6+ цифр)';

  @override
  String get enterPinHint => 'Введите ваш PIN';

  @override
  String get confirmPinLabel => 'Подтвердите PIN';

  @override
  String get reenterPinHint => 'Введите ваш PIN еще раз';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get securityNotice => 'Уведомление о безопасности';

  @override
  String get pinSecurityInfo => 'Ваш PIN используется для шифрования ваших локальных данных. Если вы его забудете, данные не могут быть восстановлены.';

  @override
  String get securitySettingsTitle => 'Настройки безопасности';

  @override
  String get createOrChangePin => 'Создать/Изменить PIN';

  @override
  String get groupsTitle => 'Группы';

  @override
  String get comingSoon => 'Скоро будет';

  @override
  String get createGroupTitle => 'Создать группу';

  @override
  String get createIdentityTitle => 'Создать личность';

  @override
  String get getStarted => 'Начать';

  @override
  String get wipingData => 'Удаление данных...';

  @override
  String get accountRemoved => 'Аккаунт успешно удалён.';

  @override
  String get errorWipingData => 'Ошибка при удалении данных. Попробуйте снова.';

  @override
  String get identityCreatedSuccessfully => 'Личность успешно создана!';

  @override
  String get securityNoticeTitle => 'Уведомление о безопасности';

  @override
  String get securityNoticeBody => 'Держите ваш PIN в безопасном месте. Если он будет утерян, восстановить его невозможно.';

  @override
  String get about => 'О приложении';

  @override
  String get logout => 'Выйти';

  @override
  String get noContacts => 'Пока нет контактов. Добавьте!';

  @override
  String get contactNotFound => 'Контакт не найден.';

  @override
  String get addressNotSet => 'Адрес подключения не установлен для этого контакта. Отредактируйте контакт, чтобы добавить IP или .onion.';

  @override
  String get messageTooLong => 'Сообщение слишком длинное (макс. 2000 символов)';

  @override
  String get editContact => 'Редактировать контакт';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get connectionAddressLabel => 'Адрес подключения (IP или .onion, опционально)';

  @override
  String get fileAttachmentSoon => 'Вложение файлов — скоро!';

  @override
  String get securityLogs => 'Журнал безопасности:';

  @override
  String selfDestructIn(Object SECONDS) {
    return 'Самоуничтожение через $SECONDS с';
  }

  @override
  String get identityTitle => 'Моя личность';

  @override
  String get copySessionId => 'Скопировать Session ID';

  @override
  String get sessionIdCopied => 'Session ID скопирован!';

  @override
  String get chatWallpaper => 'Обои чата';

  @override
  String get chooseWallpaper => 'Выбрать обои';

  @override
  String get wallpaperFeatureSoon => 'Функция выбора изображения скоро появится.';

  @override
  String get wallpaper1 => 'Обои 1';

  @override
  String get wallpaper2 => 'Обои 2';

  @override
  String get remove => 'Удалить';

  @override
  String get wallpaperSelected => 'Обои выбраны';

  @override
  String get wallpaperDefault => 'По умолчанию';

  @override
  String get darkMode => 'Тёмный режим';

  @override
  String get pinLock => 'Требовать PIN для входа';

  @override
  String get language => 'Русский';
}
