# Whorl

A secure, 100% anonymous, peer-to-peer messenger with no central server and end-to-end encryption.

## Features
- Curve25519 + XChaCha20-Poly1305 encryption
- PIN lock with Argon2id
- Biometric authentication support
- Direct P2P communication (IP or Tor/.onion)
- File sharing (images, PDF, TXT)
- Internationalization (EN, PT, RU, ZH)
- Persistent preferences and theme
- Modern, responsive UX

## Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (3.10+)
- Android Studio or VSCode (with Flutter plugin)
- Android SDK (API 29+)
- **Java 11 or 17 LTS (non-Oracle recommended, e.g. [Temurin](https://adoptium.net/))**
- (Optional) Orbot/Tor for anonymous mode

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Whorlproject/Whorl.git
   cd whorl
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **(Recommended) Clean the project:**
   ```bash
   flutter clean
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```
   > Make sure your emulator or device is running and using Java 11 or 17 LTS (Temurin recommended).

## Building Release APK
```bash
flutter build apk --release
```
The APK will be in `build/app/outputs/flutter-apk/app-release.apk`.

## Main Features
- **Create your identity:** Follow the onboarding to set up your identity and PIN.
- **Add contacts:** Use the Session ID (public key) or .onion address of your contact.
- **Start a chat:** Tap a contact to start chatting.
- **Send files:** Tap the clip icon in the chat.
- **Tor mode:** Enable Orbot and set your contact's .onion address.
- **Settings:** Change language, theme, bubble color, wallpaper, and more.

## Security Tips
- Your PIN is protected by Argon2id and never stored in plain text.
- No data is sent to external servers.
- For maximum anonymity, use Tor/Orbot.
- Never share your Session ID publicly.

## Common Issues
- **PIN not requested:** Enable PIN lock in settings.
- **Tor not connecting:** Make sure Orbot is running and the .onion address is correct.
- **Contact not receiving messages:** The contact's app must be open and listening on the correct port.
- **Java errors:** Make sure you are using Java 11 or 17 LTS (Temurin recommended, not Oracle JDK).

## Contributing
Pull requests are welcome! Open an issue for suggestions or bugs.

## License
MIT 
