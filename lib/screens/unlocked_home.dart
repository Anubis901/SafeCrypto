import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './home.dart';
import '../encryption.dart';
import './add_wallet.dart';
import './edit_wallet.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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
    String fileName = widget.fileName;
    TextEditingController password = widget.password;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.lock, color: Colors.black),
            color: Colors.black,
            onPressed: () {
              password.clear();
              Navigator.pop(context, true);
            }),
        title: const Text('My Wallets'),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            alignment: Alignment.center,
            child: Wrap(
              children: wallets
                  .map((item) => Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      shadowColor: Colors.amber,
                      child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.orange[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  item.coinName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 42),
                                ),
                              ),
                              Spacer(),
                              Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  item.comment,
                                  style: const TextStyle(color: Colors.black, fontSize: 18),
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
                                        color: Colors.black,
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
                                        color: Colors.black,
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
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
        backgroundColor: Colors.amber[700],
      ),
    );
  }
}

Container showItem(String elemName, String item, coinName, BuildContext context, IconData icon) {
  return Container(
    child: Tooltip(
      message: 'Display ' + elemName,
      child: IconButton(
        color: Colors.black,
        icon: Icon(icon),
        iconSize: 30,
        onPressed: item == ''
            ? null
            : () {
                AlertDialog alert = AlertDialog(
                    backgroundColor: Colors.amber[100],
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
                            image: const AssetImage('assets/lock.png'),
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
                                displaySnackMessage('Copied to clipboard !', context);
                                Navigator.pop(context);
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
