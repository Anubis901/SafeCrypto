import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './home.dart';
import "./unlock_vault.dart";
import '../encryption.dart';
import 'add_wallet.dart';
import './create_new_vault.dart';
import './edit_wallet.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class UnlockedHomePage extends StatefulWidget {
  final List<Wallets> wallets;
  final String fileName;
  final TextEditingController password;

  const UnlockedHomePage({
    required this.wallets,
    required this.fileName,
    required this.password,
    Key? key,
  }) : super(key: key);

  @override
  State<UnlockedHomePage> createState() => _UnlockedHomeState();
}

class _UnlockedHomeState extends State<UnlockedHomePage> {
  @override
  Widget build(BuildContext context) {
    List<Wallets> wallets = widget.wallets;
    // List<Wallets> wallets = [
    //   Wallets('Bitcoin', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('Ethereum', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('Stellar', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('Ripple', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('BSC', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('DOGE', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('BNB', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('LTC', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    //   Wallets('ADA', 'publicKey', 'privateKey', 'seed', 'comment', 'id'),
    // ];

    String fileName = widget.fileName;
    TextEditingController password = widget.password;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/background_home_no_logo.png"), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.95,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.blue.withOpacity(0.4), Colors.purple.withOpacity(0.4)],
                    ),
                  ),
                  child: wallets.isNotEmpty
                      ? SingleChildScrollView(
                          padding: EdgeInsetsDirectional.all(20),
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                            children: wallets
                                .map((item) => Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(10),
                                    shadowColor: Colors.purple,
                                    child: Container(
                                        width: 300,
                                        height: 300,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blueAccent, width: 2.0),
                                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: <Color>[Color(0xFF18163d), Color(0xFF18163d)],
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                item.coinName,
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 42),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                item.comment,
                                                style: const TextStyle(color: Colors.white, fontSize: 18),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              child: Image.asset(
                                                'assets/coins/' + retrieveCoinLogo(item.coinName),
                                                fit: BoxFit.fill,
                                                width: 160.0,
                                                height: 160.0,
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                              children: [
                                                Container(
                                                  alignment: Alignment.bottomRight,
                                                  child: Tooltip(
                                                    message: 'Edit',
                                                    child: IconButton(
                                                      color: Colors.white,
                                                      icon: const Icon(Icons.edit),
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => EditWalletPage(
                                                                    wallets: wallets,
                                                                    fileName: fileName,
                                                                    password: password,
                                                                    walletId: item.id,
                                                                  )),
                                                        ).then((_) => setState(() {}));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                showItem("Public Key", item.publicKey, item.coinName, context, Icons.qr_code),
                                                showItem("Private Key", item.privateKey, item.coinName, context, Icons.qr_code_2),
                                                showItem("Seed", item.seed, item.coinName, context, Icons.grass),
                                                Container(
                                                  alignment: Alignment.bottomRight,
                                                  child: Tooltip(
                                                    message: 'Remove wallet',
                                                    child: IconButton(
                                                      color: Colors.white,
                                                      icon: const Icon(Icons.delete),
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        Widget cancelButton = TextButton(
                                                          child: const Text("No"),
                                                          onPressed: () => Navigator.pop(context),
                                                        );

                                                        Widget continueButton = TextButton(
                                                          child: const Text("Yes"),
                                                          onPressed: () {
                                                            // Remove entry in list
                                                            wallets.removeWhere((element) => element.id == item.id);
                                                            storeToVault(wallets, fileName, password.text);
                                                            Navigator.pop(context);
                                                          },
                                                        );

                                                        AlertDialog alert = AlertDialog(
                                                          title: const Text("Remove wallet"),
                                                          content: const Text("Are you sure ?"),
                                                          actions: [
                                                            cancelButton,
                                                            continueButton,
                                                          ],
                                                        );

                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return alert;
                                                          },
                                                        ).then((_) => setState(() {}));
                                                        // popupRemove(context, item.id, wallets);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        ))))
                                .toList()
                                .cast<Widget>(),
                            alignment: WrapAlignment.center,
                            spacing: 10.0, // gap between adjacent chips
                            runSpacing: 10.0, // gap between lines
                          ),
                        )
                      : Center(
                          // padding: const EdgeInsets.all(100.0),
                          child: GradientText("Your vault is empty \nYou can add a wallet by clicking \non the 'ADD' button",
                              gradient: LinearGradient(colors: [Colors.grey, Colors.blue]),
                              style: GoogleFonts.poppins(fontSize: 60.0, color: Color(0xffffffff), fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                        )),
            ),
            Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                button("    LOCK    ", password),
                addButton(wallets, fileName, password),
              ]),
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  Padding button(String text, TextEditingController password) {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          password.clear();
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

  Padding addButton(List<Wallets> wallets, String fileName, TextEditingController password) {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddWalletPage(
                      wallets: wallets,
                      fileName: fileName,
                      password: password,
                    )),
          ).then((_) => setState(() {}));
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text('      ADD     ', style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
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

Container showItem(String elemName, String item, coinName, BuildContext context, IconData icon) {
  return Container(
    child: Tooltip(
      message: 'Display ' + elemName,
      child: IconButton(
        color: Colors.white,
        icon: Icon(icon),
        iconSize: 30,
        onPressed: item == ''
            ? null
            : () {
                AlertDialog alert = AlertDialog(
                    backgroundColor: Colors.blue[100],
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            coinName + ' ' + elemName,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(border: Border.all(width: 5.0)),
                          child: PrettyQr(
                            elementColor: Colors.black,
                            image: const AssetImage('assets/logo.png'),
                            typeNumber: 10,
                            size: 300,
                            data: item,
                            errorCorrectLevel: QrErrorCorrectLevel.M,
                            roundEdges: true,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(10.0),
                          child: Tooltip(
                            message: 'Copy to clipboard',
                            child: TextButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: item));
                                Navigator.pop(context);
                                showFloatingFlushbar(context, 'Copied to clipboard !');
                              },
                              label: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // ),
                      ],
                    ));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
      ),
    ),
  );
}

void addWallet(List<Wallets> wallets, String fileName, password) {
  storeToVault(wallets, fileName, password);
}

void storeToVault(List<Wallets> wallets, String fileName, password) {
  String jsonString = jsonEncode(wallets);

  var encrypted = encrypt(password, jsonString);
  writeData(encrypted, fileName);
}

String retrieveCoinLogo(String coinName) {
  String coin = 'default';
  var coinsLogoName = {
    ['btc', 'bitcoin'],
    ['eth', 'ethereum'],
    ['ada', 'cardano'],
    ['bnb', 'binance coin', 'binancecoin'],
    ['usdt', 'tether'],
    ['xrp', 'ripple'],
    ['doge', 'dogecoin', 'doge coin'],
    ['usdc', 'usdcoin', 'usd coin'],
    ['xlm', 'stellar'],
    ['metamask', 'metamask'],
    // ['sol', 'solana'],
    // ['dot', 'polkadot'],
    // ['uni', 'uniswap'],
    // ['luna', 'terra'],
    ['bch', 'bitcoin cash', 'bitcoincash'],
    ['busd', 'binance usd', 'binanceusd'],
    ['ltc', 'litecoin'],
    // ['link', 'chianlink'],
    // ['icp', 'internet computer'],
    // ['wbtc', 'wrapped bitcoin'],
    // ['matic', 'polygon'],
    // ['avax', 'avalanche'],
    ['bsc', 'binance smart chain', 'binancesmartchain'],
  };

  coinsLogoName.forEach((element) {
    if (element.contains(coinName.toLowerCase())) {
      coin = element.first.toLowerCase();
    }
  });

  return coin.toUpperCase() + '.png';
}
