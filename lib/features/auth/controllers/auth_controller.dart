/*In this code, you have several providers and an AuthController class for handling authentication-related functionality in your app:

authControllerProvider: A StateNotifierProvider that creates an instance of AuthController and provides it to its descendants. It takes dependencies of authAPIProvider and userAPIProvider.

currentUserDetailsProvider: A FutureProvider that fetches the current user's details using the currentUserAccountProvider and userDetailsProvider providers.

userDetailsProvider: A FutureProvider.family that fetches user details for a specific user ID. It depends on the authControllerProvider to access the getUserData method.

currentUserAccountProvider: A FutureProvider that fetches the current user's account using the authControllerProvider.

The AuthController class extends StateNotifier<bool> and manages the authentication-related state and logic:

currentUser: A method that calls _authAPI.currentUserAccount() to get the current user's account.

signUp: A method that signs up a user by calling _authAPI.signUp() and then saves the user data using _userAPI.saveUserData(). It updates the state and shows a SnackBar based on the result.

login: A method that logs in a user by calling _authAPI.login(). It updates the state and shows a SnackBar based on the result. If successful, it navigates to the home view.

getUserData: A method that fetches user data by calling _userAPI.getUserData() and returns a UserModel object.

logout: A method that logs out a user by calling _authAPI.logout(). It navigates to the sign-up view after logging out.

Overall, this code provides authentication-related functionality, including sign-up, login, logout, and fetching user data, using the AuthController and related providers. */
import 'package:flutter/cupertino.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/apis/auth_api.dart';
import 'package:grinler/apis/user_api.dart';
import 'package:grinler/core/utils.dart';
import 'package:grinler/features/auth/view/login_view.dart';
import 'package:grinler/features/auth/view/signup_view.dart';
import 'package:grinler/features/home/view/home_view.dart';
import 'package:grinler/model/user_model.dart';
import 'package:grinler/constants/assets_constants.dart';

// Provider for AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

// Provider to fetch current user details
final currentUserDetailsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(currentUserAccountProvider).when(
      data: (data) {
        if (data != null) {
          final currentUserId = data.$id;
          final userDetails = ref.watch(
            userDetailsProvider(currentUserId),
          );
          return userDetails.value;
        } else {
          ref.invalidate(currentUserAccountProvider);
        }
        return null;
      },
      error: (error, st) => null,
      loading: () => null);
});

// Provider to fetch user details for a specific user ID
final userDetailsProvider = FutureProvider.family((ref, String uid) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// Provider to fetch the current user account
final currentUserAccountProvider = FutureProvider.autoDispose((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  final res = authController.currentUser();
  // res.asStream().listen((account) {
  //   debugPrint('LoggedInAccount:-  $account');
  // });
  return res;
  // return authController.currentUser();
});

// AuthController class
class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  // isLoading

  Future<model.User?> currentUser() => _authAPI.currentUserAccount();

  // Method to sign up a user
  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel userModel = UserModel(
        email: email,
        name: getNameFromEmail(email),
        followers: const [],
        following: const [],
        // profilePic: '',
        // change by Akhil
        //Passing default Piture
        profilePic: AssetsConstants.defaultProfilepic,
        //
        bannerPic: '',
        uid: r.$id,
        bio: '',
        isVerified: false,
      );
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Account created! Please login');
        Navigator.push(context, LoginView.route());
      });
    });
  }

  // Method to log in a user
  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      // ignore: avoid_print
      (r) {
        showSnackBar(context, 'welcome');
        Navigator.push(context, HomeView.route());
      },
    );
  }

// Method to fetch user data
  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

// Method to log out a user
  void logout(BuildContext context) async {
    final res = await _authAPI.logout();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
        (route) => false,
      );
    });
  }
}
