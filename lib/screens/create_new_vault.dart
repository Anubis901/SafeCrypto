import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui';
import 'dart:io';
import 'package:gradient_text/gradient_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flushbar/flushbar.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import '../encryption.dart';
import './add_wallet.dart';

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
        body: Stack(children: [
      Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/background_home_no_logo.png"), fit: BoxFit.cover),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              child: GradientText("CREATE A NEW VAULT",
                  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
                  style: GoogleFonts.poppins(fontSize: 80.0, color: Color(0xffffffff), fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
            ),
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Advices for a strong password:\n",
                        style: GoogleFonts.poppins(fontSize: 36.0, color: Color(0xffffffff), fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                            text: "- At least 8 characters the more characters, the better\n",
                            style: GoogleFonts.poppins(fontSize: 15.0, color: Color(0xff888888), fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: "- A mixture of both uppercase and lowercase letters\n",
                            style: GoogleFonts.poppins(fontSize: 15.0, color: Color(0xff888888), fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: "- A mixture of letters and numbers\n",
                            style: GoogleFonts.poppins(fontSize: 15.0, color: Color(0xff888888), fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: "- Inclusion of at least one special character, e.g., ! @ # ? ]",
                            style: GoogleFonts.poppins(fontSize: 15.0, color: Color(0xff888888), fontWeight: FontWeight.w500),
                          )
                        ]))),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              child: SizedBox(
                // width: 50,
                // height: 100,
                child: IconButton(
                  color: Colors.white,
                  hoverColor: Colors.black,
                  icon: const Icon(Icons.folder_rounded),
                  iconSize: 160,
                  onPressed: () {
                    _selectFolder();
                    showFloatingFlushbar(context, "Please select a folder");
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
                  style: GoogleFonts.poppins(fontSize: 20.0, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            textField(vaultName, "Vault Name", false, true),
            textField(password, "Enter password", true, false),
            textField(confirmPassword, "Confirm password", true, false),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[cancelButton(), createButton()]),
            Container(
              width: 200.0,
              color: Colors.transparent,
            ),
          ]))
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

  Padding createButton() {
    return (Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: OutlineGradientButton(
        onTap: () {
          if (_directoryPath == 'Click to select a destination folder!') {
            showFloatingFlushbar(context, "Please choose a folder destination!");
            return;
          } else if (password.text.isEmpty || confirmPassword.text.isEmpty) {
            showFloatingFlushbar(context, "Empty password field !");
            return;
          } else if (password.text.length > 32) {
            showFloatingFlushbar(context, "Password must not exceed 32 characteres !");
            return;
          } else if (password.text != confirmPassword.text) {
            showFloatingFlushbar(context, "Password are not same !");
            return;
          } else if (vaultName.text == '') {
            showFloatingFlushbar(context, "Please give a name to your vault!");
            return;
          }
          // file path of the vault
          filePath = _directoryPath.toString() + '/' + vaultName.text + '.cryptoSafe';
          // === If all requieremnt are satisfied, create a vault file
          if (createVaultFile(filePath, password.text) == false) {
            showFloatingFlushbar(context, "File exists. Please choose a different file name !");
            return;
          } else {
            Navigator.pop(context);
            showFloatingFlushbar(context, "Vault created !");
          }
        },
        inkWell: true,
        backgroundColor: const Color(0xFF18163d),
        child: Text("    CREATE    ", style: GoogleFonts.poppins(fontSize: 28.0, color: const Color(0xffffffff), fontWeight: FontWeight.w700)),
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

void showFloatingFlushbar(BuildContext context, String message) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    margin: EdgeInsets.all(10),
    borderRadius: 8,
    borderColor: Colors.grey,
    backgroundGradient: LinearGradient(
      colors: [Colors.blue.withOpacity(0.6), Colors.purple.withOpacity(0.6)],
    ),
    boxShadows: const [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],
    duration: const Duration(seconds: 4),
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    // title: message,
    message: " ",
    titleText: Title(
        color: Colors.white,
        child: Text(message,
            // gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
            style: GoogleFonts.poppins(fontSize: 25.0, color: Color(0xffffffff), fontWeight: FontWeight.w500),
            textAlign: TextAlign.center)),
  ).show(context);
}
