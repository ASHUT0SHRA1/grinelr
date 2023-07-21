// ignore_for_file: library_private_types_in_public_api

import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/common/common.dart';
import 'package:grinler/features/auth/controllers/auth_controller.dart';
import 'package:grinler/model/user_model.dart';
import '../../../apis/user_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grinler/features/post/controller/post_controller.dart';
import 'package:grinler/features/post/widgets/post_card.dart';
import 'package:grinler/features/user_profile/controller/user_profile_controller.dart';
import 'package:grinler/features/user_profile/view/edit_profile_view.dart';
import 'package:grinler/features/user_profile/widget/follow_count.dart';
import 'package:grinler/model/post_model.dart';

import 'package:grinler/theme/pallete.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../../constants/appwrite_constants.dart';
enum _MenuValues { setting, logout, block, report }

class UserProfile extends ConsumerStatefulWidget {
  final UserModel user;

  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }
  bool isFollowing = false;

  void toggleFollowStatus() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    double bannerHeight = 150;
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : SafeArea(
      child: LiquidPullToRefresh(
        color: Pallete.grinlerColor,
        height: 50,
        backgroundColor: Pallete.whiteColor,
        onRefresh: _handleRefresh,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Stack(
                        children: [
                          SizedBox(
                            height: bannerHeight,
                            child: widget.user.bannerPic.isEmpty
                                ? Container(
                              color: Pallete.grinlerColor,
                            )
                                : CachedNetworkImage(
                              imageUrl: widget.user.bannerPic,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  LinearProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            right: 10,
                            child: CircleAvatar(
                              radius: 20,
                              child: PopupMenuButton<_MenuValues>(
                                icon: const Icon(
                                  Icons.menu,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                color: Colors.black,
                                itemBuilder: (BuildContext context) => [
                                  if (currentUser.uid == widget.user.uid)
                                    const PopupMenuItem(
                                      value: _MenuValues.setting,
                                      child: Text('Edit Profile'),
                                    ),
                                  if (currentUser.uid != widget.user.uid)
                                    const PopupMenuItem(
                                      value: _MenuValues.setting,
                                      child: Text('Block'),
                                    ),
                                  if (currentUser.uid == widget.user.uid)
                                    const PopupMenuItem(
                                      value: _MenuValues.logout,
                                      child: Text('Logout'),
                                    ),
                                  if (currentUser.uid != widget.user.uid)
                                    const PopupMenuItem(
                                      value: _MenuValues.setting,
                                      child: Text('Report'),
                                    ),
                                ],
                                onSelected: (value) {
                                  switch (value) {
                                    case _MenuValues.setting:
                                      if (currentUser.uid == widget.user.uid) {
                                        Navigator.push(context, EditProfileView.route());
                                      } else {
                                        ref.read(userProfileControllerProvider.notifier).followUser(
                                          user: widget.user,
                                          context: context,
                                          currentUser: currentUser,
                                        );
                                      }
                                      break;
                                    case _MenuValues.logout:
                                      ref.read(authControllerProvider.notifier).logout(context);
                                      break;
                                    case _MenuValues.block:
                                    // condition for blocking user uid
                                      break;
                                    case _MenuValues.report:
                                    // condition for reporting user uid
                                      break;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (currentUser.uid != widget.user.uid)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: FollowCount(
                                      count: widget.user.following.length,
                                      text: 'Following',
                                    ),
                                  ),
                                if (currentUser.uid != widget.user.uid)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: FollowCount(
                                      count: widget.user.followers.length,
                                      text: 'Followers',
                                    ),
                                  ),
                                if (currentUser.uid == widget.user.uid)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FollowingPage(user: currentUser)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: FollowCount(
                                        count: widget.user.following.length,
                                        text: 'Following',
                                      ),
                                    ),
                                  ),
                                if (currentUser.uid == widget.user.uid)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FollowersPage(user: currentUser)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: FollowCount(
                                        count: widget.user.followers.length,
                                        text: 'Followers',
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            transform: Matrix4.translationValues(0, -bannerHeight / 3, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.user.profilePic,
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    widget.user.name,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '@${widget.user.name}',
                                    style: const TextStyle(fontSize: 20, color: Pallete.greyColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Opacity(
                                    opacity: 1.0,
                                    child: Text(
                                      widget.user.bio,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 10,
                            thickness: 1,
                            color: Pallete.grinlerColor,
                          )
                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child: CachedNetworkImage(
                          //     imageUrl: user.profilePic,
                          //     imageBuilder: (context, imageProvider) =>
                          //         Container(
                          //       width: 80.0,
                          //       height: 80.0,
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         image: DecorationImage(
                          //             image: imageProvider, fit: BoxFit.cover),
                          //       ),
                          //     ),
                          //     placeholder: (context, url) =>
                          //         const CircularProgressIndicator(),
                          //     errorWidget: (context, url, error) =>
                          //         const Icon(Icons.error),
                          //   ),
                          // ),
                          // Align(
                          //   alignment: Alignment.topCenter,
                          //   child: Text(
                          //     user.name,
                          //     style: const TextStyle(
                          //         fontSize: 25, fontWeight: FontWeight.bold),
                          //   ),),
                          // Align(
                          //   alignment: Alignment.topCenter,
                          //   child: Text(
                          //     '@${user.name}',
                          //     style: const TextStyle(
                          //         fontSize: 20, color: Pallete.greyColor),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child: Opacity(
                          //     opacity: 1.0,
                          //     child: Text(
                          //       user.bio,
                          //       style: const TextStyle(
                          //         fontSize: 16,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     FollowCount(
                          //       count: user.following.length,
                          //       text: 'Following',
                          //     ),
                          //     FollowCount(
                          //       count: user.followers.length,
                          //       text: 'Followers',
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 15),
                          // const Divider(
                          //   color: Pallete.whiteColor,
                          // )

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(240, 46, 101, 1),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                ref.watch(userProfileControllerProvider.notifier).followUser(
                                  user: widget.user,
                                  context: context,
                                  currentUser: currentUser,
                                );
                                toggleFollowStatus();
                              },
                              child: SizedBox(
                                height: 30,
                                width: 110,
                                child: Center(
                                  child: Text(
                                    currentUser.following.contains(widget.user.uid) ? 'Unfollow' : 'Follow',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromRGBO(255, 255, 255, 1),
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to chat box of the user to message particular profile
                              },
                              child: const SizedBox(
                                height: 30,
                                width: 110,
                                child: Center(
                                  child: Text(
                                    "Message",
                                    style: TextStyle(
                                      color: Color.fromRGBO(240, 46, 101, 1),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 10,
                        thickness: 1,
                        color: Pallete.grinlerColor,
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: ref.watch(getUserPostsProvider(widget.user.uid)).when(
            data: (posts) {
              return ref.watch(getLatestPostProvider).when(
                data: (data) {
                  final latestPost = Post.fromMap(data.payload);

                  bool isPostAlreadyPresent = false;
                  for (final postModel in posts) {
                    if (postModel.id == latestPost.id) {
                      isPostAlreadyPresent = true;
                      break;
                    }
                  }
                  if (!isPostAlreadyPresent) {
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postsCollection}.documents.*.create',
                    )) {
                      posts.insert(0, Post.fromMap(data.payload));
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postsCollection}.documents.*.update',
                    )) {
                      final startingPoint = data.events[0].lastIndexOf('documents.');
                      final endPoint = data.events[0].lastIndexOf('.update');
                      final postId = data.events[0].substring(startingPoint + 10, endPoint);

                      var post = posts.where((element) => element.id == postId).first;
                      final postIndex = posts.indexOf(post);
                      posts.removeWhere((element) => element.id == postId);
                      post = Post.fromMap(data.payload);
                      posts.insert(postIndex, post);
                    }
                  }
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                      return PostCard(post: post);
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                      return PostCard(post: post);
                    },
                  );
                },
              );
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: (() => const Loader()),
          ),
        ),
      ),
    );

  }
}
class FollowersPage extends ConsumerStatefulWidget {
  final UserModel user;

  const FollowersPage({Key? key, required this.user}) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends ConsumerState<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final userAPI = ref.read(userAPIProvider);
    return currentUser == null
        ? const Loader()
        : SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Followers'),
        ),
        body: ListView.builder(
          itemCount: currentUser.followers.length,
          itemBuilder: (context, index) {
            final followerName = currentUser.followers[index];

            return FutureBuilder<model.Document>(
              future: userAPI.getUserData(followerName),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final followerData = snapshot.data!;
                  final followerProfilePicUrl = followerData.data['profilePic'];
                  final followerName1 = followerData.data['name'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(followerProfilePicUrl),
                    ),
                    title: Text(followerName1),
                    onTap: () {
                      // Handle follower item tap if needed
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error fetching follower data');
                }

                return const ListTile(
                  title: Text('Loading...'),
                );
              },
            );
          },
        ),
      ),
    );

  }
}
class FollowingPage extends ConsumerStatefulWidget {
  final UserModel user;

  const FollowingPage({Key? key, required this.user}) : super(key: key);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends ConsumerState<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final userAPI = ref.read(userAPIProvider);

    return currentUser == null
        ? const Loader()
        : SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Following"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 5, top: 10),
          child: ListView.builder(
            itemCount: currentUser.following.length,
            itemBuilder: (context, index) {
              final followingName = currentUser.following[index];

              return FutureBuilder<model.Document>(
                future: userAPI.getUserData(followingName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final followingData = snapshot.data!;
                    final followingProfilePicUrl = followingData.data['profilePic'];
                    final followerName1 = followingData.data['name'];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(followingProfilePicUrl),
                      ),
                      title: Text(followerName1),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching follower data');
                  }

                  return const ListTile(
                    title: Text('Loading...'),
                  );
                },
              );
            },
          ),
        ),
      ),
    );

  }
}
