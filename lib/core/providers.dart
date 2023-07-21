/*In this code, you have a set of Riverpod providers for different components of the Appwrite SDK:

appwriteClientProvider: Creates and configures an instance of the Appwrite client. It sets the Appwrite endpoint URL, project ID, and enables self-signed certificates if required.

appwriteAccountProvider: Provides access to the Appwrite account API by taking an instance of the appwriteClientProvider and returning an Account object.

appwriteDatabaseProvider: Provides access to the Appwrite database API by taking an instance of the appwriteClientProvider and returning a Databases object.

appwriteStorageProvider: Provides access to the Appwrite storage API by taking an instance of the appwriteClientProvider and returning a Storage object.

appwriteRealtimeProvider: Provides access to the Appwrite realtime API by taking an instance of the appwriteClientProvider and returning a Realtime object.

These providers can be used in your application to obtain instances of the Appwrite client and different API services. The configuration is based on the values provided in the AppwriteConstants file. */
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/constants/constants.dart';

// Provider for creating and configuring the Appwrite client
final appwriteClientProvider = Provider((ref) {
  // Create a new instance of the Appwrite client
  Client client = Client();

  // Configure the client with the Appwrite endpoint, project ID, and self-signed certificate status
  return client
      .setEndpoint(AppwriteConstants.endPoint) // Set the Appwrite endpoint URL
      .setProject(AppwriteConstants.projectId) // Set the Appwrite project ID
      .setSelfSigned(
          status:
              true); // Enable self-signed certificates (for development/testing purposes)
});

// Provider for accessing the Appwrite account API
final appwriteAccountProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

// Provider for accessing the Appwrite database API
final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

// Provider for accessing the Appwrite storage API
final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

// Provider for accessing the Appwrite realtime API
final appwriteRealtimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});
