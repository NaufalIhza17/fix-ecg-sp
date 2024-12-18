import 'package:flutter/material.dart';

class LoggedInNavbar extends StatelessWidget {
  const LoggedInNavbar({
    super.key,
    this.isNotHome = false,
  });

  final bool isNotHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: isNotHome,
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 5,
                ),
                child: const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 48.0,
                    semanticLabel: 'Go back to home',
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 5,
                  ),
                  child: const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.campaign,
                      color: Colors.white,
                      size: 48.0,
                      semanticLabel: 'Notifications and Announcement',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: 80.0,
                height: 80.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 5,
                  ),
                  child: const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 48.0,
                      semanticLabel: 'Profile',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
