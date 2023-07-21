/*The NotificationTile class is a StatelessWidget that displays a single notification tile.
The notification parameter represents the notification data to be displayed in the tile.
The build method builds the UI for the notification tile.
The ListTile widget is used to display the notification.
The _buildLeadingIcon method determines the appropriate leading icon based on the notificationType of the notification.
Depending on the notification type, the method returns an Icon or an SvgPicture.asset widget with the corresponding icon.
The Text widget is used to display the notification text.
The code is modular as it separates the logic for determining the leading icon into a separate private method, _buildLeadingIcon().
Comments are provided throughout the code to explain the purpose and functionality of each section.*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grinler/constants/constants.dart';
import 'package:grinler/core/enums/notification_type_enum.dart';
import 'package:grinler/model/notification_model.dart' as model;
import 'package:grinler/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          _buildLeadingIcon(), // Display the appropriate leading icon based on the notification type
      title: Text(notification.text), // Display the notification text
    );
  }

  Widget? _buildLeadingIcon() {
    // Determine the appropriate leading icon based on the notification type
    switch (notification.notificationType) {
      case NotificationType.follow:
        return const Icon(
          Icons.person,
          color: Pallete.blueColor,
        );
      case NotificationType.like:
        return SvgPicture.asset(
          AssetsConstants.likeFilledIcon,
          color: Pallete.redColor,
          height: 20,
        );
      case NotificationType.repost:
        return SvgPicture.asset(
          AssetsConstants.repostIcon,
          color: Pallete.whiteColor,
          height: 20,
        );
      default:
        return null; // Return null if the notification type is not recognized
    }
  }
}
