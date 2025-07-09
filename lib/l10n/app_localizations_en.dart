// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Whorl';

  @override
  String get helpTitle => 'Help & Onboarding';

  @override
  String get helpIntro => 'Welcome to Secure Messenger! This app is 100% anonymous, peer-to-peer, and end-to-end encrypted.';

  @override
  String get helpOrbotTitle => 'How to use with Tor/Orbot';

  @override
  String get helpOrbotStep1 => '1. Install Orbot from the Play Store or F-Droid.';

  @override
  String get helpOrbotStep2 => '2. Open Orbot and start the Tor service.';

  @override
  String get helpOrbotStep3 => '3. In Secure Messenger, enable Tor mode (top right switch).';

  @override
  String get helpOrbotStep4 => '4. Share your Session ID (.onion) with your contacts.';

  @override
  String get helpOrbotStep5 => '5. To receive messages, keep Orbot and the app running.';

  @override
  String get helpContactAdd => 'Add contacts by their Session ID (public key or .onion address).';

  @override
  String get helpPin => 'Set a PIN to unlock the app. Your PIN is never stored in plain text and is protected with Argon2id.';

  @override
  String get helpSecurity => 'All messages are encrypted with Curve25519 + XChaCha20-Poly1305. No metadata, no logs, no tracking.';

  @override
  String get helpPermissions => 'This app does NOT request camera, microphone, location, or contacts permissions by default.';

  @override
  String get helpQr => 'You can share your Session ID via QR code for easy contact addition.';

  @override
  String get helpLang => 'You can change the app language in settings.';

  @override
  String get helpSupport => 'For support, visit our website or contact us via .onion.';

  @override
  String get pinSetTitle => 'Set PIN';

  @override
  String get pinEnterTitle => 'Enter PIN';

  @override
  String get pinError => 'Incorrect PIN. Please try again.';

  @override
  String get pinForgot => 'Forgot PIN? Reset app (all data will be lost)';

  @override
  String get contactAddTitle => 'Add Contact';

  @override
  String get contactIdHint => 'Enter Session ID or .onion address';

  @override
  String get contactAddButton => 'Add';

  @override
  String get contactAdded => 'Contact added!';

  @override
  String get contactInvalid => 'Invalid Session ID.';

  @override
  String get securityLogsTitle => 'Security Logs';

  @override
  String get torStatusOn => 'Tor mode enabled: all traffic is routed through Tor/Orbot for maximum anonymity.';

  @override
  String get torStatusOff => 'Tor mode disabled: your IP may be visible on the local network.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get logout => 'Logout';

  @override
  String get noContacts => 'No contacts yet. Add one!';

  @override
  String get contactNotFound => 'Contact not found.';

  @override
  String get addressNotSet => 'Connection address not set for this contact. Edit the contact to add an IP or .onion.';

  @override
  String get messageTooLong => 'Message too long (max 2000 characters)';

  @override
  String get editContact => 'Edit Contact';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get connectionAddressLabel => 'Connection address (IP or .onion, optional)';

  @override
  String get fileAttachmentSoon => 'File attachment - Coming soon!';

  @override
  String get securityLogs => 'Security Logs:';

  @override
  String selfDestructIn(Object SECONDS) {
    return 'Self-destructs in ${SECONDS}s';
  }

  @override
  String get identityTitle => 'My Identity';

  @override
  String get copySessionId => 'Copy Session ID';

  @override
  String get sessionIdCopied => 'Session ID copied!';

  @override
  String get chatWallpaper => 'Chat Wallpaper';

  @override
  String get chooseWallpaper => 'Choose Wallpaper';

  @override
  String get wallpaperFeatureSoon => 'Image selection feature coming soon.';

  @override
  String get wallpaper1 => 'Wallpaper 1';

  @override
  String get wallpaper2 => 'Wallpaper 2';

  @override
  String get remove => 'Remove';

  @override
  String get wallpaperSelected => 'Wallpaper selected';

  @override
  String get wallpaperDefault => 'Default';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get pinLock => 'Require PIN to open app';

  @override
  String get themeColor => 'Theme color';

  @override
  String get themeColorDesc => 'Change the main color of the app.';

  @override
  String get messageBubbleColor => 'Message bubble color';

  @override
  String get messageBubbleColorDesc => 'Change the color of your messages.';

  @override
  String get logoutConfirmTitle => 'Logout and delete account?';

  @override
  String get logoutConfirmContent => 'This will erase all local data and return to the initial screen.';

  @override
  String get logoutConfirmButton => 'Delete and logout';

  @override
  String get unlockWithBiometrics => 'Unlock with biometrics';

  @override
  String get reset => 'Reset';

  @override
  String get enterDisplayName => 'Please enter a display name';

  @override
  String get pinMinLength => 'PIN must be at least 6 digits';

  @override
  String get pinNoMatch => 'PINs do not match';

  @override
  String get setupFailed => 'Failed to setup account. Please try again.';

  @override
  String errorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get createIdentity => 'Create Your Identity';

  @override
  String get displayNamePinInfo => 'Your display name and PIN will be used to secure your account';

  @override
  String get displayName => 'Display Name';

  @override
  String get enterDisplayNameHint => 'Enter your display name';

  @override
  String get pinLabel => 'PIN (6+ digits)';

  @override
  String get enterPinHint => 'Enter your PIN';

  @override
  String get confirmPinLabel => 'Confirm PIN';

  @override
  String get reenterPinHint => 'Re-enter your PIN';

  @override
  String get createAccount => 'Create Account';

  @override
  String get securityNotice => 'Security Notice';

  @override
  String get pinSecurityInfo => 'Your PIN is used to encrypt your local data. If you forget it, your data cannot be recovered.';

  @override
  String get securitySettingsTitle => 'Security Settings';

  @override
  String get createOrChangePin => 'Create/Change PIN';

  @override
  String get groupsTitle => 'Groups';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get createGroupTitle => 'Create Group';

  @override
  String get createIdentityTitle => 'Create Identity';

  @override
  String get getStarted => 'Get Started';

  @override
  String get wipingData => 'Wiping data...';

  @override
  String get accountRemoved => 'Account removed successfully.';

  @override
  String get errorWipingData => 'Error wiping data. Try again.';

  @override
  String get identityCreatedSuccessfully => 'Identity created successfully!';

  @override
  String get securityNoticeTitle => 'Security Notice';

  @override
  String get securityNoticeBody => 'Keep your PIN in a safe place. It cannot be recovered if lost.';
}
