import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grinler/features/chat/view/chat_view.dart';
import 'package:grinler/features/explore/view/explore_view.dart';
import 'package:grinler/features/notifications/views/notification_view.dart';
import 'package:grinler/features/post/widgets/post_list.dart';
import 'package:grinler/features/user_profile/widget/user_profile.dart';
import 'package:grinler/theme/pallete.dart';
import '../model/user_model.dart';
import 'assets_constants.dart';

class UIConstants {
  // AppBar widget with customized design
  static AppBar appBar() {
    return AppBar(
      toolbarHeight: 50,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          "Grinler",
          style: GoogleFonts.pacifico(
            color: Pallete.grinlerColor,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actions: <Widget>[
        Builder(
          builder: (context) => IconButton(
            icon: SvgPicture.asset(
              AssetsConstants.dmOutlinedIcon,
              color: Pallete.whiteColor,
              height: 50,
            ),
            tooltip: 'Chat',
            onPressed: () {
              // Navigate to ChatPage when IconButton is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
          ),
        ), //IconButton
      ],
      backgroundColor: Pallete.backgroundColor,
      elevation: 60.0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  // List of pages for the bottom tab bar
  static List<Widget> bottomTabBarPages(UserModel currentUser) {
    return [
      const PostList(), // Display PostList page
      const ExploreView(), // Display ExploreView page
      const NotificationView(), // Display NotificationView page
      UserProfile(
          user: currentUser), // Display UserProfile page with the currentUser
    ];
  }
}
