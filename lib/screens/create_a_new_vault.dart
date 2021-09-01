import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui';
import 'dart:io';
import '../encryption.dart';

class CreateNewVaultPage extends StatefulWidget {
  const CreateNewVaultPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CreateNewVaultPage> createState() => _CreateNewVaultState();
}

class _CreateNewVaultState extends State<CreateNewVaultPage> {
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final vaultName = TextEditingController();
  var filePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CryptoSafe'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: Text(
              "Create a new Vault",
              style: TextStyle(fontSize: 62.0, color: Color(0xFFE2A400), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: Text(
              'ADVICES FOR A STRONG PASSWORD:',
              style: TextStyle(fontSize: 26.0, color: Color(0xFFFF0000), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: Text(
              '''- At least 8 characters the more characters, the better\n- A mixture of both uppercase and lowercase letters\n- A mixture of letters and numbers\n- Inclusion of at least one special character, e.g., ! @ # ? ]''',
              style: TextStyle(fontSize: 14.0, color: Color(0xFFFF0000), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: SizedBox(
              // width: 50,
              // height: 100,
              child: IconButton(
                color: Colors.amber,
                hoverColor: Colors.black,
                icon: const Icon(Icons.folder),
                iconSize: 160,
                onPressed: () {
                  _selectFolder();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.amber,
                        content: Text(
                          'Please select a folder',
                          style: TextStyle(color: Colors.black, fontSize: 26),
                          textAlign: TextAlign.center,
                        )),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: SizedBox(
              // width: 50,
              // height: 100,
              child: Text(
                _directoryPath!,
                // overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20.0, color: Colors.amber, fontWeight: FontWeight.w500, fontFamily: "Roboto"),
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
                  controller: vaultName,
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
                    hintText: "Vault Name",
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
                    hintText: "Enter New Password",
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
                  controller: confirmPassword,
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

                    hintText: "Confirm your Password",
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
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: ElevatedButton(
                onPressed: () {
                  if (_directoryPath == 'Click to select a destination folder!') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'Please choose a folder destination!',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                    return;
                  } else if (password.text.isEmpty || confirmPassword.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'Empty password field !',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                    return;
                  } else if (password.text.length > 32) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'Password must not exceed 32 characteres !',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                    return;
                  } else if (password.text != confirmPassword.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'Password are not same !',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                    return;
                  } else if (vaultName.text == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'Please give a name to your vault!',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                    return;
                  }
                  // file path of the vault
                  filePath = _directoryPath.toString() + '/' + vaultName.text + '.cryptoSafe';
                  // === If all requieremnt are satisfied, create a vault file
                  if (createVaultFile(filePath, password.text) == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'File exists. Please choose a different file name !',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.amber,
                          content: Text(
                            'Vault created !',
                            style: TextStyle(color: Colors.black, fontSize: 26),
                            textAlign: TextAlign.center,
                          )),
                    );
                    Navigator.pop(context);
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

  String? _directoryPath = 'Click to select a destination folder!';

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() {
        _directoryPath = value != null ? value.toString() : '';
      });
    });
  }

  bool createVaultFile(String filePath, String passwordString) {
    String dataString = "[]";

    if (File(filePath).existsSync() == true) {
      return false;
    }

    var encrypted = encrypt(passwordString, dataString);
    writeData(encrypted, filePath);

    return true;
  }
}
