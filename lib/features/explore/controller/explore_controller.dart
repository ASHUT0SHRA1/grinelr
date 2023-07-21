/*In this code, the ExploreController is a state notifier that provides functionality for searching users by name. It takes a UserAPI instance as a parameter.

The exploreControllerProvider is a state notifier provider that creates an instance of ExploreController and provides it to the widget tree.

The searchUserProvider is a future provider that takes a name parameter and asynchronously fetches the users matching the provided name using the ExploreController. It returns a Future that resolves to a list of UserModel objects.

The code has been commented to describe the purpose of each section and make it easier to understand the functionality of the ExploreController and related providers. */
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/apis/user_api.dart';
import 'package:grinler/model/user_model.dart';

// Provider for ExploreController
final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(
    userAPI: ref.watch(userAPIProvider),
  );
});

// Provider to search for users by name
final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);

  return exploreController.searchUser(name);
});

// ExploreController class
class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;

  ExploreController({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);

  // Method to search for users by name
  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
