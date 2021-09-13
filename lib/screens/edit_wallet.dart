// import 'dart:html';
import 'package:flutter/material.dart';
import './unlocked_home.dart';
import './home.dart';
import './add_wallet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import './create_new_vault.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditWalletPage extends StatefulWidget {
  final List<Wallets> wallets;
  final String fileName;
  final TextEditingController password;
  final String walletId;

  const EditWalletPage({
    required this.wallets,
    required this.fileName,
    required this.password,
    required this.walletId,
    Key? key,
  }) : super(key: key);

  // final String title;

  @override
  State<EditWalletPage> createState() => _EditWalletPage();
}

class _EditWalletPage extends State<EditWalletPage> {
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
    String walletId = widget.walletId;

    final String assetName = 'assets/wallet.svg';

    var currentWallet = wallets.where((element) => element.id == walletId);

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
              textField(currentWallet.first.coinName, coinName, "Coin Name", true),
              textField(currentWallet.first.publicKey, publicKey, "Public Key", false),
              textField(currentWallet.first.privateKey, privateKey, "Private Key", false),
              textField(currentWallet.first.seed, seed, "Seed", false),
              textField(currentWallet.first.comment, comment, "Comment", false),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[button("  CANCEL  "), saveButton(wallets, fileName, password, walletId)]),
                height: 100,
              ),
            ])));
  }

  Padding textField(String currentWallet, TextEditingController name, String hintText, autofocus) {
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
              cursorColor: Colors.white,
              textAlign: TextAlign.center,
              controller: name..text = currentWallet,
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

  Padding saveButton(List<Wallets> wallets, String fileName, TextEditingController password, String walletId) {
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
            // wallets.removeWhere((element) => false)
            wallets.removeWhere((element) => element.id == walletId);
            wallets.add(wallet);
            addWallet(wallets, fileName, password.text);
            Navigator.pop(context);
            showFloatingFlushbar(context, "Wallet updated");
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
}
