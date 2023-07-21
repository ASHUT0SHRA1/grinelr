/*In this code, you have a StorageAPI class that handles file uploads to the Appwrite storage. The class takes an instance of the Storage class as a parameter, which is obtained through the appwriteStorageProvider.

The uploadImage method takes a list of File objects representing the files to be uploaded. It iterates over each file and uses the _storage.createFile method to upload it to the Appwrite storage. The bucketId specifies the target bucket for the file upload, and the fileId is set to a unique identifier for each file. The InputFile.fromPath method is used to create an InputFile object from the file path.

After each file is successfully uploaded, the method retrieves the image link using AppwriteConstants.imageUrl, passing in the uploaded image's ID. The image link is then added to the imageLinks list.

Finally, the uploadImage method returns the list of uploaded image links.

Overall, this code provides a convenient way to upload multiple files to the Appwrite storage and retrieve their corresponding image links.*/
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grinler/constants/constants.dart';
import 'package:grinler/core/providers.dart';

// Provider for accessing the StorageAPI
final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

// StorageAPI class for handling file uploads
class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];

    // Upload each file to the Appwrite storage
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      // Retrieve the image link and add it to the list
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }

    // Return the list of uploaded image links
    return imageLinks;
  }
}
