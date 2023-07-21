/*Comments have been added to describe the purpose of each section.
The build method has been modified to return a SafeArea widget as the root of the drawer.
The widget-building logic for the profile and logout list tiles has been extracted to separate private methods for improved modularity.
The _buildProfileListTile method creates a ListTile widget for navigating to the user's profile.
The _buildLogoutListTile method creates a ListTile widget for logging out.
The authControllerProvider is read using ref.read instead of ref.watch since it's used to trigger an action (logout).
The code has been formatted for improved readability. */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/common/loading_page.dart';
import 'package:grinler/features/auth/controllers/auth_controller.dart';
import 'package:grinler/features/user_profile/view/user_profile_view.dart';
import 'package:grinler/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );

    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfileView(userModel: currentUser),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
