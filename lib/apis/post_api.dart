/*In this code, you have an IPostAPI abstract class that defines the contract for the PostAPI class. The PostAPI class implements the IPostAPI interface and provides the implementation for each method.

The postAPIProvider is a Riverpod provider that allows you to access an instance of the PostAPI class.

The PostAPI class uses the appwriteDatabaseProvider and appwriteRealtimeProvider to obtain instances of the Databases and Realtime classes, respectively. These instances are used to interact with the Appwrite database and real-time features.

The PostAPI class provides various methods such as sharePost, getPosts, getLatestPost, likePost, and others, which perform operations like creating documents, updating documents, and retrieving documents from the Appwrite database.

Overall, this code represents an API for interacting with the Appwrite backend and performing operations related to posts. */
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grinler/constants/constants.dart';
import 'package:grinler/core/core.dart';
import 'package:grinler/core/providers.dart';
import 'package:grinler/model/post_model.dart';

// Provider for accessing the PostAPI
final postAPIProvider = Provider((ref) {
  return PostAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

// Abstract class defining the contract for the PostAPI
abstract class IPostAPI {
  FutureEither<Document> sharePost(Post post);
  Future<List<Document>> getPosts();
  Stream<RealtimeMessage> getLatestPost();
  FutureEither<Document> likePost(Post post);
  FutureEither<Document> updateReshareCount(Post post);
  Future<List<Document>> getRepliesToPost(Post post);
  Future<Document> getPostById(String id);
  Future<List<Document>> getUserPosts(String uid);
  Future<List<Document>> getPostsByHashtag(String hashtag);
}

// Implementation of the PostAPI
class PostAPI implements IPostAPI {
  final Databases _db;
  final Realtime _realtime;

  PostAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> sharePost(Post post) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        documentId: ID.unique(),
        data: post.toMap(),
      );
      return right(document);
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
  Future<List<Document>> getPosts() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        queries: [Query.orderDesc('postedAt')]);

    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPost() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likePost(Post post) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        documentId: post.id,
        data: {
          "likes": post.likes,
        },
      );
      return right(document);
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
  FutureEither<Document> updateReshareCount(Post post) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        documentId: post.id,
        data: {
          "reshareCount": post.reshareCount,
        },
      );
      return right(document);
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
  Future<List<Document>> getRepliesToPost(Post post) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        queries: [
          Query.equal('repliedTo', post.id),
        ]);
    return document.documents;
  }

  @override
  Future<Document> getPostById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollection,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserPosts(String uid) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        queries: [Query.equal('uid', uid), Query.orderDesc('postedAt')]);

    return documents.documents;
  }

  @override
  Future<List<Document>> getPostsByHashtag(String hashtag) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollection,
      queries: [
        Query.search('hashtags', hashtag),
      ],
    );
    return documents.documents;
  }
}
