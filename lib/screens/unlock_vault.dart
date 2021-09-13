import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
// import 'package:safe_cryto/encryption.dart';
import './unlocked_home.dart';
import 'dart:ui';
import './create_new_vault.dart';
// import './how_it_works.dart';
import '../encryption.dart';
import 'dart:convert';
import 'package:gradient_text/gradient_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:advanced_icon/advanced_icon.dart';
import './home.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class UnlockVault extends StatefulWidget {
  const UnlockVault({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<UnlockVault> createState() => _UnlockVaultState();
}

class _UnlockVaultState extends State<UnlockVault> {
  final password = TextEditingController();
  String decryptedVault = '';
  String encryptedVault = '';

  String? _fileName = 'Please select your vault !';
  List<PlatformFile>? _paths;
  String? _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.any;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background_home_no_logo.png"), fit: BoxFit.cover),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            // appLogo(),
            homeTitle(),
            browseButton(),
            vaultName(),
            passwordField(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              cancelButton(),
              unlockButton(),
            ]),
            Container(
              width: 200.0,
              color: Colors.transparent,
            ),
            // createNewVault(),
          ]))
    ]));
  }

  Padding homeTitle() {
    return (Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: GradientText("UNLOCK VAULT",
          gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          style: GoogleFonts.poppins(fontSize: 80.0, color: Color(0xffffffff), fontWeight: FontWeight.w700),
          textAlign: TextAlign.center),
    ));
  }

  Padding browseButton() {
    AdvancedIconState _state = AdvancedIconState.primary;

    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: SizedBox(
        child: IconButton(
          // color: Colors.amber,
          hoverColor: Colors.black,
          icon: const Icon(
            Icons.lock_outline_rounded,
            color: Colors.white,
          ),
          iconSize: 300,
          onPressed: () {
            openFinder();
            showFloatingFlushbar(context, "Please select your vault");
          },
        ),
      ),
    ));
  }

  Padding vaultName() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: Text(
        _fileName!,
        style: GoogleFonts.poppins(fontSize: 26.0, color: Color(0xffffffff), fontWeight: FontWeight.w500),
      ),
    ));
  }

  Padding passwordField() {
    return (Padding(
      padding: const EdgeInsetsDirectional.all(10),
      child: SizedBox(
        child: SizedBox(
          width: 440,
          height: 80,
          child: Stack(children: <Widget>[
            Positioned(
              bottom: 10,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(80),
                      blurRadius: 10.0,
                      spreadRadius: 3.0,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: <Color>[Colors.blue.withOpacity(1), Colors.cyan.withOpacity(1), Colors.purple.withOpacity(1)],
                  ),
                  // gradient: LinearGradient(
                  //   colors: List.generate(360, (h) => HSLColor.fromAHSL(1, h.toDouble(), 1, 0.7).toColor()),
                  // ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                height: 70,
                width: 440,
              ),
            ),
            Positioned(
              bottom: 13,
              left: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF18163d),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                height: 64,
                width: 434,
              ),
            ),
            TextFormField(
              autofocus: true,
              obscureText: true,
              cursorColor: Colors.white,
              textAlign: TextAlign.center,
              controller: password,

              // style: const TextStyle(fontSize: 44.0, color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
              style: GoogleFonts.poppins(fontSize: 40.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700),

              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ]),
        ),
      ),
    ));
  }

  Padding cancelButton() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          Navigator.pop(context);
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text("    CANCEL    ", style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
        gradient: LinearGradient(
          colors: <Color>[Colors.blue.withOpacity(1), Colors.cyan.withOpacity(1), Colors.purple.withOpacity(1)],
        ),
        strokeWidth: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: const Radius.circular(4),
      ),
    ));
  }

  Padding unlockButton() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          if (_fileName == 'Please select your vault !') {
            showFloatingFlushbar(context, "Please select a vault to unlock !");
            return;
          } else if (password.text.isEmpty) {
            showFloatingFlushbar(context, "Empty password field !");
            return;
          }

          encryptedVault = readFile(_fileName.toString());
          decryptedVault = decrypt(password.text, encryptedVault);

          if (decryptedVault == 'INVALID_VAULT') {
            showFloatingFlushbar(context, "Invalid vault file specified !");
            return;
          } else if (decryptedVault == 'WRONG_PASSWORD') {
            showFloatingFlushbar(context, "Wrong password !");
            return;
          } else if (decryptedVault != '') {
            // Load decrypted vault
            var listWallets = loadWallets(decryptedVault);
            // Login to the Vault
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UnlockedHomePage(
                        wallets: listWallets,
                        fileName: _fileName.toString(),
                        password: password,
                      )),
            );
          } else {
            showFloatingFlushbar(context, "Unknown error !");
            return;
          }
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text("   UNLOCK   ", style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
        gradient: LinearGradient(
          colors: <Color>[Colors.blue.withOpacity(1), Colors.cyan.withOpacity(1), Colors.purple.withOpacity(1)],
        ),
        strokeWidth: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: const Radius.circular(4),
      ),
    ));
  }

  Padding createNewVault() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: TextButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const CreateNewVaultPage(title: '')),
            // );
          },
          style: defaultButtonStyle(),
          child: const Text(
            "Create a new Vault",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
          )),
    ));
  }

  Text version() {
    return (const Text(
      "v1.0.0",
      style: TextStyle(fontSize: 15.0, color: Color(0xFFE2A400), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
    ));
  }

  TextButton howItWorks() {
    return (TextButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const HowItWorksPage(title: '')),
          // );
        },
        child: const Text(
          "How it works!",
          style: TextStyle(fontSize: 15.0, color: Color(0xFFE2A400), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
        )));
  }

  ButtonStyle defaultButtonStyle() {
    return (ButtonStyle(
        shadowColor: MaterialStateProperty.all(Colors.amber),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ))));
  }

  void openFinder() async {
    setState(() => _loadingPath = true);
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '').split(',') : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _paths != null ? _paths!.map((e) => e.path).first : 'Please select your vault !';
    });
  }
}

List<Wallets> loadWallets(String jsonData) {
  var walletsObjsJson = jsonDecode(jsonData) as List;

  List<Wallets> walletsObjs = walletsObjsJson.map((tagJson) => Wallets.fromJson(tagJson)).toList();

  return walletsObjs;
}
