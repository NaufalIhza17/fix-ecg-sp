import 'package:ecg/page/new_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../page/account_settings.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../page/login/login_page.dart';
import '../provider/auth_provider.dart';

const double buttonSize = 72.0;
const double horizontalPadding = 20.0;

class LoggedInNavbar extends StatelessWidget {
  const LoggedInNavbar({
    super.key,
    this.isNotHome = false,
  });

  final bool isNotHome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 50,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: isNotHome,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewHome(),
                    ),
                  );
                },
                child: Container(
                  width: 72.0,
                  height: 72.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: SvgPicture.asset(
                    './assets/icons/back.svg',
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 72.0,
                  height: 72.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: SvgPicture.asset(
                    './assets/icons/notification.svg',
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const ProfileMenuButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuButton extends StatefulWidget {
  const ProfileMenuButton({
    super.key,
  });

  @override
  State<ProfileMenuButton> createState() => _ProfileMenuButtonState();
}

class _ProfileMenuButtonState extends State<ProfileMenuButton> {
  final _profileOverlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.0,
      height: 72.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ElevatedButton(
        onPressed: _profileOverlayController.toggle,
        child: OverlayPortal(
          controller: _profileOverlayController,
          overlayChildBuilder: (BuildContext context) {
            return GestureDetector(
              onTap: _profileOverlayController.toggle,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x1AFFFFFF),
                ),
                child: const ProfileMenuOverlay(),
              ),
            );
          },
          child: SvgPicture.asset(
            './assets/icons/avatar.svg',
            width: 36,
            height: 36,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class ProfileMenuOverlay extends StatelessWidget {
  const ProfileMenuOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        decoration: const BoxDecoration(color: Color(0x1AFFFFFF)),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQueryData.fromView(
                  ui.PlatformDispatcher.instance.implicitView!,
                ).padding.top +
                buttonSize +
                40.0,
            left: horizontalPadding,
            right: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 156.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: 156.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
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
                    context.read<AuthProvider>().logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ],
          ),
        ),
      ),
    );
  }
}
