import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grinler/constants/constants.dart';
import 'package:grinler/features/post/view/create_post_view.dart';
import 'package:grinler/model/user_model.dart';
import 'package:grinler/theme/pallete.dart';
import '../../../common/loading_page.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const HomeView());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );

    if (currentUser == null) {
      return const Loader(); // Show loader if currentUser is null
    }

    return _HomeViewContent(currentUser: currentUser);
  }
}

class _HomeViewContent extends StatefulWidget {
  final UserModel currentUser;

  const _HomeViewContent({required this.currentUser});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeViewContent> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  void onCreatePost() {
    Navigator.push(
        context, CreatePostScreen.route()); // Navigate to CreatePostScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _page == 0 ? UIConstants.appBar() : null, // Show appBar for page 0
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages(
            widget.currentUser), // Show different pages based on _page index
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            onCreatePost, // Call onCreatePost method when FloatingActionButton is pressed
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      // drawer: const SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange, // Call onPageChange method when a tab is tapped
        backgroundColor: Pallete.backgroundColor,
        items: _buildBottomNavigationBarItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      _buildBottomNavigationBarItem(
        _page == 0
            ? AssetsConstants.homeFilledIcon
            : AssetsConstants.homeOutlinedIcon,
      ),
      _buildBottomNavigationBarItem(
        _page == 1
            ? AssetsConstants.searchFilledIcon
            : AssetsConstants.searchOutLinedIcon,
      ),
      _buildBottomNavigationBarItem(
        _page == 2
            ? AssetsConstants.notifFilledIcon
            : AssetsConstants.notifOutlinedIcon,
      ),
      _buildBottomNavigationBarItem(
        _page == 3
            ? AssetsConstants.userFilledIcon
            : AssetsConstants.userOutlinedIcon,
      ),
    ];
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(String assetPath) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        color: Pallete.whiteColor,
      ),
    );
  }
}
