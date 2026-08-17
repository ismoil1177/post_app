import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:post_app/models/message_model.dart';
import 'package:post_app/models/post_model.dart';
import 'package:post_app/models/user_model.dart';
import 'package:post_app/services/auth_service.dart';
import 'package:post_app/services/store_service.dart';

sealed class DBService {
  static final db = FirebaseDatabase.instance;
  static const _queryTimeout = Duration(seconds: 2);

  static List<Post> _parsePosts(Object? value) {
    if (value == null) return [];
    final decoded = jsonDecode(jsonEncode(value));
    if (decoded is! Map) return [];
    final uid = AuthService.user.uid;
    final posts = <Post>[];
    for (final item in decoded.values) {
      if (item is! Map) continue;
      try {
        final map = Map<String, Object?>.from(item);
        posts.add(Post.fromJson(map, isMe: map["userId"] == uid));
      } catch (e) {
        debugPrint("POST PARSE ERROR: $e");
      }
    }
    return posts;
  }

  static Future<List<Post>> _readPosts() async {
    try {
      final snapshot = await db.ref(Folder.post).get().timeout(_queryTimeout);
      return _parsePosts(snapshot.value);
    } on FirebaseException catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  /// post
  static Future<bool> storePost(
      String title, String content, bool isPublic, File file) async {
    try {
      final folder = db.ref(Folder.post);
      final child = folder.push();
      final id = child.key!;
      final userId = AuthService.user.uid;
      final imageUrl = await StoreService.uploadFile(file);
      final post = Post(
          id: id,
          title: title,
          content: content,
          userId: userId,
          imageUrl: imageUrl,
          isPublic: isPublic,
          createdAt: DateTime.now(),
          comments: []);
      await child.set(post.toJson());
      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }

  static Future<List<Post>> readAllPost() async {
    try {
      return await _readPosts();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<bool> deletePost(String postId) async {
    try {
      final fbPost = db.ref(Folder.post).child(postId);
      await fbPost.remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updatePost(
      String postId, String title, String content, bool isPublic) async {
    try {
      final fbPost = db.ref(Folder.post).child(postId);
      await fbPost
          .update({"title": title, "content": content, "isPublic": isPublic});

      // fbPost.set(post.toJson());
      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }

  static Future<List<Post>> searchPost(String text,
      [SearchType type = SearchType.all]) async {
    try {
      final query = text.toLowerCase();
      final data = await _readPosts();
      final matched =
          data.where((post) => post.title.toLowerCase().startsWith(query));

      switch (type) {
        case SearchType.all:
          return matched.where((element) => element.isPublic == true).toList();
        case SearchType.me:
          return matched
              .where((element) => element.userId == AuthService.user.uid)
              .toList();
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Post>> publicPost([bool isPublic = true]) async {
    try {
      final posts = await _readPosts();
      return posts.where((post) => post.isPublic == isPublic).toList();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  static Future<List<Post>> myPost() async {
    try {
      final uid = AuthService.user.uid;
      final posts = await _readPosts();
      return posts.where((post) => post.userId == uid).toList();
    } catch (e) {
      debugPrint("ERROR: $e");
      return [];
    }
  }

  /// user
  static Future<bool> storeUser(
      String email, String password, String username, String uid) async {
    try {
      final folder = db.ref(Folder.user).child(uid);
      final member = Member(
          uid: uid, username: username, email: email, password: password);
      await folder.set(member.toJson());
      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }

  static Future<Member?> readUser(String uid) async {
    try {
      final data = db.ref(Folder.user).child(uid).get();
      final member =
          Member.fromJson(jsonDecode(jsonEncode(data)) as Map<String, Object>);
      return member;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return null;
    }
  }

  /// Message
  static Future<bool> writeMessage(
      String postId, String message, List<Message> old) async {
    try {
      final post = db.ref(Folder.post).child(postId);

      final msg = Message(
          id: "${old.length + 1}",
          message: message,
          writtenAt: DateTime.now(),
          userId: AuthService.user.uid,
          userImage: AuthService.user.photoURL,
          username: AuthService.user.displayName!);
      old.add(msg);

      post.update({
        "comments": old.map((e) => e.toJson()).toList(),
      });
      return true;
    } catch (e) {
      debugPrint("DB ERROR: $e");
      return false;
    }
  }
}

sealed class Folder {
  static const post = "Post";
  static const user = "User";
  static const postImages = "PostImage";
}

enum SearchType {
  all,
  me,
}
