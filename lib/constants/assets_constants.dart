class AssetsConstants {
  static const String _svgsPath = 'assets/svgs';
  static const String appLogo = '$_svgsPath/app_logo.svg';
  static const String homeFilledIcon = '$_svgsPath/home_filled.svg';
  static const String homeOutlinedIcon = '$_svgsPath/home_outlined.svg';
  static const String notifFilledIcon = '$_svgsPath/notif_filled.svg';
  static const String notifOutlinedIcon = '$_svgsPath/notif_outlined.svg';
  static const String searchFilledIcon = '$_svgsPath/search_filled.svg';
  static const String searchOutLinedIcon = '$_svgsPath/search_outlined.svg';
  static const String userFilledIcon = '$_svgsPath/user_filled.svg';
  static const String userOutlinedIcon = '$_svgsPath/user_outlined.svg';
  static const String dmFilledIcon = '$_svgsPath/dm_filled.svg';
  static const String dmOutlinedIcon = '$_svgsPath/dm_outlined.svg';
  static const String gifIcon = '$_svgsPath/gif.svg';
  static const String emojiIcon = '$_svgsPath/emoji.svg';
  static const String galleryIcon = '$_svgsPath/gallery.svg';
  static const String commentIcon = '$_svgsPath/comment.svg';
  static const String repostIcon = '$_svgsPath/repost.svg';
  static const String likeOutlinedIcon = '$_svgsPath/like_outlined.svg';
  static const String likeFilledIcon = '$_svgsPath/like_filled.svg';
  // Change By AKHIL
//Here I have added a default Profile Piture as if not set the app is throwing an error
// {
//Exception caught by image resource service ════════════════════════════
// The following ArgumentError was thrown resolving an image codec:
// Invalid argument(s): No host specified in URI file:///
// }
//It will be better if this default image will be stored firstly in storage of appwrite by making a new bucket for default pitures and then using that link address instead of below address.

  static const String defaultProfilepic =
      'https://cdn-icons-png.flaticon.com/512/1182/1182673.png?w=740&t=st=1686917230~exp=1686917830~hmac=19aa2c449bbe5d746c10e1f1df8db4f5bd3f6e4d6c446ce306925de1103d40ad';
  //
}
