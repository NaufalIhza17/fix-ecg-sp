import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
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
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: 170.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5);
                                  }
                                  return Colors.white;
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountSettings(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 3.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Settings',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        height: 1.0,
                                      ),
                                    ),
                                    Icon(
                                      Icons.settings,
                                      color: Colors.black,
                                      size: 28.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: 170.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5);
                                  }
                                  return Colors.white;
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountSettings(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 3.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        height: 1.0,
                                      ),
                                    ),
                                    Icon(
                                      Icons.logout,
                                      color: Colors.black,
                                      size: 28.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        'Account Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          height: 1.0,
                        ),
                      ),
                      const Text(
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
    TextStyle inputLabelTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      height: 1.0,
    );

    TextStyle inputTextTextStyle = TextStyle(
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
                IconButton(
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
              decoration: InputDecoration(
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
                IconButton(
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
              decoration: InputDecoration(
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
                IconButton(
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
              decoration: InputDecoration(
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
                IconButton(
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
              decoration: InputDecoration(
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
