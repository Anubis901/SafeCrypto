import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:safe_cryto/encryption.dart';
import 'package:safe_cryto/screens/unlocked_home.dart';
import 'dart:ui';
import './create_a_new_vault.dart';
import './how_it_works.dart';
import '../encryption.dart';
import 'dart:convert';

class Wallets {
  String coinName;
  String publicKey;
  String privateKey;
  String seed;
  String comment;
  String id;

  Wallets(
    this.coinName,
    this.publicKey,
    this.privateKey,
    this.seed,
    this.comment,
    this.id,
  );

  Map toJson() => {
        'coinName': coinName,
        'publicKey': publicKey,
        'privateKey': privateKey,
        'seed': seed,
        'comment': comment,
        'id': id,
      };

  factory Wallets.fromJson(dynamic json) {
    return Wallets(
      json['coinName'] as String,
      json['publicKey'] as String,
      json['privateKey'] as String,
      json['seed'] as String,
      json['comment'] as String,
      json['id'] as String,
    );
  }

  @override
  String toString() {
    return '{ $coinName, $publicKey, $privateKey, $seed, $comment, $id }';
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      appLogo(),
      homeTitle(),
      browseButton(),
      vaultName(),
      passwordField(),
      unlockButton(),
      createNewVault(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          version(),
          // howItWorks(),
        ],
      ),
    ]));
  }

  Padding appLogo() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: Image.asset(
        'assets/lock.png',
        fit: BoxFit.fill,
        width: 200.0,
        height: 200.0,
      ),
    ));
  }

  Padding homeTitle() {
    return (const Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: Text(
        "Welcome to CryptoSafe",
        style: TextStyle(fontSize: 60.0, color: Color(0xFFE2A400), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
      ),
    ));
  }

  Padding browseButton() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: SizedBox(
        child: IconButton(
          color: Colors.amber,
          hoverColor: Colors.black,
          icon: const Icon(Icons.lock_outline_rounded),
          iconSize: 120,
          onPressed: () {
            openFinder();
            displaySnackMessage('Please select your vault', context);
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
        style: const TextStyle(fontSize: 26.0, color: Colors.amber, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
      ),
    ));
  }

  Padding passwordField() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: SizedBox(
        child: SizedBox(
          width: 440,
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: password,
            style: const TextStyle(
              fontSize: 38,
              color: Colors.amber,
            ),
            obscureText: true,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              // contentPadding: EdgeInsets.all(20.0),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              // enabledBorder: true,r
            ),
          ),
        ),
      ),
    ));
  }

  Padding unlockButton() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: ElevatedButton(
          onPressed: () {
            if (_fileName == 'Please select your vault !') {
              displaySnackMessage('Please select a vault to unlock !', context);
              return;
            } else if (password.text.isEmpty) {
              displaySnackMessage('Empty password field !', context);
              return;
            }

            encryptedVault = readFile(_fileName.toString());
            decryptedVault = decrypt(password.text, encryptedVault);

            if (decryptedVault == 'INVALID_VAULT') {
              displaySnackMessage('Invalid vault file specified !', context);
              return;
            } else if (decryptedVault == 'WRONG_PASSWORD') {
              displaySnackMessage('Wrong password !', context);
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
              // password.clear();
            } else {
              displaySnackMessage('Unknown error !', context);
              return;
            }
          },
          style: defaultButtonStyle(),
          child: const Text(
            "Unlock my Vault",
            style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
          )),
    ));
  }

  Padding createNewVault() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateNewVaultPage(title: '')),
            );
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HowItWorksPage(title: '')),
          );
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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> displaySnackMessage(String message, BuildContext context) {
  return (ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amber,
      content: Text(
        message,
        style: const TextStyle(color: Colors.black, fontSize: 26),
        textAlign: TextAlign.center,
      ))));
}
