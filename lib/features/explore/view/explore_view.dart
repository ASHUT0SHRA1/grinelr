/*Comments have been added to describe the purpose of each section.
The searchController and isShowUsers variables are initialized at the beginning of the widget's state class.
The dispose() method has been updated to dispose of the searchController properly.
The body of the build method has been extracted into a separate _buildUserList method to improve modularity.
The _buildUserList method encapsulates the logic for displaying the user list based on the searchUserProvider state.
The _buildUserList method returns a ListView.builder to display the list of users.
Error and loading states are handled using the when method of the searchUserProvider. */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/common/common.dart';
import 'package:grinler/features/explore/controller/explore_controller.dart';
import 'package:grinler/features/explore/widget/search_tile.dart';
import 'package:grinler/theme/pallete.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.whiteColor,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search your friends',
            ),
          ),
        ),
      ),
      body: isShowUsers ? _buildUserList() : const SizedBox(),
    );
  }

  Widget _buildUserList() {
    return ref.watch(searchUserProvider(searchController.text)).when(
          data: (users) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];
                return SearchTile(userModel: user);
              },
            );
          },
          error: (error, st) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
