/*In this code, you have an INotificationAPI abstract class that defines the contract for the NotificationAPI class. The NotificationAPI class implements the INotificationAPI interface and provides the implementation for each method.

The notificationAPIProvider is a Riverpod provider that allows you to access an instance of the NotificationAPI class.

The NotificationAPI class uses the appwriteDatabaseProvider and appwriteRealtimeProvider to obtain instances of the Databases and Realtime classes, respectively. These instances are used to interact with the Appwrite database and real-time features.

The NotificationAPI class provides methods such as createNotification, getNotifications, and getLatestNotification, which perform operations like creating documents, retrieving documents, and subscribing to real-time notifications in the Appwrite database.

Overall, this code represents an API for handling notifications in your app using the Appwrite backend. */
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grinler/constants/constants.dart';
import 'package:grinler/core/core.dart';
import 'package:grinler/core/providers.dart';
import 'package:grinler/model/notification_model.dart';

// Provider for accessing the NotificationAPI
final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

// Abstract class defining the contract for the NotificationAPI
abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<Document>> getNotifications(String uid);
  Stream<RealtimeMessage> getLatestNotification();
}

// Implementation of the NotificationAPI
class NotificationAPI implements INotificationAPI {
  final Databases _db;
  final Realtime _realtime;

  NotificationAPI({required Databases db, required Realtime realtime})
      : _realtime = realtime,
        _db = db;

  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollection,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notificationsCollection,
      queries: [Query.equal('uid', uid), Query.orderDesc('')],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollection}.documents'
    ]).stream;
  }
}
