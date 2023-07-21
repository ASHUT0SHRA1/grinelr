/*The purpose of each provider is commented to explain its functionality.
The notificationControllerProvider is a StateNotifierProvider that provides an instance of the NotificationController class.
The getLatestNotificationProvider is a StreamProvider that listens to the latest notifications using the getLatestNotification method.
The getNotificationsProvider is a FutureProvider that fetches notifications for a specific user using the getNotifications method.
The NotificationController class is a state notifier that handles the logic for creating and retrieving notifications.
The createNotification method creates a new notification using the provided parameters.
The getNotifications method retrieves notifications for a specific user and converts the response data into a list of Notification objects. */
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/apis/notification_api.dart';
import 'package:grinler/core/enums/notification_type_enum.dart';
import 'package:grinler/model/notification_model.dart' as model;

// Provider for the notification controller
final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
    notificationAPI: ref.watch(notificationAPIProvider),
  );
});

// Provider for getting the latest notification
final getLatestNotificationProvider = StreamProvider((ref) {
  final notificationAPI = ref.watch(notificationAPIProvider);
  return notificationAPI.getLatestNotification();
});

// Provider for getting notifications for a specific user
final getNotificationsProvider = FutureProvider.family((ref, String uid) async {
  final notificationController =
      ref.watch(notificationControllerProvider.notifier);
  return notificationController.getNotifications(uid);
});

// Notification controller class
class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;

  NotificationController({required NotificationAPI notificationAPI})
      : _notificationAPI = notificationAPI,
        super(false);

  // Method for creating a new notification
  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = model.Notification(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );

    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  // Method for getting notifications for a specific user
  Future<List<model.Notification>> getNotifications(String uid) async {
    final notifications = await _notificationAPI.getNotifications(uid);
    return notifications
        .map((e) => model.Notification.fromMap(e.data))
        .toList();
  }
}
