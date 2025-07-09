import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Messenger'**
  String get appTitle;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Onboarding'**
  String get helpTitle;

  /// No description provided for @helpIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Secure Messenger! This app is 100% anonymous, peer-to-peer, and end-to-end encrypted.'**
  String get helpIntro;

  /// No description provided for @helpOrbotTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use with Tor/Orbot'**
  String get helpOrbotTitle;

  /// No description provided for @helpOrbotStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Install Orbot from the Play Store or F-Droid.'**
  String get helpOrbotStep1;

  /// No description provided for @helpOrbotStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Open Orbot and start the Tor service.'**
  String get helpOrbotStep2;

  /// No description provided for @helpOrbotStep3.
  ///
  /// In en, this message translates to:
  /// **'3. In Secure Messenger, enable Tor mode (top right switch).'**
  String get helpOrbotStep3;

  /// No description provided for @helpOrbotStep4.
  ///
  /// In en, this message translates to:
  /// **'4. Share your Session ID (.onion) with your contacts.'**
  String get helpOrbotStep4;

  /// No description provided for @helpOrbotStep5.
  ///
  /// In en, this message translates to:
  /// **'5. To receive messages, keep Orbot and the app running.'**
  String get helpOrbotStep5;

  /// No description provided for @helpContactAdd.
  ///
  /// In en, this message translates to:
  /// **'Add contacts by their Session ID (public key or .onion address).'**
  String get helpContactAdd;

  /// No description provided for @helpPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN to unlock the app. Your PIN is never stored in plain text and is protected with Argon2id.'**
  String get helpPin;

  /// No description provided for @helpSecurity.
  ///
  /// In en, this message translates to:
  /// **'All messages are encrypted with Curve25519 + XChaCha20-Poly1305. No metadata, no logs, no tracking.'**
  String get helpSecurity;

  /// No description provided for @helpPermissions.
  ///
  /// In en, this message translates to:
  /// **'This app does NOT request camera, microphone, location, or contacts permissions by default.'**
  String get helpPermissions;

  /// No description provided for @helpQr.
  ///
  /// In en, this message translates to:
  /// **'You can share your Session ID via QR code for easy contact addition.'**
  String get helpQr;

  /// No description provided for @helpLang.
  ///
  /// In en, this message translates to:
  /// **'You can change the app language in settings.'**
  String get helpLang;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'For support, visit our website or contact us via .onion.'**
  String get helpSupport;

  /// No description provided for @pinSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get pinSetTitle;

  /// No description provided for @pinEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get pinEnterTitle;

  /// No description provided for @pinError.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Please try again.'**
  String get pinError;

  /// No description provided for @pinForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN? Reset app (all data will be lost)'**
  String get pinForgot;

  /// No description provided for @contactAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get contactAddTitle;

  /// No description provided for @contactIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Session ID or .onion address'**
  String get contactIdHint;

  /// No description provided for @contactAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get contactAddButton;

  /// No description provided for @contactAdded.
  ///
  /// In en, this message translates to:
  /// **'Contact added!'**
  String get contactAdded;

  /// No description provided for @contactInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid Session ID.'**
  String get contactInvalid;

  /// No description provided for @securityLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Logs'**
  String get securityLogsTitle;

  /// No description provided for @torStatusOn.
  ///
  /// In en, this message translates to:
  /// **'Tor mode enabled: all traffic is routed through Tor/Orbot for maximum anonymity.'**
  String get torStatusOn;

  /// No description provided for @torStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Tor mode disabled: your IP may be visible on the local network.'**
  String get torStatusOff;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet. Add one!'**
  String get noContacts;

  /// No description provided for @contactNotFound.
  ///
  /// In en, this message translates to:
  /// **'Contact not found.'**
  String get contactNotFound;

  /// No description provided for @addressNotSet.
  ///
  /// In en, this message translates to:
  /// **'Connection address not set for this contact. Edit the contact to add an IP or .onion.'**
  String get addressNotSet;

  /// No description provided for @messageTooLong.
  ///
  /// In en, this message translates to:
  /// **'Message too long (max 2000 characters)'**
  String get messageTooLong;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @connectionAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Connection address (IP or .onion, optional)'**
  String get connectionAddressLabel;

  /// No description provided for @fileAttachmentSoon.
  ///
  /// In en, this message translates to:
  /// **'File attachment - Coming soon!'**
  String get fileAttachmentSoon;

  /// No description provided for @securityLogs.
  ///
  /// In en, this message translates to:
  /// **'Security Logs:'**
  String get securityLogs;

  /// No description provided for @selfDestructIn.
  ///
  /// In en, this message translates to:
  /// **'Self-destructs in {SECONDS}s'**
  String selfDestructIn(Object SECONDS);

  /// No description provided for @identityTitle.
  ///
  /// In en, this message translates to:
  /// **'My Identity'**
  String get identityTitle;

  /// No description provided for @copySessionId.
  ///
  /// In en, this message translates to:
  /// **'Copy Session ID'**
  String get copySessionId;

  /// No description provided for @sessionIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Session ID copied!'**
  String get sessionIdCopied;

  /// No description provided for @chatWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Chat Wallpaper'**
  String get chatWallpaper;

  /// No description provided for @chooseWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Choose Wallpaper'**
  String get chooseWallpaper;

  /// No description provided for @wallpaperFeatureSoon.
  ///
  /// In en, this message translates to:
  /// **'Image selection feature coming soon.'**
  String get wallpaperFeatureSoon;

  /// No description provided for @wallpaper1.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper 1'**
  String get wallpaper1;

  /// No description provided for @wallpaper2.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper 2'**
  String get wallpaper2;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @wallpaperSelected.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper selected'**
  String get wallpaperSelected;

  /// No description provided for @wallpaperDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get wallpaperDefault;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @pinLock.
  ///
  /// In en, this message translates to:
  /// **'Require PIN to open app'**
  String get pinLock;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeColor;

  /// No description provided for @themeColorDesc.
  ///
  /// In en, this message translates to:
  /// **'Change the main color of the app.'**
  String get themeColorDesc;

  /// No description provided for @messageBubbleColor.
  ///
  /// In en, this message translates to:
  /// **'Message bubble color'**
  String get messageBubbleColor;

  /// No description provided for @messageBubbleColorDesc.
  ///
  /// In en, this message translates to:
  /// **'Change the color of your messages.'**
  String get messageBubbleColorDesc;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout and delete account?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'This will erase all local data and return to the initial screen.'**
  String get logoutConfirmContent;

  /// No description provided for @logoutConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete and logout'**
  String get logoutConfirmButton;

  /// No description provided for @unlockWithBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometrics'**
  String get unlockWithBiometrics;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @enterDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a display name'**
  String get enterDisplayName;

  /// No description provided for @pinMinLength.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 6 digits'**
  String get pinMinLength;

  /// No description provided for @pinNoMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinNoMatch;

  /// No description provided for @setupFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to setup account. Please try again.'**
  String get setupFailed;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @createIdentity.
  ///
  /// In en, this message translates to:
  /// **'Create Your Identity'**
  String get createIdentity;

  /// No description provided for @displayNamePinInfo.
  ///
  /// In en, this message translates to:
  /// **'Your display name and PIN will be used to secure your account'**
  String get displayNamePinInfo;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @enterDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your display name'**
  String get enterDisplayNameHint;

  /// No description provided for @pinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN (6+ digits)'**
  String get pinLabel;

  /// No description provided for @enterPinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterPinHint;

  /// No description provided for @confirmPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPinLabel;

  /// No description provided for @reenterPinHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your PIN'**
  String get reenterPinHint;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @securityNotice.
  ///
  /// In en, this message translates to:
  /// **'Security Notice'**
  String get securityNotice;

  /// No description provided for @pinSecurityInfo.
  ///
  /// In en, this message translates to:
  /// **'Your PIN is used to encrypt your local data. If you forget it, your data cannot be recovered.'**
  String get pinSecurityInfo;

  /// No description provided for @securitySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettingsTitle;

  /// No description provided for @createOrChangePin.
  ///
  /// In en, this message translates to:
  /// **'Create/Change PIN'**
  String get createOrChangePin;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsTitle;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @createGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroupTitle;

  /// No description provided for @createIdentityTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Identity'**
  String get createIdentityTitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @wipingData.
  ///
  /// In en, this message translates to:
  /// **'Wiping data...'**
  String get wipingData;

  /// No description provided for @accountRemoved.
  ///
  /// In en, this message translates to:
  /// **'Account removed successfully.'**
  String get accountRemoved;

  /// No description provided for @errorWipingData.
  ///
  /// In en, this message translates to:
  /// **'Error wiping data. Try again.'**
  String get errorWipingData;

  /// No description provided for @identityCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Identity created successfully!'**
  String get identityCreatedSuccessfully;

  /// No description provided for @securityNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Notice'**
  String get securityNoticeTitle;

  /// No description provided for @securityNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your PIN in a safe place. It cannot be recovered if lost.'**
  String get securityNoticeBody;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
