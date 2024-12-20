import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import '../components/logged_in_navbar.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({
    super.key,
  });

  @override
  State<AccountSettings> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettings> {
  // COMMON COMPONENTS
  TextStyle headerTextStyle = const TextStyle(
    color: Colors.black,
    //fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  TextStyle focusTextStyle = const TextStyle(
    color: Colors.red,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  TextStyle infoTextStyle = TextStyle(
    fontFamily: Platform.isIOS ? 'sans_serif' : 'monospace',
    fontSize: Platform.isIOS ? 17 : 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  TextStyle fieldTextStyle = TextStyle(
    fontFamily: Platform.isIOS ? 'sans_serif' : 'monospace',
    fontSize: Platform.isIOS ? 19 : 18,
    fontWeight: FontWeight.w600,
    color: Colors.blue,
  );

  TextStyle errorTextStyle = TextStyle(
    fontFamily: Platform.isIOS ? 'sans_serif' : 'monospace',
    fontSize: Platform.isIOS ? 19 : 18,
    fontWeight: FontWeight.w600,
    color: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF202020), Color(0xFF202020)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LoggedInNavbar(
                    isNotHome: true,
                  ),
                  Column(
                    children: [
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'Change your account information here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  AccountInfoForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class AccountInfoForm extends StatelessWidget {
  const AccountInfoForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle inputLabelTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      height: 1.0,
    );

    TextStyle inputTextTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: inputLabelTextStyle,
                ),
                const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20.0,
                      semanticLabel: 'Edit email',
                    ),
                    padding: EdgeInsets.zero,
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
              initialValue:
                  'user@gmail.com', // TODO: harusnya ambil dari database
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Phone number',
                  style: inputLabelTextStyle,
                ),
                const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20.0,
                    semanticLabel: 'Change phone number',
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
              initialValue:
              '+886 9XXXXXXXX', // TODO: harusnya ambil dari database
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name',
                  style: inputLabelTextStyle,
                ),
                const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20.0,
                    semanticLabel: 'Change name',
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
              initialValue:
              'Steve', // TODO: harusnya ambil dari database
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password',
                  style: inputLabelTextStyle,
                ),
                const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20.0,
                    semanticLabel: 'Change password',
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x336C6C6C),
                border: OutlineInputBorder(),
              ),
              style: inputTextTextStyle,
              initialValue:
              'password', // TODO: harusnya ambil dari database
              obscureText: true,
              obscuringCharacter: '*',
            ),
          ],
        ),
      ],

    );
  }
}
