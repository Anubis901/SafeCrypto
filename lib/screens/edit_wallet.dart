import 'package:flutter/material.dart';
import './unlocked_home.dart';
import './home.dart';

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

    var currentWallet = wallets.where((element) => element.id == walletId);

    return Scaffold(
        appBar: AppBar(
          title: const Text('CryptoSafe'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: Image.asset(
              'assets/wallet.png',
              fit: BoxFit.fill,
              width: 210.0,
              height: 200.0,
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: Text(
              "Add a new wallet",
              style: TextStyle(fontSize: 62.0, color: Color(0xFFE2A400), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: SizedBox(
              child: SizedBox(
                width: 440,
                child: TextFormField(
                  // initialValue: "currentWallet.first.coinName",
                  textAlign: TextAlign.center,
                  controller: coinName..text = currentWallet.first.coinName,
                  style: const TextStyle(
                    fontSize: 38,
                    color: Colors.amber,
                  ),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    hintText: "Coin Name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: SizedBox(
              child: SizedBox(
                width: 440,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: publicKey..text = currentWallet.first.publicKey,
                  style: const TextStyle(
                    fontSize: 38,
                    color: Colors.amber,
                  ),
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    hintText: "Public Key",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: SizedBox(
              // width: 50,
              // height: 100,
              child: SizedBox(
                width: 440,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: privateKey..text = currentWallet.first.privateKey,
                  style: const TextStyle(
                    fontSize: 38,
                    color: Colors.amber,
                  ),
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),

                    hintText: "Private Key",
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
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: SizedBox(
              child: SizedBox(
                width: 440,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: seed..text = currentWallet.first.seed,
                  style: const TextStyle(
                    fontSize: 38,
                    color: Colors.amber,
                  ),
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    hintText: "Seed",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: SizedBox(
              child: SizedBox(
                width: 440,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: comment..text = currentWallet.first.comment,
                  style: const TextStyle(
                    fontSize: 38,
                    color: Colors.amber,
                  ),
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    hintText: "Comment",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: ElevatedButton(
                onPressed: () {
                  String error = '';
                  // new wallet
                  var wallet = Wallets(coinName.text, publicKey.text, privateKey.text, seed.text, comment.text,
                      DateTime.now().millisecondsSinceEpoch.toString() // unique id
                      );
                  // Check inputs and add it
                  if ((error = checkAddWalletInput(wallet)) == 'Wallet added to your vault') {
                    // wallets.removeWhere((element) => false)
                    wallets.removeWhere((element) => element.id == walletId);
                    wallets.add(wallet);
                    addWallet(wallets, fileName, password.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'Wallet added to your vault',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            error,
                            style: const TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                  }
                },
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(Colors.amber),
                    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
                )),
          ),
        ]));
  }

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
}
