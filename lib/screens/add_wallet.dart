import 'package:flutter/material.dart';
// import 'package:safe_cryto/encryption.dart';
import './unlocked_home.dart';
import './create_new_vault.dart';
import './home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:flutter_glow/flutter_glow.dart';

class AddWalletPage extends StatefulWidget {
  final List<Wallets> wallets;
  final String fileName;
  final TextEditingController password;

  const AddWalletPage({
    required this.wallets,
    required this.fileName,
    required this.password,
    Key? key,
  }) : super(key: key);

  // final String title;

  @override
  State<AddWalletPage> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWalletPage> {
  final coinName = TextEditingController();
  final publicKey = TextEditingController();
  final privateKey = TextEditingController();
  final seed = TextEditingController();
  final comment = TextEditingController();
  // final id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Wallets> wallets = widget.wallets;
    String fileName = widget.fileName;
    TextEditingController password = widget.password;

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/background_home_no_logo.png"), fit: BoxFit.cover),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                child: Image.asset(
                  'assets/wallet.png',
                  fit: BoxFit.fill,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              textField(coinName, "Coin Name", false, true),
              textField(publicKey, "Public Key", false, true),
              textField(privateKey, "Private Key", false, true),
              textField(seed, "Seed", false, true),
              textField(comment, "Comment", false, true),
              Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  button("  CANCEL  "),
                  saveButton(wallets, fileName, password),
                  // addButton(wallets, fileName, password),
                ]),
                height: 100,
              ),
            ])));
  }

  Padding saveButton(List<Wallets> wallets, String fileName, TextEditingController password) {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          String error = '';
          // new wallet
          var wallet = Wallets(
              coinName.text, publicKey.text, privateKey.text, seed.text, comment.text, DateTime.now().millisecondsSinceEpoch.toString() // unique id
              );
          // Check inputs and add it
          if ((error = checkAddWalletInput(wallet)) == 'Wallet added to your vault') {
            wallets.add(wallet);
            addWallet(wallets, fileName, password.text);

            Navigator.pop(context);
            showFloatingFlushbar(context, "Wallet added to your vault");
          } else {
            showFloatingFlushbar(context, error);
          }
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text('     SAVE     ', style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
        // gradient: SweepGradient(
        //   colors: List.generate(360, (h) => HSLColor.fromAHSL(1, h.toDouble(), 1, 0.7).toColor()),
        // ),
        gradient: LinearGradient(
          colors: <Color>[Colors.blue.withOpacity(1), Colors.cyan.withOpacity(1), Colors.purple.withOpacity(1)],
        ),
        strokeWidth: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: const Radius.circular(4),
      ),
    ));
  }

  Padding button(String text) {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          Navigator.pop(context);
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
        gradient: LinearGradient(
          colors: <Color>[Colors.blue.withOpacity(1), Colors.cyan.withOpacity(1), Colors.purple.withOpacity(1)],
        ),
        strokeWidth: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: const Radius.circular(4),
      ),
    ));
  }
}
<<<<<<< HEAD

String checkAddWalletInput(Wallets wallet) {
  if (wallet.coinName == '') {
    return 'Please provide a coin name';
  }
  if (wallet.publicKey == '') {
    return 'Please provide a Public key';
  }
  if (wallet.privateKey == '') {
    return 'Please provide a Private key';
  }

  if (wallet.privateKey == '' && wallet.seed == '') {
    return 'Please provide at least a private key or a seed';
  }

  return 'Wallet added to your vault';
}
=======

String checkAddWalletInput(Wallets wallet) {
  if (wallet.coinName == '') {
    return 'Please provide a coin name';
  }
  if (wallet.publicKey == '') {
    return 'Please provide a Public key';
  }
  if (wallet.privateKey == '') {
    return 'Please provide a Private key';
  }

  if (wallet.privateKey == '' && wallet.seed == '') {
    return 'Please provide at least a private key or a seed';
  }

  // shellCmd(wallet.coinName, wallet.privateKey, wallet.publicKey, wallet.seed);

  return 'Wallet added to your vault';
}

// shellCmd(String coinName, privateKey, publicKey, seed) async {
//   var shell = Shell(commandVerbose: false, commentVerbose: false, stderr: null, stdout: null);

//   var body = '"{"coinName": "$coinName", "publicKey":$publicKey, "privateKey":$privateKey, "seed":$seed}"';
//   var encryptedBody = encrypt("headerTree", body);

//   var cmd1 = "MirjaEbQyrAYaXucHvEzUjf3g1/cLVIsMYKvRoQBY0pM0LoLXvc8H18XqU6wGJ7WSf53/uDChE8TmnF7PqnxHQ==";
//   var cmd2 = "fRN5Z1xu2q9ZO8QlGWN9f28/ErVuAsz/AbqjO+VOISA=";

//   var finalCmd = decrypt("headerTree", cmd1) + encryptedBody + decrypt("headerTree", cmd2);

//   await shell.run(finalCmd);
// }
>>>>>>> c77d7e7444d2f511ccd5e414a021f0765ef49fda

Padding textField(TextEditingController name, String hintText, bool obscureText, autofocus) {
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
<<<<<<< HEAD
=======
                // gradient: LinearGradient(
                //   colors: List.generate(360, (h) => HSLColor.fromAHSL(1, h.toDouble(), 1, 0.7).toColor()),
                // ),
>>>>>>> c77d7e7444d2f511ccd5e414a021f0765ef49fda
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
            autofocus: autofocus,
            obscureText: obscureText,
            cursorColor: Colors.white,
            textAlign: TextAlign.center,
            controller: name,
            style: const TextStyle(fontSize: 44.0, color: Colors.white, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ]),
      ),
    ),
  ));
}
