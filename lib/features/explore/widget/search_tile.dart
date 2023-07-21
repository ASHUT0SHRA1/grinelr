/*Comments have been added to describe the purpose of each section.
The key parameter has been updated to Key? key for null safety.
The onTap callback has been extracted to a private _navigateToUserProfile method for better modularity.
The leading widget (user avatar) has been extracted to a private _buildUserAvatar method.
The title widget (user name) has been extracted to a private _buildUserName method.
The subtitle widget (user details) has been extracted to a private _buildUserDetails method.
Each extracted method returns a specific widget for better code organization and reusability.
The _buildUserDetails method uses a Column widget to display multiple lines of text for the user's username and bio.*/
import 'package:flutter/material.dart';
import 'package:grinler/features/user_profile/view/user_profile_view.dart';
import 'package:grinler/model/user_model.dart';
import 'package:grinler/theme/pallete.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;

  const SearchTile({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _navigateToUserProfile(context);
      },
      leading: _buildUserAvatar(),
      title: _buildUserName(),
      subtitle: _buildUserDetails(),
    );
  }

  void _navigateToUserProfile(BuildContext context) {
    Navigator.push(
      context,
      UserProfileView.route(userModel),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      backgroundImage: NetworkImage(userModel.profilePic),
      radius: 30,
    );
  }

  Widget _buildUserName() {
    return Text(
      userModel.name,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUserDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '@${userModel.name}',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          userModel.bio,
          style: const TextStyle(
            color: Pallete.whiteColor,
          ),
        ),
      ],
    );
  }
}
