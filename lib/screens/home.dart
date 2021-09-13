import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
// import 'package:safe_cryto/encryption.dart';
// import 'package:safe_cryto/screens/unlocked_home.dart';
// import 'dart:ui';
import './create_new_vault.dart';
import './unlock_vault.dart';
// import './how_it_works.dart';
// import '../encryption.dart';
import 'dart:convert';
import '../theme.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:process_run/shell.dart';

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

List<bool> selected = [true, false, false, false, false];

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
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background_home.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
              Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                // homeTitle(),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                  child: OutlineGradientButton(
                    inkWell: true,
                    backgroundColor: const Color(0xFF18163d),
                    child: Text('Welcome to CRYPTOSAFE',
                        style: GoogleFonts.poppins(fontSize: 80.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
                    gradient: LinearGradient(
                      colors: <Color>[Colors.blue.withOpacity(1), Colors.cyan.withOpacity(1), Colors.purple.withOpacity(1)],
                    ),
                    strokeWidth: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    radius: const Radius.circular(4),
                  ),
                ),
                catchPhrase(),
              ]),
              // Used as spacer
              Container(height: 100.0, color: Colors.transparent),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    createNewVaultPhrase('       Don\'t have a vault ?', '\n                                      Create a vault here !'),
                    createNewVaultPhrase('Already have a vault ?', '\n                          Unlock your vault here'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // alreadyHaveAVaultPhrase(),
                    unlockVaultButton(),
                    newVaultButton(),
                  ],
                ),
              ]),

              // ),
            ])),
        // sideBar(),
      ]),
    );
  }

  Container sideBar() {
    return (Container(
      // margin: EdgeInsets.all(0.0),
      height: MediaQuery.of(context).size.height,
      width: 101.0,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.grey.shade600),
          // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
        ),
        gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.5, 1],
            colors: [Color(0xff161439), Color(0xff00163b), Color(0xff161439)]),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40,
            left: 15,
            child: appLogo(),
          ),
          Positioned(
            top: 200,
            left: 20,
            child: Column(children: <Widget>[
              IconButton(
                color: Colors.white,
                hoverColor: Colors.black,
                icon: const Icon(Icons.home),
                iconSize: 40,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.white,
                hoverColor: Colors.white,
                icon: const Icon(Icons.add_box_rounded),
                iconSize: 40,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.white,
                hoverColor: Colors.white,
                icon: const Icon(Icons.compare_arrows_sharp),
                iconSize: 40,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.white,
                hoverColor: Colors.white,
                icon: const Icon(Icons.settings),
                iconSize: 40,
                onPressed: () {},
              ),
            ]),
          ),
        ],
      ),
    ));
  }

  Container appLogo() {
    return (Container(
      height: 70.0,
      width: 70.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo.png'),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    ));
  }

  Padding homeTitle() {
    return (Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
        child: Card(
          color: const Color(0xFF18163d),
          elevation: 3,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GradientText(
                'Welcome to CRYPTOSAFE',
                gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                style: GoogleFonts.poppins(fontSize: 80.0, color: Color(0xffffffff), fontWeight: FontWeight.w700),
              )),
        )));
  }

  Padding catchPhrase() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: Text("THE BEST SOLUTION IN TERMS OF SAFETY FOR YOUR WALLET !",
          // gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
          style: GoogleFonts.poppins(fontSize: 25.0, color: Color(0xffffffff), fontWeight: FontWeight.w500),
          textAlign: TextAlign.center),
    ));
  }

  Padding createNewVaultPhrase(String str1, str2) {
    return (Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
        child: Center(
            child: RichText(
                text: TextSpan(
                    text: str1,
                    style: GoogleFonts.poppins(fontSize: 36.0, color: Color(0xffffffff), fontWeight: FontWeight.w500),
                    children: <TextSpan>[
              TextSpan(
                text: str2,
                style: GoogleFonts.poppins(fontSize: 15.0, color: Color(0xffffffff), fontWeight: FontWeight.w300),
              )
            ])))));
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

  Padding newVaultButton() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNewVaultPage(title: '')),
          );
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text('     NEW VAULT     ', style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
        gradient: LinearGradient(
          colors: <Color>[Colors.blue.withOpacity(1), Colors.cyan.withOpacity(1), Colors.purple.withOpacity(1)],
        ),
        strokeWidth: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: const Radius.circular(4),
      ),
    ));
  }

  Padding unlockVaultButton() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UnlockVault(title: '')),
          );
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text('UNLOCK VAULT', style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
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

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final Function onTap;
  final bool selected;

  NavBarItem({
    required this.icon,
    required this.onTap,
    required this.selected,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 101,
      color: Colors.transparent,
      child: Stack(children: [
        InkWell(
          child: Container(
            height: 80.0,
            width: 101.0,
            child: Center(
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 26.0,
              ),
            ),
          ),
          onTap: () {},
          onHover: (value) {},
        ),
      ]),
    );
  }
}
